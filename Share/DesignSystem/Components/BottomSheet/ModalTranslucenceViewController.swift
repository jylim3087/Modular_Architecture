//
//  ModalTranslucenceViewController.swift
//  DabangPro
//
//  Created by 조동현 on 2022/01/27.
//

import UIKit
import Then
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

public class ModalTranslucenceViewController: UIViewController {
    
    // MARK: - UI
    
    private let emptyButton = UIButton(type: .custom)
    private let handleWrapView = UIView()
    private let handleView = UIView().then {
        $0.backgroundColor = .gray500
        $0.cornerRadius = 2
    }
    private let safeAreaView = UIView().then {
        $0.backgroundColor = .white0
    }
    private let contentView = UIView().then {
        $0.backgroundColor = .white100
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 16
        $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    private let containerView = UIView()
    private let contentWrapView = UIView()
    private let dummyView = UIView().then {
        $0.isUserInteractionEnabled = false
    }
    private var innerScrollView: UIScrollView?
    
    // MARK: - Property
    
    var disposeBag = DisposeBag()
    
    private var initLayout = false
    private var originY: CGFloat = 0
    private var touchedGap: CGFloat = 0
    private let distance: CGFloat = 100
    private let speedThreshold: CGFloat = 300
    
    // MARK: Layout Constraints

    private(set) var didSetupConstraints = false
    
    private var notchTop: CGFloat = {
        if #available(iOS 13.0,  *) {
            return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0
        } else {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0
        }
    }()
    
    // interface
    
    public var bodyView: UIView
    public var needScroll: Bool { false }
    public var isBottomSafeArea: Bool { false }
    public var isBackgroundDismiss: Bool = true
    public var dismissAction: (() -> Void)? { nil }
    public var disableGesture = false {
        didSet {
            handleWrapView.flex.isIncludedInLayout(!disableGesture)
            handleView.isHidden = disableGesture
        }
    }
    
    public var catchBackgroundEvent: (() -> Void)?
    
    override init(nibName: String?, bundle: Bundle?) {
        bodyView = UIView()
        
        super.init(nibName: nibName, bundle: bundle)
        
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        bodyView = UIView()
        
        super.init(coder: coder)
        
        modalPresentationStyle = .overFullScreen
    }
    
    public override func viewDidLoad() {
        self.view.setNeedsUpdateConstraints()
    }
    
    public override func loadView() {
        super.loadView()
        
        initialize()
        bindAction()
    }

    public override func updateViewConstraints() {
        if !self.didSetupConstraints {
            self.setupConstraints()
            self.didSetupConstraints = true
        }
        super.updateViewConstraints()
    }

    func setupConstraints() {
    // Override
    }
    
    private func initialize() {
        if needScroll == true {
            bodyView = RootView()
        }
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0)
        
        view.addSubview(containerView)
        
        containerView.flex.direction(.column).define { flex in
            flex.addItem(emptyButton).grow(1).basis(0)

            let maxH = (self.view.frame.maxY - notchTop - 40)
            flex.addItem(contentWrapView).direction(.column).maxHeight(maxH).define { flex in
                flex.addItem(safeAreaView).position(.absolute)
                flex.addItem(contentView).direction(.column).position(.absolute).top(0).horizontally(0).define { flex in
                    flex.addItem(handleWrapView).height(20).direction(.column).justifyContent(.center).alignItems(.center).define { flex in
                        flex.addItem(handleView).width(40).height(4)
                    }
                    
                    if needScroll == true {
                        let scrollView = PinScrollView().then {
                            $0.showsVerticalScrollIndicator = false
                        }
                        
                        innerScrollView = scrollView
                        
                        scrollView.content = bodyView as? RootView
                        
                        flex.addItem(scrollView).grow(1).shrink(1)
                        
                        if disableGesture == false {
                            scrollView.panGestureRecognizer.rx.event
                                .bind(to: gestureCloseBinder())
                                .disposed(by: disposeBag)
                        }
                    }
                    else {
                        flex.addItem(bodyView)
                    }
                }
            }
        }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.pin.all()
        containerView.flex.layout()
        
        safeAreaView.pin.below(of: contentView).horizontally().bottom()
        
//        --------------------
        
        guard initLayout == false else { return }
        
        initLayout = true
        
        let bottomSafeArea = isBottomSafeArea == true ? view.pin.safeArea.bottom : 0
        
        if needScroll == true {
            contentView.flex.bottom(0).layout(mode: .adjustHeight)
//            innerScrollView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: isBottomSafeArea == true ? view.pin.safeArea.bottom : 0, right: 0)
        }
        else {
            contentView.flex.bottom(bottomSafeArea).layout(mode: .adjustHeight)
        }
        
        dummyView.flex.height(bodyView.frame.size.height + (disableGesture == true ? 0 : 20) + bottomSafeArea)

        contentWrapView.flex.addItem(dummyView)
        containerView.flex.layout()
        
        contentView.pin.top(to: view.edge.bottom)

        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.72)
            self.contentView.pin.top()
        }
    }
    
    func dismissWithAnimation(_ closure: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
            self.contentView.pin.top(to: self.view.edge.bottom)
        } completion: { _ in
            self.dismiss(animated: false)
            closure?()
        }
    }
    
    private func bindAction() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
        handleWrapView.addGestureRecognizer(gesture)
        
        emptyButton.rx.tap
            .bindOnMain { [weak self] _ in
                if let catchBackgroundEvent = self?.catchBackgroundEvent {
                    catchBackgroundEvent()
                    return
                }
                
                guard self?.isBackgroundDismiss == true else { return }
                
                self?.dismissWithAnimation {
                    self?.dismissAction?()
                }
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func panGesture(_ recognizer: UIPanGestureRecognizer) {
        guard disableGesture == false else { return }
        
        let y = recognizer.location(in: view).y + touchedGap
        let velocity = recognizer.velocity(in: view)
        
        switch recognizer.state {
        case .began:
            originY = contentView.frame.origin.y
            touchedGap = originY - y
            
        case .changed:
            let currentY = max(y, originY)
            let alpha = (((contentView.frame.size.height - (currentY - originY))) / contentView.frame.size.height) * 0.72
            
            view.backgroundColor = UIColor.black.withAlphaComponent(alpha)
            
            contentView.pin.top(currentY)
            
        case .ended, .cancelled, .failed:
            touchedGap = 0
            
            if velocity.y > 0, velocity.y > speedThreshold {
                dismissWithAnimation {
                    self.dismissAction?()
                }
                return
            }
            
            if y - originY < distance {
                UIView.animate(withDuration: 0.2) { [weak self] in
                    self?.view.backgroundColor = UIColor.black.withAlphaComponent(0.72)
                    self?.contentView.pin.top()
                }
                
            } else {
                dismissWithAnimation {
                    self.dismissAction?()
                }
            }
            
        default:
            break
        }
    }
    
    func updateLayout() {
//        bodyView 의 사이즈 변경이 없을 때 호출하면 안됨!
        
        let bottomSafeArea = isBottomSafeArea == true ? view.pin.safeArea.bottom : 0
        
        bodyView.flex.layout(mode: .adjustHeight)
        
        dummyView.flex.height(bodyView.frame.size.height + (disableGesture == true ? 0 : 20) + bottomSafeArea)
        containerView.flex.layout()
        
        safeAreaView.pin.below(of: contentView).horizontally().bottom()
    }
}

extension ModalTranslucenceViewController: ScrollViewGestureClosable {
    var fixedView: UIView { view }
    var closingView: UIView { contentView }
    var targetScrollView: UIScrollView { innerScrollView! }
    
    func processChangeOffset(variance: CGFloat) {
        let alpha = ((contentView.frame.size.height - variance) / contentView.frame.size.height) * 0.72
        
        view.backgroundColor = UIColor.black.withAlphaComponent(alpha)
    }
    
    func processBackToOrigin() {
        UIView.animate(withDuration: 0.2) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.72)
            self.contentView.pin.top()
        }
    }
    
    func processDismiss() {
        dismissWithAnimation {
            self.dismissAction?()
        }
    }
}

struct ScrollViewGestureClosableKey {
    static var originY = "associated_originY"
    static var inProgress = "associated_inProgress"
    static var firstTouchedY = "associated_firstTouchedY"
}

protocol ScrollViewGestureClosable: AnyObject {
    var fixedView: UIView { get }
    var closingView: UIView { get }
    var targetScrollView: UIScrollView { get }
    
    var closeVelocity: CGFloat { get }
    var closeOffset: CGFloat { get }
    
    func processChangeOffset(variance: CGFloat) // variance >= 0
    func processBackToOrigin()
    func processDismiss()
}

extension ScrollViewGestureClosable {
    var closeVelocity: CGFloat { 1500 }
    var closeOffset: CGFloat { 200 }
    
    func processChangeOffset(variance: CGFloat) {}
    func processBackToOrigin() {}
}

extension ScrollViewGestureClosable {
    private var originY: CGFloat {
        get {
            return objc_getAssociatedObject(self, &ScrollViewGestureClosableKey.originY) as! CGFloat
        }
        set {
            objc_setAssociatedObject(self, &ScrollViewGestureClosableKey.originY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var inProcess: Bool {
        get {
            return objc_getAssociatedObject(self, &ScrollViewGestureClosableKey.inProgress) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &ScrollViewGestureClosableKey.inProgress, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var firstTouchedY: CGFloat {
        get {
            return objc_getAssociatedObject(self, &ScrollViewGestureClosableKey.firstTouchedY) as! CGFloat
        }
        set {
            objc_setAssociatedObject(self, &ScrollViewGestureClosableKey.firstTouchedY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func gestureCloseBinder() -> Binder<UIPanGestureRecognizer> {
        return Binder.init(self) { (base, recognizer) in
            let y = recognizer.location(in: base.fixedView).y
            let velocity = recognizer.velocity(in: base.fixedView)

            switch recognizer.state {
            case .began:
                guard recognizer.direction == .down && base.targetScrollView.isAtTop == true else { return }
                
                base.inProcess = true
                base.firstTouchedY = y
                base.originY = base.closingView.frame.origin.y
                
                base.targetScrollView.setContentOffset(.zero, animated: false)

            case .changed:
                guard base.inProcess == true else { return }
                
                let variance = max(y - base.firstTouchedY, 0)
                
                base.processChangeOffset(variance: variance)
                base.closingView.pin.top(base.originY + variance)
                base.targetScrollView.setContentOffset(.zero, animated: false)
                
            case .ended, .cancelled, .failed:
                guard base.inProcess == true else { return }

                defer { base.firstTouchedY = 0 }
                
                base.inProcess = false
                base.targetScrollView.setContentOffset(.zero, animated: false)
                
                if velocity.y > 0, velocity.y > base.closeVelocity {
                    base.processDismiss()
                    return
                }

                if y - base.firstTouchedY < base.closeOffset {
                    base.processBackToOrigin()
                    
                    UIView.animate(withDuration: 0.2) {
                        base.closingView.pin.top(base.originY)
                    }
                    
                } else {
                    base.processDismiss()
                }

            default:
                break
            }
        }
    }
}
