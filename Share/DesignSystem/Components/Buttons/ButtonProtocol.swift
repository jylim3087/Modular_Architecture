//
//  ButtonProtocol.swift
//  DabangSwift
//
//  Created by you dong woo on 2021/04/28.
//

import UIKit

public class ComponentButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initStyle()
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initStyle()
        setStyle()
    }
    
    public override var isEnabled: Bool {
        didSet {
            setColorStyle()
        }
    }
    
    private func setStyle() {
        layer.borderWidth = 1
        layer.cornerRadius = 2
        
        setColorStyle()
    }
    
    private func initStyle() {
        guard let heightSupporter = self as? ButtonHeightSupportable else { return }
        
        var frame = self.frame
        frame.size.height = heightSupporter.height.rawValue
        self.frame = frame
        
        titleLabel?.font = heightSupporter.titleFont
        
        guard let titleSupporter = self as? ButtonTitleSupportable else { return }
        
        setTitleColor(titleSupporter.enableTitleColor, for: .normal)
        setTitleColor(titleSupporter.disableTitleColor, for: .disabled)
    }
    
    private func setColorStyle() {
        guard let component = self as? ButtonComponentable else { return }
        
        backgroundColor = isEnabled == true ? component.enableColor : component.disableColor
        layer.borderColor = (isEnabled == true ? component.enableBorderColor : component.disableBorderColor).cgColor
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        var newSize = super.sizeThatFits(size)
        
        guard let heightSupporter = self as? ButtonHeightSupportable else { return newSize }
        
        newSize.height = heightSupporter.height.rawValue
        
        return newSize
    }
}
