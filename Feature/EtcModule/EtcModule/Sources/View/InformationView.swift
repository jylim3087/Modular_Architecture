//
//  InformationView.swift
//  EtcModule
//
//  Created by 임주영 on 2023/07/17.
//

import Foundation
import UIKit
import Share
import FlexLayout
import Then

final class InformationView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension InformationView {
    
    private func initLayout() {
        flex.direction(.column).paddingBottom(40).define { flex in
            let button = GrayLineIconLargeButton().then {
                $0.setIcon(UIImage.readAssetFromShare(name: "ic_24_call_gray900"))
                $0.setTitle("고객센터", for: .normal)
            }
            
            let adButton = GrayLineLargeButton().then {
                $0.setTitle("광고문의", for: .normal)
            }
            
            let label = Caption1_Regular().then {
                $0.text =
                    """
                    평일 10:00 ~ 18:30  (토·일요일, 공휴일 휴무)
                    점심시간 12:00 ~ 13:00
                    """
                $0.textColor = .gray600
                $0.textAlignment = .center
                $0.numberOfLines = 0
            }
            
            flex.addItem().direction(.row).marginHorizontal(20).define { flex in
                flex.addItem(button).width(50%).marginRight(7).grow(1).shrink(1)
                flex.addItem(adButton).width(50%).grow(1).shrink(1)
            }
            flex.addItem(label).marginTop(8).alignSelf(.center)
        }
    }
}
