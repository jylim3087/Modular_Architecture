//
//  RootView.swift
//  Share
//
//  Created by 임주영 on 2023/06/27.
//

import UIKit
import PinLayout
import FlexLayout
import RxSwift

final public class RootView: UIView {
    public enum Direction {
        case row
        case column
    }
    
    public var direction: Direction = .column
    public var animation = false
    
    public let completeLayout = PublishSubject<CGRect>()
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        switch direction {
        case .row:
            pin.left().vertically()
            flex.layout(mode: .adjustWidth)
            
        case .column:
            guard animation == true else {
                pin.top().horizontally()
                flex.layout(mode: .adjustHeight)
                
                completeLayout.onNext(frame)
                
                return
            }
            
            animation = false
            
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear]) {
                self.pin.top().horizontally()
                self.flex.layout(mode: .adjustHeight)
            } completion: { _ in
                self.completeLayout.onNext(self.frame)
            }
        }
        
    }
}
