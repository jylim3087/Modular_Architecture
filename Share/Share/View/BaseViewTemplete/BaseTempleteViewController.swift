//
//  BaseTempleteViewController.swift
//  DabangSwift
//
//  Created by you dong woo on 2022/02/23.
//

import UIKit
import FlexLayout
import PinLayout

protocol BaseTempleteViewInterface {
    associatedtype ConfigUIModel
    
    func setUIModel(uiModel: inout ConfigUIModel)
}

class BaseTempleteView: UIView {
    struct ConfigUIModel {
        struct NavigationBarConfig {
            var title: String = ""
            var hiddenDivision: Bool = true
            var dismissType: PinNavigationBar.DismissButtonType = .back
//            var leftViews: [UIView] = []
            var rightViews: [UIView] = []
        }
        
        struct MainTitleConfig {
            var title: String?
        }
        
        var needScroll: Bool = true
        var navigationConfig = NavigationBarConfig()
        var mainTitleConfig = MainTitleConfig()
        var actionButtons: [ComponentButton] = []
    }
    
//    needScroll
    private var scrollView: PinScrollView?
    private var containerView: RootView?
    
//    no needScroll
    private var mainView: UIView?
    
    private var mainTitleLabel: Subtitle2_Bold?
    fileprivate var bottomActionView: BottomActionView?
    
    private let needScroll: Bool
    
    var navigationBar: PinNavigationBar!
    let contentView = UIView()
    
    init(uiModel: ConfigUIModel) {
        needScroll = uiModel.needScroll
        
        super.init(frame: .zero)
        
        backgroundColor = .white0
        
        initLayout(uiModel: uiModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bottomActionView?.flex.layout(mode: .adjustHeight)
        
        navigationBar.pin.top().horizontally().sizeToFit(.width)
        
        if needScroll == true {
            scrollView?.pin.horizontally().below(of: navigationBar).bottom()
        }
        else {
            mainView?.pin.horizontally().below(of: navigationBar).bottom()
            mainView?.flex.layout()
        }
        
        bottomActionView?.pin.horizontally().bottom()
    }
    
    private func initLayout(uiModel: ConfigUIModel) {
        navigationBar = PinNavigationBar(rightViews: uiModel.navigationConfig.rightViews, dismissBtnType: uiModel.navigationConfig.dismissType).then {
            $0.title = uiModel.navigationConfig.title
            $0.isHiddenDivision = uiModel.navigationConfig.hiddenDivision
        }
        
        if uiModel.mainTitleConfig.title?.isEmpty == false {
            mainTitleLabel = Subtitle2_Bold().then {
                $0.text = uiModel.mainTitleConfig.title
                $0.numberOfLines = 0
            }
        }
        
        addSubview(navigationBar)
        
        if uiModel.needScroll == true {
            scrollView = PinScrollView().then {
                $0.showsVerticalScrollIndicator = false
            }
            
            containerView = RootView()
            
            addSubview(scrollView!)
            
            scrollView!.content = containerView
            
            containerView?.flex.direction(.column).define { flex in
                if let mainTitleLabel = self.mainTitleLabel {
                    flex.addItem(mainTitleLabel).marginLeft(22).marginTop(24)//.isIncludedInLayout(mainTitleLabel?.text?.isEmpty == false)
                }
                
                flex.addItem(contentView).marginHorizontal(22)
            }
        }
        else {
            mainView = UIView()
            
            addSubview(mainView!)
            
            mainView?.flex.direction(.column).define { flex in
                if let mainTitleLabel = self.mainTitleLabel {
                    flex.addItem(mainTitleLabel).marginLeft(22).marginTop(24)//.isIncludedInLayout(mainTitleLabel?.text?.isEmpty == false)
                }
                
                flex.addItem(contentView).marginHorizontal(22).grow(1)
            }
        }
        
        if uiModel.actionButtons.isEmpty == false {
            bottomActionView = BottomActionView(actionButtons: uiModel.actionButtons)
            
            addSubview(bottomActionView!)
            
            bottomActionView?.flex.layout(mode: .adjustHeight)
            
            contentView.flex.marginBottom(bottomActionView!.frame.size.height - (uiModel.needScroll ? 12 : 0))
        }
    }
}

//class BaseTempleteViewController: UIViewController, BaseTempleteViewInterface, Transitionable {
//    var navigationBar: PinNavigationBar { (view as! BaseTempleteView).navigationBar }
//    var contentView: UIView { (view as! BaseTempleteView).contentView }
//    var bottomActionView: UIView? { (view as! BaseTempleteView).bottomActionView }
//    
//    override func loadView() {
//        super.loadView()
//        
//        var uiModel = ConfigUIModel()
//        
//        setUIModel(uiModel: &uiModel)
//        
//        view = BaseTempleteView(uiModel: uiModel)
//    }
//    
//    func setUIModel(uiModel: inout BaseTempleteView.ConfigUIModel) {}
//    
//    func doAction(model: ViewTransitionModel) { }
//}

