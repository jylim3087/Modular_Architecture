//
//  LoadingIndicatorView.swift
//  DabangSwift
//
//  Created by you dong woo on 2021/10/19.
//

import UIKit

public class LoadingIndicatorView: UIView {
    private let indicatorView: ST3IndicatorView
    
    init(color: UIColor = .white0) {
        let activityData = ActivityData(color: color)
        
        indicatorView = ST3IndicatorView(
            frame: CGRect(x: 0, y: 0, width: activityData.size.width, height: activityData.size.height),
            type: activityData.type,
            color: activityData.color,
            padding: activityData.padding)
        
        super.init(frame: .zero)
        
        alpha = 0
        backgroundColor = ST3IndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR
        isUserInteractionEnabled = true
        
        addSubview(indicatorView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        indicatorView.pin.center()
    }
    
    func show() {
        indicatorView.startAnimating()
        
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
    
    func hide() {
        indicatorView.stopAnimating()
        
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0
        }
    }
}
