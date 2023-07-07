//
//  FlexStackView.swift
//  DabangSwift
//
//  Created by jiyeonpark on 2023/06/05.
//

import Foundation
import FlexLayout
import UIKit

public class FlexStackView: UIView {
    private let direction: Flex.Direction
    private let alignItems: Flex.AlignItems
    private let spacing: CGFloat
    
    var arrangedSubView: [UIView] {
        get {
            subviews
        }
    }
    
    init(direction: Flex.Direction = .row,
         alignItems: Flex.AlignItems = .stretch,
         spacing: CGFloat = 0,
         subViews: [UIView] = []) {
        self.direction = direction
        self.alignItems = alignItems
        self.spacing = spacing
        
        super.init(frame: .zero)
        
        initUI()
        addItems(subViews)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() {
        flex
            .direction(direction)
            .alignItems(alignItems)
            .define { flex in
                switch direction {
                case .column, .columnReverse:
                    flex.marginVertical(-spacing/2)
                    
                case .row, .rowReverse:
                    flex.marginHorizontal(-spacing/2)
                }
            }
    }
    
    public func addItem(_ subView: UIView) {
        if subView.yoga.width.value.isNaN == true {
            subView.flex.basis(10).grow(1)
        }
        
        flex.addItem(subView).define { flex in
            switch direction {
            case .column, .columnReverse:
                flex.marginVertical(spacing/2)
                
            case .row, .rowReverse:
                flex.marginHorizontal(spacing/2)
            }
        }
    }
    
    public func addItems(_ subViews: [UIView]) {
        subViews.forEach { subView in
            addItem(subView)
        }
    }
    
    public func hidden(_ subView: UIView) {
        guard subviews.contains(subView) else {
            return
        }
        
        subView.flex.isHidden(true)
    }
    
    public func show(_ subView: UIView) {
        guard subviews.contains(subView) else {
            return
        }
        
        subView.flex.isHidden(false)
    }
}
