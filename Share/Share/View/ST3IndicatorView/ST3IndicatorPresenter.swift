//
//  ST3IndicatorPresenter.swift
//  ST3IndicatorView
//
//  Created by ybj on 2018. 9. 20..
//  Copyright © 2018년 ybj. All rights reserved.
//

import UIKit

public final class ActivityData {
    let size: CGSize
    let message: String?
    let messageFont: UIFont
    let messageSpacing: CGFloat
    let type: ST3IndicatorType
    let color: UIColor
    let textColor: UIColor
    let padding: CGFloat
    let displayTimeThreshold: Int
    let minimumDisplayTime: Int
    let backgroundColor: UIColor

    public init(size: CGSize? = nil, message: String? = nil, messageFont: UIFont? = nil, messageSpacing: CGFloat? = nil, type: ST3IndicatorType? = nil,
                color: UIColor? = nil, padding: CGFloat? = nil, displayTimeThreshold: Int? = nil, minimumDisplayTime: Int? = nil, backgroundColor: UIColor? = nil,
                textColor: UIColor? = nil) {
        self.size = size ?? ST3IndicatorView.DEFAULT_BLOCKER_SIZE
        self.message = message ?? ST3IndicatorView.DEFAULT_BLOCKER_MESSAGE
        self.messageFont = messageFont ?? ST3IndicatorView.DEFAULT_BLOCKER_MESSAGE_FONT
        self.messageSpacing = messageSpacing ?? ST3IndicatorView.DEFAULT_BLOCKER_MESSAGE_SPACING
        self.type = type ?? ST3IndicatorView.DEFAULT_TYPE
        self.color = color ?? ST3IndicatorView.DEFAULT_COLOR
        self.padding = padding ?? ST3IndicatorView.DEFAULT_PADDING
        self.displayTimeThreshold = displayTimeThreshold ?? ST3IndicatorView.DEFAULT_BLOCKER_DISPLAY_TIME_THRESHOLD
        self.minimumDisplayTime = minimumDisplayTime ?? ST3IndicatorView.DEFAULT_BLOCKER_MINIMUM_DISPLAY_TIME
        self.backgroundColor = backgroundColor ?? ST3IndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR
        self.textColor = textColor ?? color ?? ST3IndicatorView.DEFAULT_TEXT_COLOR
    }
}

private protocol ST3IndicatorPresenterState {
    func startAnimating(presenter: ST3IndicatorPresenter, _ fadeInAnimation: FadeInAnimation?)
    func stopAnimating(presenter: ST3IndicatorPresenter, _ fadeOutAnimation: FadeOutAnimation?)
}

private struct ST3IndicatorPresenterStateWaitingToStart: ST3IndicatorPresenterState {
    func startAnimating(presenter: ST3IndicatorPresenter, _ fadeInAnimation: FadeInAnimation?) {
        guard let activityData = presenter.data else { return }
        
        presenter.show(with: activityData, fadeInAnimation)
        presenter.state = .animating
        presenter.waitingToStartGroup.leave()
    }
    
    func stopAnimating(presenter: ST3IndicatorPresenter, _ fadeOutAnimation: FadeOutAnimation?) {
        presenter.state = .stopped
        presenter.waitingToStartGroup.leave()
    }
}

private struct ST3IndicatorPresenterStateAnimating: ST3IndicatorPresenterState {
    func startAnimating(presenter: ST3IndicatorPresenter, _ fadeInAnimation: FadeInAnimation?) {}
    
    func stopAnimating(presenter: ST3IndicatorPresenter, _ fadeOutAnimation: FadeOutAnimation?) {
        guard let activityData = presenter.data else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(activityData.minimumDisplayTime)) {
            guard presenter.state == .waitingToStop else { return }
            
            presenter.stopAnimating(fadeOutAnimation)
        }
        presenter.state = .waitingToStop
    }
}

private struct ST3IndicatorPresenterStateWaitingToStop: ST3IndicatorPresenterState {
    func startAnimating(presenter: ST3IndicatorPresenter, _ fadeInAnimation: FadeInAnimation?) {
        presenter.stopAnimating(nil)
        
        guard let activityData = presenter.data else { return }
        presenter.startAnimating(activityData, fadeInAnimation)
    }
    
    func stopAnimating(presenter: ST3IndicatorPresenter, _ fadeOutAnimation: FadeOutAnimation?) {
        presenter.hide(fadeOutAnimation)
        presenter.state = .stopped
    }
}

private struct ST3IndicatorPresenterStateStopped: ST3IndicatorPresenterState {
    func startAnimating(presenter: ST3IndicatorPresenter, _ fadeInAnimation: FadeInAnimation?) {
        guard let activityData = presenter.data else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(activityData.displayTimeThreshold)) {
            guard presenter.state == .waitingToStart else { return }
            
            presenter.startAnimating(activityData, fadeInAnimation)
        }
        presenter.state = .waitingToStart
        presenter.waitingToStartGroup.enter()
    }
    
    func stopAnimating(presenter: ST3IndicatorPresenter, _ fadeOutAnimation: FadeOutAnimation?) {}
}

public final class ST3IndicatorPresenter {
    fileprivate enum State: ST3IndicatorPresenterState {
        case waitingToStart
        case animating
        case waitingToStop
        case stopped
        
        var performer: ST3IndicatorPresenterState {
            switch self {
            case .waitingToStart: return ST3IndicatorPresenterStateWaitingToStart()
            case .animating: return ST3IndicatorPresenterStateAnimating()
            case .waitingToStop: return ST3IndicatorPresenterStateWaitingToStop()
            case .stopped: return ST3IndicatorPresenterStateStopped()
            }
        }
        
        func startAnimating(presenter: ST3IndicatorPresenter, _ fadeInAnimation: FadeInAnimation?) {
            performer.startAnimating(presenter: presenter, fadeInAnimation)
        }
        
        func stopAnimating(presenter: ST3IndicatorPresenter, _ fadeOutAnimation: FadeOutAnimation?) {
            performer.stopAnimating(presenter: presenter, fadeOutAnimation)
        }
    }
    fileprivate var state: State = .stopped
    fileprivate var data: ActivityData?
    fileprivate let waitingToStartGroup = DispatchGroup()
    public static let sharedInstance = ST3IndicatorPresenter()
    
    private let restorationIdentifier = "ST3IndicatorViewContainer"
    private let messageLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    public var isAnimating: Bool { return state == .animating || state == .waitingToStop }
    
    private init() {}

    public final func startAnimating(_ data: ActivityData, _ fadeInAnimation: FadeInAnimation?) {
        self.data = data
        state.startAnimating(presenter: self, fadeInAnimation)
    }

    public final func stopAnimating(_ fadeOutAnimation: FadeOutAnimation?) {
        state.stopAnimating(presenter: self, fadeOutAnimation)
    }

    public final func setMessage(_ message: String?) {
        waitingToStartGroup.notify(queue: DispatchQueue.main) {
            self.messageLabel.text = message
        }
    }
    
    fileprivate func show(with activityData: ActivityData, _ fadeInAnimation: FadeInAnimation?) {
        let containerView = UIView(frame: UIScreen.main.bounds)
        
        containerView.backgroundColor = activityData.backgroundColor
        containerView.restorationIdentifier = restorationIdentifier
        containerView.translatesAutoresizingMaskIntoConstraints = false
        fadeInAnimation?(containerView)
        
        let activityIndicatorView = ST3IndicatorView(
            frame: CGRect(x: 0, y: 0, width: activityData.size.width, height: activityData.size.height),
            type: activityData.type,
            color: activityData.color,
            padding: activityData.padding)
        
        activityIndicatorView.startAnimating()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(activityIndicatorView)
        
        ({
            let xConstraint = NSLayoutConstraint(item: containerView, attribute: .centerX, relatedBy: .equal, toItem: activityIndicatorView, attribute: .centerX, multiplier: 1, constant: 0)
            let yConstraint = NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: activityIndicatorView, attribute: .centerY, multiplier: 1, constant: 0)
            
            containerView.addConstraints([xConstraint, yConstraint])
        }())
        
        messageLabel.font = activityData.messageFont
        messageLabel.textColor = activityData.textColor
        messageLabel.text = activityData.message
        containerView.addSubview(messageLabel)
        
        ({
            let leadingConstraint = NSLayoutConstraint(item: containerView, attribute: .leading, relatedBy: .equal, toItem: messageLabel, attribute: .leading, multiplier: 1, constant: -8)
            let trailingConstraint = NSLayoutConstraint(item: containerView, attribute: .trailing, relatedBy: .equal, toItem: messageLabel, attribute: .trailing, multiplier: 1, constant: 8)
            
            containerView.addConstraints([leadingConstraint, trailingConstraint])
        }())
        
        ({
            let spacingConstraint = NSLayoutConstraint(item: messageLabel, attribute: .top, relatedBy: .equal, toItem: activityIndicatorView, attribute: .bottom, multiplier: 1, constant: activityData.messageSpacing)
            
            containerView.addConstraint(spacingConstraint)
        }())
        
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        
        keyWindow.addSubview(containerView)
        
        ({
            let leadingConstraint = NSLayoutConstraint(item: keyWindow, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: 0)
            let trailingConstraint = NSLayoutConstraint(item: keyWindow, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: 0)
            let topConstraint = NSLayoutConstraint(item: keyWindow, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: 0)
            let bottomConstraint = NSLayoutConstraint(item: keyWindow, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: 0)
            
            keyWindow.addConstraints([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
        }())
    }
    
    fileprivate func hide(_ fadeOutAnimation: FadeOutAnimation?) {
        for window in UIApplication.shared.windows {
            for item in window.subviews
                where item.restorationIdentifier == restorationIdentifier {
                    if let fadeOutAnimation = fadeOutAnimation {
                        fadeOutAnimation(item) {
                            item.removeFromSuperview()
                        }
                    } else {
                        item.removeFromSuperview()
                    }
            }
        }
    }
}
