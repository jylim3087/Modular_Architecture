//
//  SnsView.swift
//  EtcModule
//
//  Created by 임주영 on 2023/07/17.
//

import Foundation
import UIKit
import Share
import FlexLayout
import Then

final class SnsView: UIView {
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initLayout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension SnsView {
    private func initLayout() {
        let label = Body3_Bold().then {
            $0.text = "다방 SNS"
            $0.textColor = .gray600
        }
        
        self.flex.direction(.column).paddingVertical(24).paddingHorizontal(20).define { flex in
            
            flex.addItem(label)
            flex.addItem().direction(.row).wrap(.wrap).justifyContent(.spaceBetween).marginTop(8).define { flex in
                
                let horizontalPaddingValue: CGFloat = 20 * 2
                let gap: CGFloat = 16
                let width: CGFloat = (UIScreen.main.bounds.width - horizontalPaddingValue - gap) / 2
                
                SnsType.allCases.forEach { sns in
                    flex.addItem().direction(.row).alignItems(.center).height(56).width(width).define { flex in
                        let imageView = UIImageView().then {
                            $0.image = UIImage.getImage(name: sns.iconName)
                        }
                        
                        let label = Body3_Regular().then {
                            $0.text = sns.title
                        }
                        
                        let button = UIButton()
                        
                        flex.addItem(imageView)
                        flex.addItem(label).marginLeft(8)
                        flex.addItem(button).position(.absolute).all(0)
                        
                    }
                }
            }
        }
    }
}
