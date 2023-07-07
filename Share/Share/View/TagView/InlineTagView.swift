//
//  InlineTagView.swift
//  DabangSwift
//
//  Created by 조동현 on 2020/08/24.
//  Copyright © 2020 young-soo park. All rights reserved.
//

import RxSwift
import RxCocoa
import Then
import UIKit

// 한줄 스크롤로 들어가는 태그 뷰
public class InlineTagView: UIView {
    private let scrollView = PinScrollView().then {
        $0.showsHorizontalScrollIndicator = false
    }
    
    private let rootView = RootView().then {
        $0.direction = .row
    }
    
    // MARK: - Property
    
    var disposeBag: DisposeBag = DisposeBag()
    
    var items: [String] = [] {
        didSet {
            guard oldValue != items else {
                return
            }
            
            addTags()
        }
    }
    
    var leftPadding: CGFloat {
        set {
            var inset = scrollView.contentInset
            inset.left = newValue
            scrollView.contentInset = inset
        }
        get {
            return scrollView.contentInset.left
        }
    }
    
    var rightPadding: CGFloat {
        set {
            var inset = scrollView.contentInset
            inset.right = newValue
            scrollView.contentInset = inset
        }
        get {
            return scrollView.contentInset.right
        }
    }
    
    let spacing: CGFloat
    
    init(spacing: CGFloat) {
        self.spacing = spacing
        
        super.init(frame: .zero)
        
        initLayout()
    }
    
    override init(frame: CGRect) {
        self.spacing = 5
        
        super.init(frame: frame)
        
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        self.spacing = 5
        
        super.init(coder: coder)
        
        initLayout()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.pin.top().bottom().left().right()
    }
}

extension InlineTagView {
    private func initLayout() {
        
        flex.addItem(scrollView)
        
        scrollView.content = rootView
    }
    
    private func addTags() {
        rootView.subviews.forEach { $0.removeFromSuperview() }
        
        rootView.flex.direction(.row).define { flex in
            items.forEach { tag in
                let item = TagItemView(style: .fill(fillColor: .grey2, textColor: .grey7), marginHorizontal: 9)
                item.text = tag
                flex.addItem(item).marginRight(spacing)
            }
        }
    }
}

extension Reactive where Base: InlineTagView {
    var items: Binder<[String]> {
        return Binder(self.base) { tagsView, items in
            tagsView.items = items
        }
    }
}
