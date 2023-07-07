//
//  ST3AlertController.swift
//  DabangSwift
//
//  Created by young-soo park on 2017. 10. 16..
//  Copyright © 2017년 young-soo park. All rights reserved.
//

import UIKit

class ST3AlertController {
    typealias ActionHandler = (UIAlertAction) -> Void
    var alertController : UIAlertController
    var presentingController : UIViewController? = nil
    var delayTime : Int? = nil

    var title: String? {
        get { return alertController.title }
        set { alertController.title = newValue }
    }
    var message : String? {
        get { return alertController.message }
        set { alertController.message = newValue }
    }
    
    var configuredPopoverController = false
    var tintColor : UIColor? {
        didSet { if let tint = tintColor { alertController.view.tintColor = tint } }
    }
    
    var hasRequiredTextField = false
    var alertPrimaryAction : UIAlertAction?
    
    public init(style: UIAlertController.Style) {
        self.alertController = UIAlertController(title: nil, message: nil, preferredStyle: style)
    }
    
    @discardableResult
    func addAction(_ title: String, style: UIAlertAction.Style, handler: ActionHandler? = nil) -> ST3AlertController {
        return addAction(title, style: style, preferredAction: false, handler: handler)
    }
    
    @discardableResult
    func addAction(_ title: String, style: UIAlertAction.Style, preferredAction: Bool = false, handler: ActionHandler? = nil) -> ST3AlertController {
        var action: UIAlertAction
        if let handler = handler {
            action = UIAlertAction(title: title, style: style, handler: handler)
        } else {
            action = UIAlertAction(title: title, style: style, handler: { _ in })
        }
        alertController.addAction(action)
        if preferredAction {
            alertController.preferredAction = action
            if hasRequiredTextField {
                action.isEnabled = false
                alertPrimaryAction = action
            }
        }
        
        return self
    }
    
    func presentIn(_ source: UIViewController) -> ST3AlertController {
        presentingController = source
        return self
    }
    
    func setDelay(_ time: Int) -> ST3AlertController {
        delayTime = time
        return self
    }
    
    func show(animated: Bool = true, completion: (() -> Void)? = nil ) {
        if let time = delayTime {
            setTimeout(after: time, execute: { self.show(animated: animated, completion: completion) })
            delayTime = nil
            return
        }
        
        if let viewController = UIApplication.shared.keyWindow?.rootViewController {
            var presentedController = viewController
            while let presented = presentedController.presentedViewController, presentedController.presentedViewController?.isBeingDismissed == false {
                presentedController = presented
            }
            
            if self is ActionSheet && !configuredPopoverController,  let popoverController = alertController.popoverPresentationController {
                var topController = presentedController
                while let last = topController.children.last {
                    topController = last
                }
                popoverController.sourceView = topController.view
                popoverController.sourceRect = topController.view.bounds
            }
            if let source = self.presentingController { presentedController = source }
            setTimeout(after: 0, execute: { [weak self] in
                guard let self = self else { return }
                presentedController.present(self.alertController, animated: animated, completion: completion)
            })
        }
    }
    
    func getAlertController() -> UIAlertController { return self.alertController }
}

class Alert : ST3AlertController {

    init(title: String? = nil, message: String? = nil, alignment: NSTextAlignment? = nil) {
        super.init(style: .alert)
        self.title = title ?? (message == nil ? nil : "")
        self.message = message
        
        if let alignment = alignment, let message = message {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = alignment
            let attributeText = NSAttributedString(
                string: message,
                attributes: [
                    .paragraphStyle : paragraphStyle,
                    .foregroundColor : UIColor.gray900,
                    .font : UIFont.systemFont(ofSize: 13)
                ]
            )
            
            self.alertController.setValue(attributeText, forKey: "attributedMessage")
        }
    }
    
    @discardableResult
    func addAction(_ title: String) -> Alert { return addAction(title, style: .default, preferredAction: false, handler: nil) }
    
    @discardableResult
    override func addAction(_ title: String, style: UIAlertAction.Style, handler: ActionHandler? = nil) -> Alert {
        return addAction(title, style: style, preferredAction: false, handler: handler)
    }
    
    @discardableResult
    override func addAction(_ title: String, style: UIAlertAction.Style, preferredAction: Bool, handler: ActionHandler? = nil) -> Alert {
        return super.addAction(title, style: style, preferredAction: preferredAction, handler: handler) as? Alert ?? self
    }
    
    @discardableResult
    func addTextField(_ textField: inout UITextField, required: Bool = false) -> Alert {
        var field : UITextField?
        alertController.addTextField { [unowned textField] (tf: UITextField) in
            tf.text = textField.text
            tf.placeholder = textField.placeholder
            tf.font = textField.font
            tf.textColor = textField.textColor
            tf.isSecureTextEntry = textField.isSecureTextEntry
            tf.keyboardType = textField.keyboardType
            tf.autocapitalizationType = textField.autocapitalizationType
            tf.autocorrectionType = textField.autocorrectionType
            field = tf
        }
        if required {
            let _ = NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: field, queue: OperationQueue.main, using: { (_) in
                if let actionButton = self.alertPrimaryAction { actionButton.isEnabled = field?.text?.isEmpty == false }
            })
            self.hasRequiredTextField = true
        }
        
        if let field = field { textField = field }
        return self
    }
    
    @discardableResult
    override func presentIn(_ source: UIViewController) -> Alert { return super.presentIn(source) as? Alert ?? self }
    @discardableResult
    override func setDelay(_ time: Int) -> Alert { return super.setDelay(time) as? Alert ?? self }
    @discardableResult
    func tint(_ color: UIColor) -> Alert {
        self.tintColor = color
        return self
    }
    func showOkay() {
        super.addAction("확인", style: .cancel, preferredAction: false, handler: nil)
        show()
    }
}

class ActionSheet : ST3AlertController {
    init(title: String? = nil, message: String? = nil) {
        super.init(style: .actionSheet)
        self.title = title ?? (message == nil ? nil : "")
        self.message = message
    }
    
    @discardableResult
    func addAction(_ title: String) -> ActionSheet { return addAction(title, style: .cancel, handler: nil) }

    @discardableResult
    override func addAction(_ title: String, style: UIAlertAction.Style, handler: ST3AlertController.ActionHandler?) -> ActionSheet {
        return addAction(title, style: style, preferredAction: false, handler: handler)
    }
    
    @discardableResult
    override func addAction(_ title: String, style: UIAlertAction.Style, preferredAction: Bool, handler: ST3AlertController.ActionHandler?) -> ActionSheet {
        return super.addAction(title, style: style, preferredAction: false, handler: handler) as? ActionSheet ?? self
    }
    
    @discardableResult
    override func presentIn(_ source: UIViewController) -> ActionSheet { return super.presentIn(source) as? ActionSheet ?? self }
    
    @discardableResult
    override func setDelay(_ time: Int) -> ActionSheet { return super.setDelay(time) as? ActionSheet ?? self }
    
    @discardableResult
    func setTint(_ color: UIColor) -> ActionSheet {
        self.tintColor = color
        return self
    }
    
    @discardableResult
    func setBarButtonItme(_ item: UIBarButtonItem) -> ActionSheet {
        if let popoverContoller = alertController.popoverPresentationController { popoverContoller.barButtonItem = item }
        super.configuredPopoverController = true
        return self
    }
    
    @discardableResult
    func setPresentingSource(_ source: UIView) -> ActionSheet {
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = source
            popoverController.sourceRect = source.bounds
        }
        super.configuredPopoverController = true
        return self
    }
}
