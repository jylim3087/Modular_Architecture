//
//  FlowTagView.swift
//  DabangSwift
//
//  Created by Station3 on 2023/05/03.
//

import RxSwift
import RxCocoa
import Then
import UIKit

// 넘치면 하단으로 내려가는 태그 뷰
public class FlowTagView: UIView {
    // MARK: - Property
    var disposeBag: DisposeBag = DisposeBag()
    
    public var items: [UIView] {
        set {
            subviews.forEach { $0.removeFromSuperview() }
            
            flex.direction(.row).wrap(.wrap).define { flex in
                
                newValue.forEach {
                    // 컨테이너 안에 넣기(marginTop 사용시 중복으로 들어가면서 흔들려보이는 이슈)
                    flex.addItem().addItem($0).height(height).marginRight(spacingItem)
                }
            }
        }
        
        get {
            subviews
        }
    }
    
    let spacingItem: CGFloat
    let spacingLine: CGFloat
    let height: CGFloat
    
    init(spacing: CGFloat, height: CGFloat) {
        self.spacingItem = spacing
        self.spacingLine = spacing
        self.height = height
        super.init(frame: .zero)
    }
    
    init(spacingItem: CGFloat, spacingLine: CGFloat, height: CGFloat) {
        self.spacingItem = spacingItem
        self.spacingLine = spacingLine
        self.height = height
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        self.spacingItem = 8
        self.spacingLine = 8
        self.height = 24
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        subviews.forEach { subView in
            let marginTop = subView.frame.minY == 0 ? 0 : spacingLine
            subView.flex.paddingTop(marginTop)
        }
    }
}
