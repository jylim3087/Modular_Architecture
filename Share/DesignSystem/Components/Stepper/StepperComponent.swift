//
//  StepperComponent.swift
//  DabangPro
//
//  Created by 조동현 on 2023/03/06.
//

import UIKit
import Then
import PinLayout
import FlexLayout
import RxSwift
import RxCocoa

public class StepperComponent: UIView, StepperComponentable {
    
    // MARK: - UI
    
    private let bodyView = UIView().then {
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor.gray300.cgColor
        $0.layer.borderWidth = 1
        $0.clipsToBounds = true
    }
    
    private let minusButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "ic_24_minus2_gray700"), for: .normal)
        $0.setImage(UIImage(named: "ic_24_minus2_gray500"), for: .disabled)
    }
    
    private let plusButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "ic_24_plus_gray700"), for: .normal)
        $0.setImage(UIImage(named: "ic_24_plus_gray500"), for: .disabled)
    }
    
    private lazy var textField = UITextField().then {
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.smartDashesType = .no
        $0.smartInsertDeleteType = .no
        $0.autocapitalizationType = .none
        
        $0.font = .body3_bold
        $0.textColor = .gray900
        $0.keyboardType = .numberPad
        $0.textAlignment = .center
        $0.delegate = self
        $0.text = "0"
    }
    
    // MARK: - Property
    
    private var disposeBag = DisposeBag()
    
    private let focusObserver = PublishSubject<Bool>()
    
    private let textObserver = PublishRelay<String>()
    
    public var value: Int {
        set {
            setValue(newValue)
        }
        
        get {
            Int(textField.text ?? "\(minValue)") ?? minValue
        }
    }
    
    public var minValue: Int = 0 {
        didSet {
            setValue(value)
        }
    }
    
    public var maxValue: Int = 99 {
        didSet {
            setValue(value)
        }
    }
    
    public var valueChanged = PublishRelay<Int>()
    
    public var isEnabled: Bool = true {
        didSet {
            textField.isEnabled = isEnabled
            textField.textColor = isEnabled ? .gray900 : .gray300
            minusButton.isEnabled = isEnabled
            plusButton.isEnabled = isEnabled
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initComponent()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initComponent()
        
    }
    
    private func initComponent() {
        initLayout()
        bind()
    }
    
    private func bind() {
        bindState()
        bindAction()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        bodyView.pin.all()
        bodyView.flex.layout(mode: .adjustWidth)
    }
}

extension StepperComponent {
    private func initLayout() {
        addSubview(bodyView)
        
        bodyView.flex.minWidth(124).height(40).direction(.row).grow(1).shrink(1).define { flex in
            flex.addItem(minusButton).width(44)
            flex.addItem().justifyContent(.center).grow(1).shrink(1).define { flex in
                flex.addItem(textField)
            }
            flex.addItem(plusButton).width(44)
        }
    }
    
    private func bindState() {
        textObserver
            .map { [weak self] in Int($0) ?? self?.minValue ?? 0 }
            .bind(to: valueChanged)
            .disposed(by: disposeBag)
        
        focusObserver
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] focus in
                guard let self = self else { return }
                
                self.bodyView.layer.borderColor = focus ? UIColor.gray900.cgColor : UIColor.gray300.cgColor
                
                if !focus {
                    self.textField.resignFirstResponder()
                    
                    let minStr = "\(self.minValue)"
                    if let number = Int(self.textField.text ?? minStr) {
                        if number < self.minValue {
                            self.textField.text = minStr
                            self.textObserver.accept(minStr)
                        }
                    }
                }
                
            })
            .disposed(by: disposeBag)
    }
    
    private func bindAction() {
        Observable.of(minusButton.rx.tap.map { -1 }, plusButton.rx.tap.map { 1 })
            .merge()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] step in
                self?.textField.resignFirstResponder()
                self?.changeValue(step)
            })
            .disposed(by: disposeBag)
        
        textField.rx.controlEvent(.editingChanged)
            .withLatestFrom(textField.rx.text.orEmpty)
            .bind(to: textObserver)
            .disposed(by: disposeBag)
        
        Observable.of(textField.rx.controlEvent(.editingDidBegin).map { _ in true },
                      textField.rx.controlEvent(.editingDidEnd).map { _ in false },
                      textField.rx.controlEvent(.editingDidEndOnExit).map { _ in false })
            .merge()
            .bind(to: focusObserver)
            .disposed(by: disposeBag)
    }
    
    private func changeValue(_ step: Int) {
        var value = self.value
        
        value += step
        
        guard value >= minValue, value <= maxValue else { return }
        
        textField.text = "\(value)"
        textObserver.accept("\(value)")
        
        textField.flex.markDirty()
        flex.layout(mode: .adjustWidth)
    }
    
    private func setValue(_ value: Int) {
        var value = value
        
        if value < minValue {
            value = minValue
        } else if value > maxValue {
            value = maxValue
        }
        
        textField.text = "\(value)"
    }
}

extension StepperComponent: UITextFieldDelegate {

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        focusObserver.onNext(false)

        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[0-9]*$", options: .caseInsensitive)
        if regex.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.count)) == nil {
            return false
        }
        
        let nsString = textField.text as NSString?
        let newString = nsString?.replacingCharacters(in: range, with: string) ?? ""
        
        return inputCheck(origin: textField.text, new: newString)
    }
    
    func inputCheck(origin: String?, new: String) -> Bool {
        if new.isEmpty {
            textField.text = "0"
            textObserver.accept("0")
            return false
        }
        
        let maxStr = "\(maxValue)"
        if origin != "0" && new.count > maxStr.count {
            return false
        }
        
        if let number = Int(new), number > maxValue {
            textField.text = maxStr
            textObserver.accept(maxStr)
            return false
        }
        
        
        if origin == "0" {
            textField.text = ""
        }
        
        return true
    }
}
