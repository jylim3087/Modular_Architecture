//
//  WaterMarkView.swift
//  DabangSwift
//
//  Created by young-soo park on 2017. 6. 30..
//  Copyright © 2017년 young-soo park. All rights reserved.
//

import UIKit

public class WaterMarkView : UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setting()
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
        self.setting()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setting()
    }
    
    public func setting() {
        self.image = #imageLiteral(resourceName: "watermark")
        self.alpha = 0.35
        self.contentMode = .center
        self.isUserInteractionEnabled = false
        self.backgroundColor = .clear
    }
}
