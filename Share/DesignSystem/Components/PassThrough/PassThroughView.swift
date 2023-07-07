//
//  PassThroughView.swift
//  DabangSwift
//
//  Created by you dong woo on 2022/02/09.
//

import RxSwift
import RxCocoa
import UIKit

public class PassThroughView: UIView {
    private let contentView: UIView
    private var animating: Bool = false
    private var exceptionFrame: CGRect = .zero
    
    public var hideEvent = PublishSubject<Void>()
    
    init(content: UIView, origin: CGPoint, exceptionFrame: CGRect = .zero, showAnimation: ((UIView, CGPoint) -> Void)? = nil) {
        contentView = content
        self.exceptionFrame = exceptionFrame
        
        super.init(frame: .zero)
        
        addSubview(content)
        
        if let animation = showAnimation {
            animation(content, origin)
        }
        else {
            content.frame.origin = origin
            content.alpha = 0
            
            UIView.animate(withDuration: 0.2) {
                content.alpha = 1
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if exceptionFrame.contains(point) == true {
            hide()
            
            return self
        }
        
        let hitTestView = super.hitTest(point, with: event)
        
        guard hitTestView == self else {
            return hitTestView
        }
        
        hide()
        
        return nil
    }
    
    private func hide() {
        if animating == false {
            animating = true
            
            UIView.animate(withDuration: 0.2) {
                self.contentView.alpha = 0
            } completion: { _ in
                self.removeFromSuperview()
                self.hideEvent.onNext(())
            }
        }
    }
}
