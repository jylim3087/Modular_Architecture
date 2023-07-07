//
//  BottomSheetAlert.swift
//  DabangPro
//
//  Created by 조동현 on 2023/01/11.
//

import RxSwift
import FlexLayout
import UIKit

public class BottomSheetAlert: ModalTranslucenceViewController {
    /// 스타일
    enum MainTitleLabelStyle {
        case subTitle2Bold(color: UIColor = .gray900)
        case body1Bold(color: UIColor = .gray900)
        case body2Bold(color: UIColor = .gray900)
    }
    
    enum ContentLabelStyle {
        case body3Regular(color: UIColor = .gray600)
        case body2Regular(color: UIColor = .gray900)
    }
    
    public enum ButtonInnerStyle {
        case gray
        case blue
        case grayLine
        case blueLine
    }
    
    public enum ButtonStyle: Equatable {
        case done(title: String?)
        case cancel(title: String?)
        case doneCustom(title: String?, backgroundColor: ButtonInnerStyle)
        case cancelCustom(title: String?, backgroundColor: ButtonInnerStyle)
    }
    
    // typealias
    typealias ButtonConfig = (button: ButtonStyle, action: (() -> Void)?)
    
    // MARK: UI
    private let mainImageView: UIImageView?
    private var bottomActionView: BottomSheetAlertActionView?
    
    // MARK: Property
    private let mainTitle: String?
    private let message: String?
    private let contentView: UIView?
    private var buttonConfigs: [ButtonConfig] = []
    
    private lazy var _dismissAction: (() -> Void)? = {}
    
    public override var dismissAction: (() -> Void)? {
        _dismissAction
    }
    
    public override var isBottomSafeArea: Bool { true }
    
    var contentAlign: Flex.AlignItems = .stretch // 컨텐츠 정렬
    var mainTitleLabelStyle: MainTitleLabelStyle = .subTitle2Bold(color: .gray900)
    var contentLabelStyle: ContentLabelStyle = .body3Regular(color: .gray600)
    
    init(image: UIImage? = nil, title: String?, message: String? = nil, contentView: UIView? = nil) {
        self.mainImageView = {
            guard let i = image else {
                return nil
            }
            
            return UIImageView().then {
                $0.image = i
                $0.contentMode = .scaleAspectFit
                $0.flex.width(48).height(48).marginTop(40)
            }
        }()
        
        self.mainTitle = title
        self.message = message
        self.contentView = contentView
        
        super.init(nibName: nil, bundle: nil)
    }
    
    init(imageView: UIImageView, message: String? = nil) {
        // 커스텀되는 이미지뷰의 경우에는 유저가 레이아웃을 추가할 수 있도록 기본 여백 없도록 처리
        self.mainImageView = imageView
        self.mainTitle = nil
        self.message = message
        self.contentView = nil
        
        super.init(nibName: nil, bundle: nil)
    }
    
    init(contentView: UIView) {
        self.mainImageView = nil
        self.mainTitle = nil
        self.message = nil
        self.contentView = contentView
        
        super.init(nibName: nil, bundle: nil)
    }
            
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult
    public func add(button: ButtonStyle, _ action: (() -> Void)? = nil) -> Self {
        buttonConfigs.append((button: button, action: action))
        
        return self
    }
    
    @discardableResult
    public func backgroundActionWithButton(_ button: ButtonStyle) -> Self {
        guard let config = buttonConfigs.first(where: { $0.button == button }) else { return self }
        
        _dismissAction = { config.action?() }
        
        return self
    }
    
    @discardableResult
    public func backgroundAction(action: @escaping (() -> Void)) -> Self {
        _dismissAction = action
        
        return self
    }
    
    public func show(_ vc: UIViewController?) {
        disableGesture = true
        
        bodyView.flex.define { flex in
            flex.addItem().direction(.column).alignItems(contentAlign).marginHorizontal(20).define { flex in
                if let imageView = mainImageView {
                    flex.addItem(imageView)
                }
                
                if let title = mainTitle {
                    let titleLabel = generateTitleComponentLabel(title: title)
                    
                    flex.addItem(titleLabel).marginTop(mainImageView == nil ? 40 : 16)
                }
                
                if let message = message {
                    let messageLabel = generateContentComponentLabel(message: message)
                    
                    flex.addItem(messageLabel).marginTop(16)
                }
                
                if let contentView = contentView {
                    flex.addItem(contentView).marginTop(16)
                }
            }
            
            bottomActionView = .init(actionButtons: getButtons(), needSafeArea: false)
            bottomActionView?.flex.marginTop(16)
            flex.addItem(bottomActionView!)
        }
        
        vc?.present(self, animated: false, completion: nil)
    }
    
    private func getButtons() -> [ComponentButton] {
        guard buttonConfigs.isEmpty == false else {
            let button = BlueSolidXLargeButton().then {
                $0.setTitle("확인")
            }
            
            button.rx.tap
                .bindOnMain { [weak self] _ in
                    self?.dismissWithAnimation()
                }
                .disposed(by: disposeBag)
            
            return [button]
        }
        
        var buttons: [ComponentButton] = []
        
        buttonConfigs.forEach { type, action in
            let button: ComponentButton
            
            switch type {
            case .done(let title):
                button = BlueSolidXLargeButton().then {
                    $0.setTitle(title ?? "확인")
                }
                
            case .cancel(let title):
                button = GrayLineXLargeButton().then {
                    $0.setTitle(title ?? "취소")
                }
                
            case .doneCustom(let title, let buttonInnerStyle):
                button = generateCustomButton(style: buttonInnerStyle,  title: title, defaultTitle: "확인")
            case .cancelCustom(let title, let buttonInnerStyle):
                button = generateCustomButton(style: buttonInnerStyle,  title: title, defaultTitle: "취소")
            }
            
            buttons.append(button)
            
            button.rx.tap
                .bindOnMain { [weak self] _ in
                    self?.dismissWithAnimation {
                        action?()
                    }
                }
                .disposed(by: disposeBag)
        }
        
        return buttons
    }
    
    private func generateCustomButton(style: ButtonInnerStyle, title: String?, defaultTitle: String) -> ComponentButton {
        let button: ComponentButton
        switch style {
        case .blue:
            button = BlueSolidXLargeButton().then {
                $0.setTitle(title ?? defaultTitle)
            }
        case .blueLine:
            button = BlueLineXLargeButton().then {
                $0.setTitle(title ?? defaultTitle)
            }
        case .gray:
            button = GraySolidXLargeButton().then {
                $0.setTitle(title ?? defaultTitle)
            }
        case .grayLine:
            button = GrayLineXLargeButton().then {
                $0.setTitle(title ?? defaultTitle)
            }
        }
        return button
    }
    
    private func generateTitleComponentLabel(title: String) -> ComponentLabel {
        var componentLabel: ComponentLabel
        
        switch mainTitleLabelStyle {
        case .subTitle2Bold(let textColor):
            componentLabel = Subtitle2_Bold().then {
                $0.text = title
                $0.textColor = textColor
                $0.textAlignment = .center
                $0.numberOfLines = 0
            }
            
        case .body1Bold(let textColor):
            componentLabel = Body1_Bold().then {
                $0.text = title
                $0.textColor = textColor
                $0.textAlignment = .center
                $0.numberOfLines = 0
            }
            
        case .body2Bold(let textColor):
            componentLabel = Body2_Bold().then {
                $0.text = title
                $0.textColor = textColor
                $0.textAlignment = .center
                $0.numberOfLines = 0
            }
        }
        
        return componentLabel
    }
    
    private func generateContentComponentLabel(message: String) -> ComponentLabel {
        var componentLabel: ComponentLabel
        
        switch contentLabelStyle {
        case .body3Regular(let textColor):
            componentLabel = Body3_Regular().then {
                $0.text = message
                $0.textColor = textColor
                $0.textAlignment = .center
                $0.numberOfLines = 0
            }
            
        case .body2Regular(let textColor):
            componentLabel = Body2_Regular().then {
                $0.text = message
                $0.textColor = textColor
                $0.textAlignment = .center
                $0.numberOfLines = 0
            }
        }
        
        return componentLabel
    }
}
