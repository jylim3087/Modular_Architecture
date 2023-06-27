//
//  PinScrollView.swift
//  Share
//
//  Created by 임주영 on 2023/06/27.
//
import UIKit

public class PinScrollView: UIScrollView {
    public var content: RootView? {
        didSet {
            guard let content = self.content else { return }
            addSubview(content)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let content = content else { return }
        
        switch content.direction {
        case .row:
            if contentSize.width != content.frame.maxX {
                contentSize = content.frame.size
            }
            
        case .column:
            if contentSize.height != content.frame.maxY {
                contentSize = content.frame.size
            }
        }
    }
}
