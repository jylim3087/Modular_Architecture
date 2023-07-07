//
//  PickerView.swift
//  DabangPro
//
//  Created by 조동현 on 2023/03/02.
//

import UIKit
import RxSwift
import RxCocoa
import PinLayout
import FlexLayout

public class PickerView: UIView, PickerViewComponentable {
    typealias Picker = PickerComponent<DefaultPickerItemView>
    
    // MARK: - UI
    
    private let bodyView = UIView()
    
    private let topShadowView = UIView().then {
        $0.isUserInteractionEnabled = false
    }
    
    private let bottomShadowView = UIView().then {
        $0.isUserInteractionEnabled = false
    }
    
    private let pickerWrapView = UIView()
    
    private var pickers: [Picker] = []
    
    // MARK: - Property
    
    private var disposeBag = DisposeBag()
    private var itemDisposeBag = DisposeBag()
    
    var itemSelected = PublishSubject<[Int]>()
    
    var items: [[PickerItemType]] = [] {
        didSet {
            addPicker()
            setNeedsLayout()
        }
    }
    
    public var selectedIndex: [Int] {
        set {
            setSelected(newValue)
        }
        
        get {
            pickers.map { $0.selectedIndex }
        }
    }
    
    public var gradientColor: UIColor = .gray100 {
        didSet {
            setShadow(topShadowView, bounds: topShadowView.frame, rotate: CGFloat(0.0))
            
            var frame = bottomShadowView.frame
            frame.origin = .zero
            setShadow(bottomShadowView, bounds: frame, rotate: CGFloat(180.0))
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
        backgroundColor = .gray100
        layer.cornerRadius = 2
        
        initLayout()
        bind()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        bodyView.pin.all()
        bodyView.flex.layout()
    }
    
    private func bind() {
        bindShadowView()
    }
}

extension PickerView {
    private func initLayout() {
        addSubview(bodyView)
        
        bodyView.flex.minHeight(190).grow(1).shrink(1).define { flex in
            flex.addItem(pickerWrapView).grow(1).shrink(1).direction(.row).justifyContent(.center)
            flex.addItem(topShadowView).position(.absolute).top(0).horizontally(0).height(40%)
            flex.addItem(bottomShadowView).position(.absolute).bottom(0).horizontally(0).height(40%)
        }
    }
    
    private func bindShadowView() {
        let topShadow = topShadowView.rx.observe(CGRect.self, #keyPath(UIView.frame))
            .compactMap { $0 }
            .distinctUntilChanged()
            .map { [weak self] bounds -> (UIView?, CGRect, CGFloat) in
                return (self?.topShadowView, bounds, CGFloat(0.0))
            }
        
        let bottomShadow = bottomShadowView.rx.observe(CGRect.self, #keyPath(UIView.frame))
            .compactMap { $0 }
            .map { $0.size }
            .distinctUntilChanged()
            .map { [weak self] size -> (UIView?, CGRect, CGFloat) in
                let bounds = CGRect(origin: .zero, size: size)
                return (self?.bottomShadowView, bounds, CGFloat(180.0))
            }
        
        Observable.merge(topShadow, bottomShadow)
            .subscribe(onNext: { [weak self] (view, bounds, rotate) in
                self?.setShadow(view, bounds: bounds, rotate: rotate)
            })
            .disposed(by: disposeBag)
    }
    
    private func setShadow(_ view: UIView?, bounds: CGRect, rotate: CGFloat) {
        if let layer = view?.layer.sublayers?.first as? CAGradientLayer {
            layer.removeFromSuperlayer()
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.colors = [gradientColor.withAlphaComponent(1.0).cgColor,
                                gradientColor.withAlphaComponent(0.0).cgColor]
        gradientLayer.transform = CATransform3DMakeRotation(rotate / 180.0 * CGFloat.pi, 0, 0, 1)
        gradientLayer.frame = bounds
        view?.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func addPicker() {
        pickerWrapView.subviews.forEach { $0.removeFromSuperview() }
        
        items.enumerated().forEach { (index, items) in
            if let picker = pickers[exist: index] {
                setPicker(picker, index: index, items: items, selectedIndex: selectedIndex[exist: index] ?? 0)
                pickerWrapView.flex.addItem(picker)
            } else {
                pickerWrapView.flex.define { flex in
                    let picker = Picker()
                    setPicker(picker, index: index, items: items, selectedIndex: selectedIndex[exist: index] ?? 0)
                    flex.addItem(picker)
                    pickers.append(picker)
                }
            }
        }
        
        bindPicker()
    }
    
    private func setPicker(_ picker: Picker, index: Int, items: [PickerItemType], selectedIndex: Int) {
        let itemCount = self.items.count
        
        picker.items = items
        picker.alignment = itemCount == 1 ? .center : (index == 0 ? .end : .start)
        picker.selectedIndex = selectedIndex
        
        if index > 0 && index < (itemCount - 1) {
            picker.flex.grow(0).shrink(0)
        } else {
            picker.flex.grow(1).shrink(1)
        }
    }
    
    private func bindPicker() {
        itemDisposeBag = DisposeBag()
        
        Observable.from(pickers.map { $0.itemSelected })
            .merge()
            .map { [weak self] _ in
                guard let self = self else {
                    return Array(repeating: 0, count: self?.pickers.count ?? 0)
                }
                
                return self.pickers.map { $0.selectedIndex }
            }
            .bind(to: itemSelected)
            .disposed(by: itemDisposeBag)
    }
    
    private func setSelected(_ selectedIndexs: [Int]) {
        selectedIndexs.enumerated().forEach { (index, selectedIndex) in
            guard let picker = pickers[exist: index], picker.selectedIndex != selectedIndex else { return }
            picker.selectedIndex = selectedIndex
        }
    }
}

extension Array {
    subscript (exist index: Int) -> Element? {
        return startIndex <= index && index < endIndex ? self[index] : nil
    }
}
