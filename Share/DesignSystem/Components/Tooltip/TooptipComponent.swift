//
//  TooptipComponent.swift
//  DabangSwift
//
//  Created by 조동현 on 2022/08/09.
//

import FlexLayout
import UIKit

public protocol TooltipComponentable: UIView {
    init(text: String, textAlignment: NSTextAlignment, arrowType: TooltipComponent.TooltipArrowType)
}

public class TooltipComponent: UIView, TooltipComponentable {
    
    enum TooltipAlignmentType {
        case center
        case left
        case right
    }

    public enum TooltipArrowType {
        case topLeft
        case top
        case topRight
        case left
        case right
        case bottomLeft
        case bottom
        case bottomRight
    }
    
    // MARK: - Property
    
    private var text: String?
    
    private var textAlignment: NSTextAlignment = .natural
    
    private var arrowType: TooltipArrowType = .bottom
    
    private weak var arrowView: UIView?
    
    // MARK: - TooptipStyleSupportable
    
    private lazy var arrowColor: String = {
        guard let style = self as? TooltipStyleSuppotable else { return "" }
        return style.arrowColor
    }()
    
    
    private lazy var tooltipColor: UIColor = {
        guard let style = self as? TooltipStyleSuppotable else { return .gray900 }
        return style.tooltipColor
    }()
    
    required convenience public init(text: String, textAlignment: NSTextAlignment = .natural, arrowType: TooltipArrowType = .bottom) {
        self.init(frame: .zero)
        
        self.text = text
        self.textAlignment = textAlignment
        self.arrowType = arrowType
        
        initLayout()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        flex.layout(mode: .adjustWidth)
        flex.layout(mode: .adjustHeight)
    }
}

extension TooltipComponent {
    private func initLayout() {
        flex.direction(.column).define { flex in
            let arrowUpImageView = UIImageView().then {
                $0.image = UIImage(named: "point_up_\(arrowColor)")
            }
            
            let arrowDownImageView = UIImageView().then {
                $0.image = UIImage(named: "point_down_\(arrowColor)")
            }
            
            let arrowLeftImageView = UIImageView().then {
                $0.image = UIImage(named: "point_left_\(arrowColor)")
            }
            
            let arrowRightImageView = UIImageView().then {
                $0.image = UIImage(named: "point_right_\(arrowColor)")
            }
            
            let textLabel = Caption1_Regular().then {
                $0.text = text
                $0.textColor = .white0
                $0.textAlignment = textAlignment
                $0.numberOfLines = 0
            }
            
            flex.addItem(arrowUpImageView).width(10).height(7).alignSelf(.center).isIncludedInLayout(false)
            flex.addItem().direction(.row).define { flex in
                flex.addItem(arrowLeftImageView).width(7).height(10).alignSelf(.center).isIncludedInLayout(false)
                flex.addItem().padding(8).define { flex in
                    flex.view?.cornerRadius = 8
                    flex.view?.backgroundColor = tooltipColor
                    flex.addItem(textLabel)
                }
                flex.addItem(arrowRightImageView).width(7).height(10).alignSelf(.center).isIncludedInLayout(false)
            }
            
            flex.addItem(arrowDownImageView).width(10).height(7).alignSelf(.center).isIncludedInLayout(false)
            
            switch arrowType {
            case .topLeft, .bottomLeft:
                arrowUpImageView.flex.alignSelf(.start).marginLeft(12)
                arrowDownImageView.flex.alignSelf(.start).marginLeft(12)

            case .topRight, .bottomRight:
                arrowUpImageView.flex.alignSelf(.end).marginRight(12)
                arrowDownImageView.flex.alignSelf(.end).marginRight(12)
            default:
                break
            }
            
            switch arrowType {
            case .topLeft, .top, .topRight:
                arrowView = arrowUpImageView
            case .left:
                arrowView = arrowLeftImageView
            case .right:
                arrowView = arrowRightImageView
            case .bottomLeft, .bottom, .bottomRight:
                arrowView = arrowDownImageView
            }
            
            arrowView?.flex.isIncludedInLayout(true)
        }
    }
    
    func show(target: UIView, superView: UIView, alignmentType: TooltipAlignmentType = .center, offset: CGPoint = .zero, showAnimation: ((UIView, CGPoint) -> Void)? = nil) {
        flex.layout(mode: .adjustWidth)
        flex.layout(mode: .adjustHeight)
        
        var p = target.convert(target.bounds.origin, to: superView)
        
        let w = self.frame.width
        let h = self.frame.height
        
        let tw = target.frame.width
        let th = target.frame.height
        
        if let scrollView = superView as? UIScrollView {
            p.x -= scrollView.contentOffset.x
            p.y -= scrollView.contentOffset.y
        }
        
        switch arrowType {
        case .topLeft, .top, .topRight:
            p.y += (th + offset.y)
        case .bottomLeft, .bottom, .bottomRight:
            p.y -= (h + offset.y)
        case .left:
            p.x += (tw + offset.x)
            p.y -= ((h - th) / 2 - offset.y)
        case .right:
            p.x -= (w + offset.x)
            p.y -= ((h - th) / 2 - offset.y)
        }
        
        if arrowType != .left && arrowType != .right {
            switch alignmentType {
            case .center:
                let x = arrowView?.center.x ?? 0
                p.x -= (x - (tw / 2) - offset.x)
            case .left:
                p.x += offset.x
            case .right:
                p.x -= (w - tw - offset.x)
            }
        }
        
        let v = PassThroughView(content: self, origin: p, showAnimation: showAnimation)
        v.frame = superView.bounds
        
        superView.addSubview(v)
    }
}
