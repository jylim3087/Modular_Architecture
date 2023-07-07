//
//  ChoosableGroupComponent.swift
//  DabangPro
//
//  Created by 조동현 on 2022/01/26.
//

import UIKit
import Then
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

public class ChoosableGroupComponent<Component: ChoosableComponentable>: UIView, ChoosableGroupComponentable {
    
    enum Axis {
        case row
        case column
    }
    
    // MARK: - UI
    
    private let titleView = UIView().then {
        $0.backgroundColor = .clear
        $0.isHidden = true
    }
    
    private let titleLabel = Body3_Bold()
    
    private let requiredLabel = Body3_Bold().then {
        $0.text = "*"
        $0.textColor = .blue500
    }
    
    private let allView = UIView().then {
        $0.backgroundColor = .clear
        $0.isHidden = true
    }
    
    private lazy var allComponent = Component().then {
        $0.title = "전체"
        $0.tag = -1
    }
    
    private let bodyView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    // MARK: - Propety
    
    private var disposeBag = DisposeBag()
    
    private var selectors: [Component] {
        bodyView.subviews.compactMap { $0 as? Component }
    }
    
    private var selectedDisposeBag = DisposeBag()
    
    private lazy var isMultipleSelection: Bool = {
        guard let choosableGroup = self as? ChoosableGroupMultipleSupportable else { return true }
        return choosableGroup.isMultipleSelection
    }()
    
    private lazy var hasTitle: Bool = {
        guard let choosableGroup = self as? ChoosableGroupTitleSupportable else { return false }
        return choosableGroup.hasTitle
    }()
    
    private lazy var isRequired: Bool = {
        guard let choosableGroup = self as? ChoosableGroupTitleSupportable else { return false }
        return choosableGroup.isRequired
    }()
    
    // MARK: - Input Property
    
    var selectedIndexs: [Int] = [] {
        didSet {
            let total = items.count
            selectedIndexs.removeAll(where: { $0 >= total || $0 < 0 })
            
            if isMultipleSelection == false {
                selectedIndexs = Array(selectedIndexs.prefix(1))
            }
            
            arrangeSelection()
        }
    }
    
    public var items: [ChoosableGroupItemType] = [] {
        didSet {
            selectedDisposeBag = DisposeBag()
            selectedIndexs = []
            bodyView.subviews.forEach { $0.removeFromSuperview() }
            
            items.enumerated().forEach { [weak self] (index, item) in
                let component = makeItem(index, title: item.title)
                self?.bodyView.flex.addItem(component).minHeight(40).paddingRight(16)
            }
            
            flex.layout()
        }
    }
    
    var axis: Axis = .row {
        didSet {
            if axis == .row {
                bodyView.flex.direction(.row).wrap(.wrap)
            } else {
                bodyView.flex.direction(.column).wrap(.noWrap)
            }
            
            flex.layout()
        }
    }
    
    var useAll: Bool = false {
        didSet {
            if !isMultipleSelection {
                useAll = false
            }
            
            allView.flex.isHidden(!useAll)
        }
    }
    
    public var title: String? {
        didSet {
            titleLabel.text = title
            titleLabel.flex.markDirty()
            
            setNeedsLayout()
        }
    }
    
    var isEnabled: Bool = true {
        didSet {
            allComponent.isEnabled = isEnabled
            selectors.forEach { [unowned self] in $0.isEnabled = self.isEnabled }
        }
    }
    
    var keepOne: Bool = false
    
    var isAll: Bool {
        guard !selectors.isEmpty else { return false }
        
        let tags = selectors.map { $0.tag }.sorted()
        return tags == selectedIndexs.sorted()
    }
    
    // MARK: - Output Property
    
    let itemSelected = PublishSubject<(Int, Bool)>()
    
    let modelSelected = PublishSubject<(ChoosableGroupItemType?, Bool)>()
    
    let itemListSelected = PublishSubject<[Int]>()
    
    let modelListSelected = PublishSubject<[ChoosableGroupItemType]>()
    
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
        initStyle()
        bind()
    }
    
    private func bind() {
        let share = allComponent.select
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .do (onNext: { (weakSelf, component) in
                if weakSelf.keepOne {
                    component.isSelected = true
                }
                
                if component.isSelected {
                    let indexs = Array(0..<weakSelf.items.count)
                    weakSelf.selectedIndexs = indexs
                } else {
                    weakSelf.selectedIndexs.removeAll()
                }
            })
            .share()
                
        share
            .compactMap { (_, component) in
                (nil, component.isSelected)
            }
            .bind(to: modelSelected)
            .disposed(by: disposeBag)
        
        share
            .compactMap { (_, component) in
                (component.tag, component.isSelected)
            }
            .bind(to: itemSelected)
            .disposed(by: disposeBag)
        
        share
            .compactMap { (weakSelf, _) in
                weakSelf.selectedIndexs.map { weakSelf.items[$0] }
            }
            .bind(to: modelListSelected)
            .disposed(by: disposeBag)
        
        share
            .compactMap { (weakSelf, _) in
                weakSelf.selectedIndexs
            }
            .bind(to: itemListSelected)
            .disposed(by: disposeBag)
    }
}

extension ChoosableGroupComponent {
    private func initLayout() {
        flex.addItem(titleView).direction(.row).isHidden(true).marginBottom(8).define { flex in
            flex.addItem(titleLabel)
            flex.addItem(requiredLabel).marginLeft(4)
        }
        flex.addItem(allView).isHidden(true).marginBottom(0).define { flex in
            flex.addItem(allComponent).minHeight(40)
        }
        flex.addItem(bodyView).direction(.row).wrap(.wrap)
        
        flex.layout()
    }
    
    private func initStyle() {
        titleView.flex.isHidden(!hasTitle)
        requiredLabel.flex.isHidden(!isRequired)
        allView.flex.isHidden(!useAll)
    }
    
    private func makeItem(_ index: Int, title: String?) -> Component {
        let component = Component()
        component.title = title
        component.tag = index
        component.isEnabled = isEnabled
        
        let share = component.select
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .do(onNext: { (weakSelf, component) in
                var selectedIndexs = Set(weakSelf.selectedIndexs)
                
                if weakSelf.keepOne, selectedIndexs.count == 1, selectedIndexs.contains(component.tag) {
                    component.isSelected = true
                }
                
                if weakSelf.useAll, weakSelf.isAll {
                    selectedIndexs.removeAll()
                }
                
                if weakSelf.isMultipleSelection == false,
                   let select = weakSelf.selectedIndexs.first,
                   let v = weakSelf.selectors.first(where: { $0.tag == select }) {
                    if v == component {
                        v.isSelected = true
                    } else {
                        selectedIndexs.removeAll()
                        v.isSelected = false
                    }
                }
                
                if component.isSelected {
                    selectedIndexs.insert(component.tag)
                } else {
                    selectedIndexs.remove(component.tag)
                }
                
                weakSelf.selectedIndexs = Array(selectedIndexs).sorted()
            })
            .share()
        
        share
            .compactMap { (weakSelf, component) in
                return (weakSelf.items[component.tag], component.isSelected)
            }
            .bind(to: modelSelected)
            .disposed(by: selectedDisposeBag)
        
        share
            .compactMap { (_, component) in
                return (component.tag, component.isSelected)
            }
            .bind(to: itemSelected)
            .disposed(by: selectedDisposeBag)
        
        share
            .compactMap { (weakSelf, _) in
                weakSelf.selectedIndexs.map { weakSelf.items[$0] }
            }
            .bind(to: modelListSelected)
            .disposed(by: selectedDisposeBag)
        
        share
            .compactMap { (weakSelf, _) in
                weakSelf.selectedIndexs
            }
            .bind(to: itemListSelected)
            .disposed(by: selectedDisposeBag)
        
        return component
    }
    
    private func arrangeSelection() {
        if useAll, isAll {
            allComponent.isSelected = true
            selectors.forEach { $0.isSelected = false }
        } else {
            allComponent.isSelected = false
            selectors
                .forEach { [weak self] v in
                    v.isSelected = self?.selectedIndexs.contains(where: { v.tag == $0 }) ?? false
                }
        }
    }
}

extension Reactive where Base: ChoosableGroupComponentable {
    var items: Binder<[ChoosableGroupItemType]> {
        return Binder(base) { component, items in
            component.items = items
        }
    }
    
    var title: Binder<String?> {
        return Binder(base) { component, title in
            component.title = title
        }
    }
}
