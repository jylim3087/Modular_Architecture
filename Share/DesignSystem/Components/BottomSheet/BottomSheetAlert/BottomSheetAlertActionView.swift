//
//  BottomSheetAlertActionView.swift
//  DabangPro
//
//  Created by 조동현 on 2023/01/11.
//

import Foundation
import FlexLayout
import UIKit

class BottomSheetAlertActionView: UIView {
    // MARK: Define
    static private var buttonHeight: CGFloat { 56 }
    var gradientMargin: CGFloat { 24 }
    
    // MARK: UI Variable
    private let barView = UIView().then {
        $0.backgroundColor = .clear
    }
    private let stackView: FlexStackView
    private var safeAreaView: UIView?
    
    var buttons: [ComponentButton] {
        set {
            stackView.arrangedSubView.forEach { $0.removeFromSuperview() }
            stackView.addItems(newValue)
        }
        
        get {
            stackView.arrangedSubView.compactMap { $0 as? ComponentButton }
        }
    }
    
    // MARK: Function
    init(actionButtons: [ComponentButton] = [], needSafeArea: Bool = true, spacing: CGFloat = 8) {
        actionButtons.forEach {
            $0.flex.height(BottomSheetAlertActionView.buttonHeight)
        }
        
        stackView = FlexStackView(direction: .row, alignItems: .center, spacing: spacing, subViews: actionButtons)
        
        super.init(frame: .zero)
        
        if needSafeArea == true {
            safeAreaView = flex.addItem().backgroundColor(.white0).view
        }
        
        flex.define { flex in
            let backgroundImage = UIImageView().then {
                $0.image = UIImage(named: "btn_gradient")
            }
            
            flex.addItem(backgroundImage).position(.absolute).all(0)
            
            flex.addItem(barView)
                .paddingHorizontal(20)
                .paddingVertical(24)
                .define { flex in
                    flex.addItem(stackView)
                        .height(BottomSheetAlertActionView.buttonHeight)
                }
        }
        
        let _ = autoSizeThatFits(.zero, layoutClosure: configLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configLayout()
    }
    
    func updateLayout() {
        configLayout()
    }
    
    private func configLayout() {
        guard let window = UIApplication.shared.keyWindow else { return }
                
        barView.flex.layout()
        barView.pin.bottom(window.pin.safeArea).horizontally()
        
        if let safeAreaView = safeAreaView {
            safeAreaView.pin.below(of: barView).bottom().horizontally()
        }
        
        pin.wrapContent(.vertically)
    }
}
