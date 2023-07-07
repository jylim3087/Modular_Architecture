//
//  ST3ShapeLayer.swift
//  page
//
//  Created by RIH on 2019/09/17.
//  Copyright © 2019 test. All rights reserved.
//

import QuartzCore

class ST3ShapeLayer: CAShapeLayer {

    override init() {
        super.init()
        self.actions = [
            "bounds": NSNull(),
            "frame": NSNull(),
            "position": NSNull()
        ]
    }
    
    override public init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
