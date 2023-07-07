//
//  SelectableGroupComponent.swift
//  DabangPro
//
//  Created by 조동현 on 2023/02/14.
//

import UIKit
import Then
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

public class SelectableGroupComponent: UIView, SelectableGroupComponentable {
    
    // MARK: - UI
    
    private let topView = UIView().then {
        $0.backgroundColor = .clear
        $0.isHidden = true
    }
    
    private let titleView = UIView().then {
        $0.backgroundColor = .clear
        $0.isHidden = true
    }
    
    private let titleLabel = Body3_Bold()
    
    private let requiredLabel = Body3_Bold().then {
        $0.text = "*"
        $0.textColor = .blue500
    }
    
    private let titleDescriptionLabel = Body3_Regular().then {
        $0.textColor = .gray600
    }
    
    private let allCheck = Check().then {
        $0.title = "전체 선택"
        $0.tag = -1
        $0.isHidden = true
    }
    
    private let bodyView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    // MARK: - Propety
    
    private var disposeBag = DisposeBag()
    private var componentDisposeBag = DisposeBag()
    
    public var selectors: [SelectableComponentable] {
        if isFlexible {
            return bodyView.subviews.compactMap { $0 as? SelectableComponentable }
        } else {
            return bodyView.subviews.reduce([], { (result, row) in
                return result + row.subviews.compactMap { $0 as? SelectableComponentable }
            })
        }
    }
    
    private var selectedDisposeBag = DisposeBag()
    
    private lazy var isMultipleSelection: Bool = {
        guard let choosableGroup = self as? SelectableGroupMultipleSupportable else { return true }
        return choosableGroup.isMultipleSelection
    }()
    
    private lazy var hasTitle: Bool = {
        guard let choosableGroup = self as? SelectableGroupTitleSupportable else { return false }
        return choosableGroup.hasTitle
    }()
    
    public var isRequired: Bool = false {
        didSet {
            requiredLabel.flex.isHidden(!isRequired)
            titleView.flex.layout(mode: .adjustWidth)
        }
    }
    
    public var sigleColumType: SelectableComponentable.Type { MarkerSelection.self }
    public var multiColumType: SelectableComponentable.Type { Selection.self }
    
    public var spaces: (colum: CGFloat, row: CGFloat) { (8, 8) }
    
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
    
    public var items: [SelectableGroupItemType] = [] {
        didSet {
            arrangeItems()
        }
    }
    
    public var colums: Int = 1 {
        didSet {
            if colums < 1 { colums = 1 }
            
            arrangeItems()
        }
    }
    
    public var useAll: Bool = false {
        didSet {
            if !isMultipleSelection || !hasTitle {
                useAll = false
            }
            
            allCheck.flex.isHidden(!useAll)
            topView.flex.isHidden(titleLabel.isHidden && allCheck.isHidden)
            
            setNeedsLayout()
        }
    }
    
    public var title: String? {
        didSet {
            titleLabel.text = title
            titleLabel.flex.markDirty()
            
            setNeedsLayout()
        }
    }
    
    public var titleDescription: String? {
        didSet {
            guard titleDescription != oldValue else {
                return
            }
            
            titleDescriptionLabel.text = titleDescription
            titleDescriptionLabel.flex.markDirty()
            titleDescriptionLabel.flex.isHidden(titleDescription == nil)
            
            setNeedsLayout()
        }
    }
    
    public var isEnabled: Bool = true {
        didSet {
            titleLabel.textColor = isEnabled ? .gray900 : .gray500
            requiredLabel.textColor = isEnabled ? .blue500 : .gray500
            
            allCheck.isEnabled = isEnabled
            selectors.enumerated().forEach { [unowned self] (index, item) in
                item.isEnabled = self.isEnabled ? (self.items[index].isEnabled) : self.isEnabled
            }
        }
    }
    
    public var keepOne: Bool = false
    
    public var isAll: Bool {
        guard !selectors.isEmpty else { return false }
        
        let tags = selectors.map { $0.tag }.sorted()
        return tags == selectedIndexs.sorted()
    }
    
    public var isFlexible: Bool = false {
        didSet {
            arrangeItems()
        }
    }
    
    public var isDelayTouched: Bool = false {
        didSet {
            let delay = throttle > 0
            selectors.forEach { $0.isDelayTouched = delay ? true : isDelayTouched }
        }
    }
    
    public var delayTouchedObs: PublishSubject<(Int, PublishSubject<Bool>)> = PublishSubject()
    
    public var throttle: Int = 0 {
        didSet {
            let delay = throttle > 0
            selectors.forEach { $0.isDelayTouched = delay ? true : isDelayTouched }
        }
    }
    
    public var isCancelled: Bool = false
    
    // MARK: - Output Property
    
    public let itemSelected = PublishSubject<(Int, Bool)>()
    
    public let modelSelected = PublishSubject<(SelectableGroupItemType?, Bool)>()
    
    public let itemListSelected = PublishSubject<[Int]>()
    
    public let modelListSelected = PublishSubject<[SelectableGroupItemType]>()
    
    private let componentSelected: PublishSubject<(Int, PublishSubject<Bool>)> = PublishSubject()
    private var throttling: Bool = false
    
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
        bindAll()
        bindComponent()
    }
    
    private func bindAll() {
        let share = allCheck.select
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
    
    private func bindComponent() {
        componentSelected
            .subscribe(onNext: { [weak self] obs in
                guard let self = self else { return }
                
                if self.throttle > 0 {
                    if self.throttling {
                        obs.1.onNext(false)
                        return
                    }
                    
                    self.throttling = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + (Double(self.throttle) / 1000)) {
                        self.throttling = false
                    }
                }
                
                if self.delayTouchedObs.hasObservers == true {
                    self.delayTouchedObs.onNext(obs)
                } else {
                    obs.1.onNext(true)
                }
            })
            .disposed(by: disposeBag)
    }
}

extension SelectableGroupComponent {
    private func initLayout() {
        flex.addItem(topView).direction(.row).justifyContent(.spaceBetween).alignItems(.center).marginBottom(8).isHidden(true).define { flex in
            flex.addItem(titleView).direction(.row).isHidden(true).define { flex in
                flex.addItem(titleLabel)
                flex.addItem(requiredLabel).marginLeft(4)
                flex.addItem(titleDescriptionLabel).marginLeft(8)
            }
            flex.addItem()
            
            flex.addItem(allCheck)
        }
        
        flex.addItem(bodyView)
        
        flex.layout()
    }
    
    private func initStyle() {
        titleView.flex.isHidden(!hasTitle)
        requiredLabel.flex.isHidden(!isRequired)
        titleView.flex.layout(mode: .adjustWidth)
        
        allCheck.flex.isHidden(!useAll)
        
        topView.flex.isHidden(titleView.isHidden && allCheck.isHidden)
    }
    
    private func arrangeItems() {
        selectedDisposeBag = DisposeBag()
        selectedIndexs = []
        bodyView.subviews.forEach { $0.removeFromSuperview() }
        
        if isFlexible {
            bodyView.flex.direction(.row).wrap(.wrap).marginBottom(-spaces.row).define { flex in
                items.enumerated().forEach { (index, item) in
                    flex.addItem(makeItem(index,
                                          title: item.title,
                                          isEnabled: item.isEnabled,
                                          type: multiColumType))
                    .marginRight(spaces.colum).marginBottom(spaces.row)
                }
            }
            
        } else {
            var itemList = items
            var row = 0
            
            bodyView.flex.direction(.column).wrap(.noWrap).marginBottom(0)
            while itemList.count > 0 {
                let rowItem = Array(itemList.prefix(colums))
                
                let rows = makeRows(row: row * colums, items: rowItem)
                bodyView.flex.addItem(rows)
                
                if row > 0 {
                    rows.flex.marginTop(spaces.row)
                }
                
                for _ in 0..<rowItem.count {
                    itemList.removeFirst()
                }
                
                row += 1
            }
        }
        
        flex.layout()
    }
    
    private func makeRows(row: Int, items: [SelectableGroupItemType]) -> UIView {
        let v = UIView()
        
        let count = colums - items.count
        var showItems = Array(items) + Array(repeating: nil, count: count)
        let first = showItems.removeFirst()
        
        v.flex.direction(.row).justifyContent(.start).addItem(makeItem(row, item: first))
        
        showItems.enumerated().forEach { (index, item) in
            v.flex.addItem(makeItem(row + index + 1, item: item)).marginLeft(spaces.colum)
        }
        
        return v
    }
    
    private func makeItem(_ index: Int, item: SelectableGroupItemType?) -> UIView {
        let width: CGFloat = (1 / CGFloat(colums)) * 100
        
        var v: UIView
        
        if let item = item {
            v = makeItem(index, title: item.title, isEnabled: item.isEnabled, type: colums == 1 ? sigleColumType : multiColumType)
        } else {
            v = UIView()
        }
        
        v.flex.width(width%).shrink(1).grow(1)
        
        return v
    }
    
    private func makeItem(_ index: Int, title: String?, isEnabled: Bool, type: SelectableComponentable.Type) -> SelectableComponentable {
        let component = type.init()
        component.title = title
        component.tag = index
        component.isEnabled = isEnabled
        component.isDelayTouched = throttle > 0 ? true : isDelayTouched
        
        component.delayTouchedObs
            .bind(to: componentSelected)
            .disposed(by: selectedDisposeBag)
        
        let share = component.select
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .do(onNext: { (weakSelf, component) in
                var selectedIndexs = Set(weakSelf.selectedIndexs)
                
                if weakSelf.keepOne, selectedIndexs.count == 1, selectedIndexs.contains(component.tag) {
                    component.isSelected = true
                }
                
                if weakSelf.isMultipleSelection == false,
                   let select = weakSelf.selectedIndexs.first,
                   let v = weakSelf.selectors.first(where: { $0.tag == select }) {
                    if v == component, weakSelf.isCancelled == false {
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
        allCheck.isSelected = useAll && isAll
        
        selectors
            .forEach { [weak self] v in
                v.isSelected = self?.selectedIndexs.contains(where: { v.tag == $0 }) ?? false
            }
    }
}

extension Reactive where Base: SelectableGroupComponentable {
    public var items: Binder<[SelectableGroupItemType]> {
        return Binder(base) { component, items in
            component.items = items
        }
    }
    
    public var title: Binder<String?> {
        return Binder(base) { component, title in
            component.title = title
        }
    }
}
