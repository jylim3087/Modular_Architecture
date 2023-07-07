//
//  SelectableComponent.swift
//  DabangPro
//
//  Created by 조동현 on 2023/02/13.
//

import UIKit
import Then
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

public class SelectableComponent<SelectableStyle: SelectableStyleSupportable>: UIView, SelectableComponentable {
    
    // MARK: - UI
    
    public let titleLabel = Body3_Bold()
    
    public let button = UIButton(type: .custom)
    
    // MARK: - Property
    
    var disposeBag = DisposeBag()
    
    public var style = SelectableStyle()
    
    public var title: String?
    
    public var font: UIFont = .body3_bold
    
    public var isHiddenTitle: Bool = false
    
    public var isSelected: Bool = false {
        didSet {
            style.status(isSelected: isSelected, isEnabled: isEnabled)
            setStyle()
        }
    }
    
    public var isEnabled: Bool = true {
        didSet {
            button.isEnabled = isEnabled
            
            style.status(isSelected: isSelected, isEnabled: isEnabled)
            setStyle()
        }
    }
    
    public var isDelayTouched: Bool = false
    
    public var select = PublishSubject<SelectableComponentable>()
    
    public var delayTouchedObs: PublishSubject<(Int, PublishSubject<Bool>)> = PublishSubject()
    
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
        setStyle()
        bind()
    }
    
    private func bind() {
        button.rx.tap
            .concatMap { [weak self] _ -> Observable<Bool> in
                guard let self = self else { return .just(false) }
                return self.delayTouched()
            }
            .filter { $0 }
            .compactMap { [weak self] _ in
                self?.isSelected.toggle()
                return self
            }
            .bind(to: select)
            .disposed(by: disposeBag)
    }
    
    func initLayout() {
        layer.cornerRadius = 8
        layer.borderWidth = 1
    }
    
    func setStyle() {
        backgroundColor = style.backgroundColor
        layer.borderColor = style.borderColor?.cgColor
    }
    
    private func delayTouched() -> Observable<Bool> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(DeleyTouchError.none))
                return Disposables.create()
            }
            
            guard self.isDelayTouched, self.delayTouchedObs.hasObservers else {
                single(.success(true))
                return Disposables.create()
            }
            
            let delayTouchResObs = PublishSubject<Bool>()
            
            let disposable = delayTouchResObs
                .subscribe(onNext: { touch in
                    single(.success(touch))
                })
            
            self.delayTouchedObs.onNext((self.tag, delayTouchResObs))
            
            return disposable
        }
        .asObservable()
        .subscribe(on: MainScheduler.instance)
    }
    
    enum DeleyTouchError: Error {
        case none
        case cancel
    }
}
