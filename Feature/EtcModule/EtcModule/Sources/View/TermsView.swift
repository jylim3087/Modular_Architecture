//
//  TermsView.swift
//  EtcModule
//
//  Created by 임주영 on 2023/07/17.
//

import Foundation
import UIKit
import Share
import FlexLayout
import Then
import Core

final class TermsView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension TermsView {
    
    private func initLayout() {
        flex.direction(.row).paddingLeft(4).paddingVertical(40).alignItems(.center).define { flex in
            TermActionType.allCases.forEach { term in
                let button = GrayTextSmallButton().then {
                    $0.setTitle(term.title, for: .normal)
                    $0.setTitleColor(.gray600, for: .normal)
                    
                    if term != .private {
                        $0.titleLabel?.font = .caption1_regular
                    }
                }
                
                flex.addItem(button).marginLeft(16)
            }
        }
    }
}
