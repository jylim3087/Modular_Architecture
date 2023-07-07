//
//  BottomActionView.swift
//  DabangSwift
//
//  Created by you dong woo on 2022/02/23.
//

import UIKit
import FlexLayout
import PinLayout

class BottomActionView: UIView {
    let height: CGFloat = 104
    
    private let barView = UIView()
    private var safeAreaView: UIView?
    
//   1. 같은 너비
//   [ComponentButton(), ComponentButton()]
//   2. 다른 너비
//   let button = ComponentButton()
//   button.flex.width(50)
//   [button, ComponentButton()]
    
    init(actionButtons: [ComponentButton], needSafeArea: Bool = true) {
        super.init(frame: .zero)
        
        addSubview(barView)
        
        if needSafeArea == true {
            safeAreaView = UIView().then {
                $0.backgroundColor = .white0
            }
            
            addSubview(safeAreaView!)
        }
        
        barView.flex.direction(.row).height(height).alignItems(.center).paddingHorizontal(20).define { flex in
            let backgroundImage = UIImageView().then {
                $0.image = UIImage(named: "btn_gradient")
            }
            
            flex.addItem(backgroundImage).position(.absolute).all(0)
            
            actionButtons.forEach {
                flex.addItem($0).height(56)
                
                if $0.yoga.width.value.isNaN == true {
                    $0.flex.basis(10).grow(1)
                }
                
                guard $0 != actionButtons.last else { return }
                
                flex.addItem(UIView()).width(8).height(56)
            }
        }
        
        let _ = autoSizeThatFits(.zero, layoutClosure: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layout()
    }
    
    private func layout() {
        guard let window = UIApplication.shared.keyWindow else { return }
        
        barView.flex.layout()
        
        barView.pin.horizontally().bottom(window.pin.safeArea).height(height)
        safeAreaView?.pin.below(of: barView).horizontally().bottom()
        pin.wrapContent(.vertically)
    }
}
