//
//  SpeechBubbleView.swift
//  DabangSwift
//
//  Created by you dong woo on 2022/02/09.
//

import FlexLayout
import UIKit

public class SpeechBubbleView: UIView {
    public static func initiate(origin: CGPoint, width: CGFloat, arrowX: CGFloat, text: String) -> UIView {
        let contentView = UIView().then {
            $0.isUserInteractionEnabled = false
            
            $0.flex.width(width).direction(.column).define { flex in
                let arrowImageView = UIImageView().then {
                    $0.image = UIImage(named: "point_up")
                }
                
                let textLabel = Caption1_Regular().then {
                    $0.text = text
                    $0.textColor = .white0
                    $0.textAlignment = .center
                    $0.numberOfLines = 0
                }
                
                flex.addItem(arrowImageView).position(.absolute).width(10).height(7).left(arrowX)
                flex.addItem().marginTop(7).padding(8).define { flex in
                    flex.view?.cornerRadius = 4
                    flex.view?.backgroundColor = UIColor.gray900.withAlphaComponent(0.9)
                    flex.addItem(textLabel)
                }
            }
            
            $0.flex.layout(mode: .adjustHeight)
        }
        
        return PassThroughView(content: contentView, origin: origin)
    }
}
