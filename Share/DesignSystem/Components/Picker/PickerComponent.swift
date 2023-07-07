//
//  PickerComponent.swift
//  DabangPro
//
//  Created by 조동현 on 2023/02/28.
//

import UIKit
import RxSwift
import RxCocoa
import PinLayout
import FlexLayout

class PickerComponent<ItemComponent: PickerItemComponentable>: UIView {
    
    // MARK: - UI
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.clipsToBounds = true
    }
    
    private let contentView = UIView()
    
    private let rootView = UIView()
    
    // MARK: - Property
    
    private var disposeBag = DisposeBag()
    
    private var itemDisposeBag = DisposeBag()
    
    private var selectedView: ItemComponent?
    private var currentOffsetView: UIView?
    
    private var reminderCount = 3
    private lazy var reminders: [ItemComponent] = {
        (0...(self.reminderCount * 2)).map { _ in ItemComponent() }
    }()
    private var shows: [ItemComponent] = []
    
    private var _selectedIndex: Int = 0
    
    var items: [PickerItemType] = [] {
        didSet {
            addItems()
        }
    }
    
    var selectedIndex: Int {
        set {
            _selectedIndex = newValue
            setSelected(newValue)
        }
        
        get {
            guard let v = selectedView else { return _selectedIndex }
            _selectedIndex = v.tag
            return v.tag
        }
    }
    
    var itemSelected = PublishSubject<Int>()
    
    var alignment: Flex.AlignItems = .center {
        didSet {
            addItems()
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layout()
    }
    
    private func layout() {
        scrollView.pin.all()
        rootView.pin.top().right().left(alignment == .end ? (frame.width - rootView.frame.width) : 0)
        
        arrangeRootView()
        
        if let x = selectedView?.frame.minY, x != scrollView.contentOffset.y {
            UIView.animate(withDuration:  0.2) { [weak self] in
                self?.scrollView.contentOffset = CGPoint(x: 0, y: x)
            }
        }
    }
    
    private func arrangeRootView() {
        let sh: CGFloat = selectedView != nil ? 8 : 0
        let margin = (frame.height - (38 + sh)) / 2
        
        let height = CGFloat(items.count) * 38 + sh
        rootView.pin.height(height).top(margin).bottom(margin)
        
        var contentSize = rootView.frame.size
        contentSize.height += (margin * 2)
        
        if alignment == .center {
            shows.forEach { v in
                v.flex.layout(mode: .adjustWidth)
                v.pin.hCenter()
            }
        }
        
        scrollView.contentSize = contentSize
    }
    
    private func bind() {
        bindScrollView()
    }
}

extension PickerComponent {
    private func initLayout() {
        addSubview(scrollView)
        scrollView.addSubview(rootView)
        
        reminders.forEach { rootView.addSubview($0) }
    }
        
    private func bindScrollView() {
        scrollView.rx.observe(CGPoint.self, #keyPath(UIScrollView.contentOffset))
            .compactMap { $0 }
            .filter { [weak self] _ in
                guard let self = self else { return false }
                return self.scrollView.isDragging || self.scrollView.isDecelerating
            }
            .throttle(.milliseconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] offset in
                self?.dragSelectedView(offset)
            })
            .disposed(by: disposeBag)
        
        Observable.merge(scrollView.rx.didEndDragging.filter { !$0 }.map { _ in },
                         scrollView.rx.didEndDecelerating.map { _ in })
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                if let v = self.selectedView, self.scrollView.contentOffset.y != v.frame.minY {
                    UIView.animate(withDuration:  0.1) {
                        self.scrollView.contentOffset = CGPoint(x: 0, y: v.frame.minY)
                    }
                } else if let v = self.findViewWithOffset(),
                          let selectedView = self.findSelectedView(v.tag) as? ItemComponent,
                          self.scrollView.contentOffset.y != selectedView.frame.minY {
                    self.setSelectedView(selectedView)
                    
                    let duration = abs(self.scrollView.contentOffset.y - selectedView.frame.minY) > 0 ? 0.2 : 0.1
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: duration) {
                            self.scrollView.contentOffset = CGPoint(x: 0, y: selectedView.frame.minY)
                        }
                    }
                }
                
                self.itemSelected.onNext(self.selectedIndex)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - PickerComponent Add Item

extension PickerComponent {
    private func addItems() {
        let selectedIndex = selectedIndex
        
        reminders.append(contentsOf: shows)
        reminders.forEach { $0.isHidden = true }
        shows.removeAll()
        
        itemDisposeBag = DisposeBag()
        
        let mw = items.reduce(0.0, { (result, item) in
            max(result, item.string.textSize(font: .subtitle1_bold).width + 32)
        })
        
        rootView.pin.width(mw)
        flex.width(mw)
        
        addItemComponent(selectedIndex: selectedIndex)
        
        let index = min(max(items.count - 1, 0), selectedIndex)
        selectedView = findSelectedView(index) as? ItemComponent
        
        layout()
    }
    
    private func addItemComponent(selectedIndex: Int) {
        guard selectedIndex >= 0 else { return }
        
        let selectedIndex = min(max(0, selectedIndex), items.count - 1)
        
        let minIndex = max(0, selectedIndex - reminderCount)
        let maxIndex = min(items.count - 1, selectedIndex + reminderCount)
        
        let reminder = shows.filter { minIndex > $0.tag || maxIndex < $0.tag }
        reminder.forEach { $0.isHidden = true }
        reminders.append(contentsOf: reminder)
        
        shows.removeAll(where: { reminder.contains($0) })
        
        itemDisposeBag = DisposeBag()
        
        let items = items[minIndex...maxIndex]
        
        items.enumerated().forEach { [weak self] (index, item) in
            guard let self = self else { return }
            let i = minIndex + index
            
            if let v = self.shows.first(where: { $0.tag == i }) {
                self.setItemComponent(v, index: i, selectedIndex: selectedIndex)
                return
            }
            
            let v = self.reminders.removeFirst()
            
            v.isHidden = false
            
            v.title = item.string
            v.textAlignment = self.alignment == .center ? .center : .left
            
            v.isEnabled = item.isEnabled
            v.tag = i
            
            v.flex.layout(mode: .adjustWidth)
            v.flex.layout(mode: .adjustHeight)
            
            self.setItemComponent(v, index: i, selectedIndex: selectedIndex)
            
            if self.alignment == .center {
                v.pin.hCenter()
            } else {
                v.pin.horizontally()
            }
            
            self.shows.append(v)
        }
    }
    
    private func setItemComponent(_ v: ItemComponent, index: Int, selectedIndex: Int) {
        v.isSelected = index == selectedIndex
        
        v.tap
            .subscribe(onNext: { [weak self] in
                self?.setSelected(index)
                self?.itemSelected.onNext(index)
            })
            .disposed(by: itemDisposeBag)
        
        var top = CGFloat(index) * 38
        
        if items[selectedIndex].isEnabled {
            if index == selectedIndex {
                top += 4
            } else if index > selectedIndex {
                top += 8
            }
        }
        
        guard v.frame.minY != top else { return }
        v.pin.top(top)
    }
}

// MARK: - PickerComponent Find ItemComponent

extension PickerComponent {
    private func findViewWithOffset() -> UIView? {
        let y = scrollView.contentOffset.y
        
        let views = shows
        var view: UIView?

        view = views.filter { v in
            let y = y + (v.center.y - v.frame.minY)
            return v.frame.minY <= y && v.frame.maxY > y
        }
        .first
        
        if view == nil {
            let maxY = scrollView.contentSize.height - scrollView.bounds.height
            if y < 0 || y > maxY {
                let max = items.count - 1
                view = views.first(where: { $0.tag == (y < 0 ? 0 : max) })
            }
        }
        
        return view
    }
    
    private func findSelectedView(_ index: Int) -> UIView? {
        if let view = shows.first(where: { $0.tag == index }), let v = roopSelectedView(view, next: true) ?? roopSelectedView(view, next: false) {
            addItemComponent(selectedIndex: v.tag)
            return v
        }

        var index = index

        if !items[index].isEnabled {
            if let i = self.items[index..<self.items.count].enumerated().filter({ $0.element.isEnabled }).first?.offset {
                index = i
            } else if let i = self.items[0..<index].enumerated().reversed().filter({ $0.element.isEnabled }).first?.offset {
                index = i
            }
        }

        addItemComponent(selectedIndex: index)

        return findSelectedView(index)
    }
    
    private func roopSelectedView(_ view: UIView?, next: Bool) -> UIView? {
        let views = shows
        
        guard let selectedView = view as? ItemComponent,
              selectedView.isEnabled == false,
              let index = views.firstIndex(of: selectedView) else {
            return view
        }
        
        let i = index + (next ? 1 : -1)
        return roopSelectedView(views[exist: i], next: next)
    }
    
    private func dragSelectedView(_ offset: CGPoint) {
        let view = findViewWithOffset()
        
        if view == nil {
            let index = min(max(0, Int(offset.y / 38)), items.count - 1)
            
            DispatchQueue.main.async { [weak self] in
                self?.addItemComponent(selectedIndex: index)
            }
            return
        }
        
        if view?.tag != selectedView?.tag {
            addItemComponent(selectedIndex: view?.tag ?? 0)
            
            guard let view = view as? ItemComponent, view.isEnabled == true else {
                if selectedView != nil || (view != currentOffsetView) {
                    HapticManager.instance.impact(style: .light)
                }
                
                currentOffsetView = view
                selectedView = nil
                return
            }
            
            currentOffsetView = nil
            setSelectedView(view)
        }
    }
    
    private func setSelectedView(_ view: ItemComponent) {
        selectedView = view
        
        HapticManager.instance.impact(style: .light)
        
        arrangeRootView()
    }
    
    private func setSelected(_ index: Int) {
        guard items.count > index else { return }
        
        selectedView = findSelectedView(index) as? ItemComponent
        arrangeRootView()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if let v = self.selectedView, self.scrollView.contentOffset.y != v.frame.minY {
                let duration = abs(self.scrollView.contentOffset.y - v.frame.minY) > 0 ? 0.3 : 0.2
                
                UIView.animate(withDuration: duration) {
                    self.scrollView.contentOffset = CGPoint(x: 0, y: v.frame.minY)
                }
            }
        }
    }
}
