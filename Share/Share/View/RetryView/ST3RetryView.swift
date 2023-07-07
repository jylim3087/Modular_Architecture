//
//  ST3RetryView.swift
//  
//
//  Created by Kim JungMoo on 2018. 7. 4..
//

import UIKit

public typealias ST3RetryHandler = () -> ()

public class ST3RetryView: UIView {
    @IBOutlet var label     : UILabel?
    @IBOutlet var button    : UIButton?
    
    public var handler: ST3RetryHandler?

    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction public func actionTouchUpInsideButton(_ sender: Any?) {
        self.handler?()
    }
}
