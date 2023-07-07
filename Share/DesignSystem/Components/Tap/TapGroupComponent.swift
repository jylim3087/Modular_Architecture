//
//  TapGroupComponent.swift
//  DabangPro
//
//  Created by 조동현 on 2022/02/22.
//

import UIKit
import Then
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

public class TapGroupComponent<Tap: TapComponentable, TapItem: TapItemType>: UIView, TapGroupComponentable {
    
    // MARK: - UI
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    
    private let contentView = UIView()
    private let rootView = UIView()
    
    private let underlineView = UIView().then {
        $0.backgroundColor = .blue500
    }
    
    private let bottomDividerView = UIView().then {
        $0.backgroundColor = .gray300
        $0.isHidden = true
    }
    
    // MARK: - TapGroupComnentable
    
    public var items: [TapItem] = [] {
        didSet {
            addItems()
        }
    }
    
    public var paddingHorizontal: CGFloat = 0 {
        didSet {
            paddings.forEach { $0.flex.width(paddingHorizontal) }
            setNeedsLayout()
        }
    }
    
    public var index: Int = 0 {
        didSet {
            changeIndex.onNext(index)
        }
    }
    
    public var isEnabled: Bool = true {
        didSet {
            taps.enumerated().forEach { $0.element.isEnabled = isEnabled ? disabledIndexs.contains($0.offset) : false }
            scrollView.isScrollEnabled = isEnabled
            
            contentView.flex.layout()
        }
    }
    
    public var disabledIndexs: [Int] = [] {
        didSet {
            guard isEnabled else { return }
            
            taps.enumerated().forEach { (index, tap) in
                tap.isEnabled = !disabledIndexs.contains(index)
            }
        }
    }
    
    public var hiddenBottomDivider: Bool = true {
        didSet {
            bottomDividerView.isHidden = hiddenBottomDivider
        }
    }
    
    public var bottomDividerColor: UIColor = .gray300 {
        didSet {
            bottomDividerView.backgroundColor = bottomDividerColor
        }
    }
    
    public var isAutoExtend: Bool = true {
        didSet {
            setNeedsLayout()
        }
    }
    
    private var contentViewAlignItems: Flex.AlignItems = .start

    public var itemSelected = PublishSubject<Int>()
    public var modelSelected = PublishSubject<TapItem>()
    
    // MARK: - TapGroupStyleSupportable
    
    private lazy var gap: CGFloat = {
        guard let style = self as? TapGroupStyleSupportable else { return 0 }
        return style.gap
    }()
    
    private lazy var underLineColor: UIColor = {
        guard let style = self as? TapGroupStyleSupportable else { return .clear }
        return style.underLineColor
    }()
    
    // MARK: - Property
    
    private var changeIndex = PublishSubject<Int>()
    
    private var extendView = PublishSubject<Bool>()
    
    fileprivate var taps: [TapComponentable] = []
    
    private var paddings: [UIView] = []
    
    private var disposeBag = DisposeBag()
    private var tapDisposeBag = DisposeBag()
    
    
    init(contentViewAlignItems: Flex.AlignItems = .start) {
        self.contentViewAlignItems = contentViewAlignItems

        super.init(frame: .zero)
        
        initComponent()
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
        setStyle()
        bind()
    }
    
    private func bind() {
        let changeIndex = Observable.merge(changeIndex.take(1).map { ($0, false) }, changeIndex.skip(1).map { ($0, true) })
            .observe(on: MainScheduler.asyncInstance)
            .map { [weak self] (index, ani) -> (TapComponentable, Bool)? in
                guard let self = self, self.taps.count > index, index >= 0 else { return nil }
                return (self.taps[index], ani)
            }
            .share()
        
        changeIndex
            .filter { $0 == nil }
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.underlineView.isHidden = true
                self.taps.forEach { $0.isSelected = false }
                
                self.contentView.flex.layout()
            })
            .disposed(by: disposeBag)
        
        changeIndex
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] (item, ani) in
                guard let self = self else { return }
                
                self.taps.forEach { $0.isSelected = false }
                item.isSelected = true
                
                self.contentView.flex.layout()
                
                let frame = item.frame
                var offset = self.scrollView.contentOffset
                let padding = self.paddings.reduce(0.0, { $0 + $1.frame.width }) / 2

                if self.scrollView.frame.maxX + offset.x < (frame.maxX + padding) {
                    offset.x = frame.maxX + (padding * 2) - self.scrollView.frame.maxX
                } else if offset.x > frame.minX + padding {
                    offset.x = frame.minX
                }
                
                self.underlineView.isHidden = false
                self.underlineView.flex.width(frame.width).marginLeft(frame.minX)
                UIView.animate(withDuration: ani ? 0.3 : 0.0) {
                    self.scrollView.contentOffset = offset
                    self.contentView.flex.layout()
                }
            })
            .disposed(by: disposeBag)
        
        extendView
            .subscribe(onNext: { [weak self] extend in
                guard let self = self else { return }
                
                if self.isAutoExtend, extend, self.taps.count > 0 {
                    let width = self.frame.width / CGFloat(self.taps.count)
                    self.taps.forEach { $0.flex.width(width).marginLeft(0) }
                    
                    self.paddings.forEach { $0.flex.width(0) }
                } else {
                    self.taps.enumerated().forEach { (i, item) in
                        item.flex.width(nil).marginLeft(i == 0 ? 0 : self.gap)
                    }
                    
                    self.paddings.forEach { $0.flex.width(self.paddingHorizontal) }
                }
                
                self.setNeedsLayout()
            })
            .disposed(by: disposeBag)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        bottomDividerView.pin.horizontally().bottom().height(1)
        scrollView.pin.all()
        contentView.pin.top().left().bottom()
        
        contentView.flex.layout(mode: .adjustWidth)
        
        let size = contentView.frame.size
        
        if scrollView.contentSize != size {
            extendView.onNext(frame.width >= size.width)
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.changeIndex.onNext(self?.index ?? 0)
            }
        }
        
        scrollView.contentSize = size
    }
}

extension TapGroupComponent {
    private func initLayout() {
        addSubview(bottomDividerView)
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.flex.direction(.row).define { flex in
            flex.addItem().width(paddingHorizontal).define { paddings.append($0.view!) }
            flex.addItem().direction(.row).define { flex in
                flex.addItem(rootView).direction(.row).alignItems(contentViewAlignItems)
                flex.addItem(underlineView).position(.absolute).bottom(0).height(2)
            }
            flex.addItem().width(paddingHorizontal).define { paddings.append($0.view!) }
        }
    }
    
    private func setStyle() {
        underlineView.backgroundColor = underLineColor
    }
    
    private func addItems() {
        taps.forEach { $0.removeFromSuperview() }
        taps.removeAll()
        
        tapDisposeBag = DisposeBag()
        
        taps = items.map { makeTap($0) }
        taps.enumerated().forEach { (i, tap) in
            tap.isEnabled = !disabledIndexs.contains(i)
            rootView.flex.addItem(tap).marginLeft(i == 0 ? 0 : gap)
        }
        
        setNeedsLayout()
    }
    
    private func makeTap(_ item: TapItem) -> Tap {
        let tap = Tap()
        tap.title = item.title
        
        if var tap = tap as? TapSubStringSupportable {
            tap.subString = item.subString
            tap.subStringColor = item.subStringColor ?? .blue500
        }
        
        if var tap = tap as? TapTopSupportable, let item = item as? TapItemTopSupporingType {
            tap.topString = item.topString
        }
        
        let selected = tap.tap
            .observe(on: MainScheduler.asyncInstance)
            .compactMap { [weak self] item -> Int? in
                guard let self = self else { return nil }
                guard let index = self.taps.firstIndex(where: { $0 == item }) else { return nil }
                
                self.index = index
                return index
            }
            .share()
                
        selected
            .bind(to: itemSelected)
            .disposed(by: tapDisposeBag)
        
        selected
            .compactMap { [weak self] in self?.items[$0] }
            .bind(to: modelSelected)
            .disposed(by: tapDisposeBag)
        
        return tap
    }
}

extension Reactive where Base: TapGroupComponentable {
    var items: Binder<[Base.TapItem]> {
        return Binder(base) { component, items in
            component.items = items
        }
    }
    
    var paddingHorizontal: Binder<CGFloat> {
        return Binder(base) { component, paddingHorizontal in
            component.paddingHorizontal = paddingHorizontal
        }
    }
    
    var index: Binder<Int> {
        return Binder(base) { component, index in
            component.index = index
        }
    }
    
    var isEnabled: Binder<Bool> {
        return Binder(base) { component, isEnabled in
            component.isEnabled = isEnabled
        }
    }
}

public class DoubleLineTapGroup<TapItem: TapItemType>: TapGroupComponent<DoubleLineTap, TapItem>, TapGroupMarkSupportable {
    var marks: [Int] {
        set {
            taps.enumerated().forEach { (index, tap) in
                guard var tap = tap as? TapTopSupportable else { return }
                
                tap.showTopMark = newValue.contains(index)
            }
            
            self.setNeedsLayout()
        }
        
        get {
            return taps.enumerated()
                .filter { $0.element as? TapTopSupportable != nil }
                .filter { ($0.element as! TapTopSupportable).showTopMark }
                .map { $0.offset }
        }
    }
}
