//
//  ST3PageControl.swift
//  page
//
//  Created by RIH on 2019/09/17.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

 public class ST3PageControl: PageControlBase {
    
    var diameter: CGFloat {
        return radius * 2
    }

    var inactive = [ST3ShapeLayer]()
    var active = ST3ShapeLayer()

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func updateNumberOfPages(_ count: Int) {
        inactive.forEach { $0.removeFromSuperlayer() }
        inactive = [ST3ShapeLayer]()
        inactive = (0..<count).map {_ in
            let layer = ST3ShapeLayer()
            self.layer.addSublayer(layer)
            return layer
        }

        self.layer.addSublayer(active)
        setNeedsLayout()
        self.invalidateIntrinsicContentSize()
    }

     public override func layoutSubviews() {
        super.layoutSubviews()
        
        let floatCount = CGFloat(inactive.count)
        let x = (self.bounds.size.width - self.diameter * floatCount - self.padding * (floatCount - 1)) * 0.5
        let y = (self.bounds.size.height - self.diameter) * 0.5
        var frame = CGRect(x: x, y: y, width: self.diameter, height: self.diameter)

        active.cornerRadius = self.radius
        active.backgroundColor = (self.currentPageTintColor ?? self.tintColor)?.cgColor
        active.frame = frame

        inactive.enumerated().forEach { index, layer in
            layer.backgroundColor = self.tintColor(position: index).withAlphaComponent(self.inactiveTransparency).cgColor
            if self.dotBorderWidth > 0 {
                layer.borderWidth = self.dotBorderWidth
                layer.borderColor = self.tintColor(position: index).cgColor
            }
            layer.cornerRadius = self.radius
            layer.frame = frame
            frame.origin.x += self.diameter + self.padding
        }
        update(for: progress)
    }

    override func update(for progress: Double) {
        guard progress >= 0 && progress <= Double(numberOfPages - 1),
            let firstFrame = self.inactive.first?.frame,
            numberOfPages > 1 else { return }

        let normalized = progress * Double(diameter + padding)
        let distance = abs(round(progress) - progress)
        let mult = 1 + distance * 2

        var frame = active.frame

        frame.origin.x = CGFloat(normalized) + firstFrame.origin.x
        frame.size.width = frame.height * CGFloat(mult)
        frame.size.height = self.diameter

        active.frame = frame
    }

    override public var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize.zero)
    }

    override public func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: CGFloat(inactive.count) * self.diameter + CGFloat(inactive.count - 1) * self.padding,
                      height: self.diameter)
    }
}
