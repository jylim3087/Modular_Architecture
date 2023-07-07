//
//  ST3NavigationBar+BlendingColor.swift
//  DabangSwift
//
//  Created by Kim JungMoo on 2018. 5. 14..
//  Copyright © 2018년 young-soo park. All rights reserved.
//

import UIKit

private let kNormalButtonTintColor       = UIColor.fromRed(34, green: 34, blue: 34, alpha: 1.0)

extension ST3NavigationBar {
    @discardableResult
    func updateNavigationBar(scrollView: UIScrollView, transpantButtonTintColor: UIColor? = .white, offset: CGFloat = 0.0) -> CGFloat {
        let transpantButtonTintColor = transpantButtonTintColor ?? kNormalButtonTintColor
        guard scrollView.superview != nil else { return -1 }
        self.updateButtonRenderingMode()

        var height = self.bounds.height
        if let tableView = scrollView as? UITableView, let header = tableView.tableHeaderView {
            height = (((header.bounds.height + offset) - self.bounds.height)) - (tableView.frame.origin.y == 0 ? UIApplication.shared.statusBarFrame.height : 0)
        }
        
        let ratio = CGFloat.minimum(scrollView.contentOffset.y / height, 1)
        self.backgroundColor = self.backgroundColor?.withAlphaComponent(ratio)
        self.stackView?.alpha = ratio
        
        let blendColor = kNormalButtonTintColor.blendColor(targetColor: transpantButtonTintColor, ratio: ratio)
        
        self.setBarItemColor_(blendColor)
        
        return ratio
    }
    
    fileprivate func setBarItemColor(_ color: UIColor) {
        self.titleLabel?.textColor = color
        self.setBarItemColor_(color)
    }
    
    fileprivate func setBarItemColor_(_ color: UIColor) {
        for subview in self.subviews where subview is UIButton {
            subview.tintColor = color
        }
    }
    
    func updateButtonRenderingMode() {
        for subview in self.subviews where subview is UIButton {
            if let button = (subview as? UIButton) {
                let normalImage = button.image(for: .normal)?.withRenderingMode(.alwaysTemplate)
                button.setImage(normalImage, for: .normal)
                if !self.ignoreRenderingModeButtons.contains(button) {
                    let selectedImage = button.image(for: .selected)?.withRenderingMode(.alwaysTemplate)
                    let disabledImage = button.image(for: .disabled)?.withRenderingMode(.alwaysTemplate)
                    let highlightedImage = button.image(for: .highlighted)?.withRenderingMode(.alwaysTemplate)
                    
                    button.setImage(selectedImage, for: .selected)
                    button.setImage(disabledImage, for: .disabled)
                    button.setImage(highlightedImage, for: .highlighted)
                }
            }
        }
    }
}
