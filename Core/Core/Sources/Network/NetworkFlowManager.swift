//
//  NetworkFlowManager.swift
//  DabangSwift
//
//  Created by 조동현 on 2023/01/12.
//

import Alamofire
import RxSwift
import RxCocoa
import UIKit
import Share

let NetworkFlow = NetworkFlowManager.current

class NetworkFlowManager {
    typealias ActionHandler = Alert.ActionHandler
    
    static let current: NetworkFlowManager = {
        return NetworkFlowManager()
    }()
    
    private let disposeBag = DisposeBag()
    
    private let manager:NetworkReachabilityManager?
    private var isImpossibleNetwork: Bool = false
    
    var isConnected: Bool = false
    var isWifi: Bool = false
    var isCellular: Bool = false
    
    var forceUseNetwork: Bool = false
    
    private weak var warningAlert: UIViewController? = nil
    private var failResponse: DBErrors? = nil
        
    init() {
        self.manager = NetworkReachabilityManager()
        self.isConnected = self.manager?.isReachable ?? false
        
        self.manager?.startListening{ [weak self] status in
            guard let self = self, let manager = self.manager else { return }
            
            self.isConnected = manager.isReachable
            self.isCellular = manager.isReachableOnCellular
            self.isWifi = manager.isReachableOnEthernetOrWiFi
        }
    }
    
    var unusableNetwork: Bool {
        let forceNetwork = forceUseNetwork
        forceUseNetwork = false
        
        let unusable = isImpossibleNetwork && !forceNetwork
        
        if unusable {
            DispatchQueue.main.async { [weak self] in
                self?.checkNetworkAlert()
                ST3IndicatorPresenter.sharedInstance.stopAnimating(ST3IndicatorView.DEFAULT_FADE_OUT_ANIMATION)
            }
        }
        
        return unusable
    }
    
    func checkNetworkAlert() {
        if warningAlert == nil, let error = failResponse {
            showErrorAlert(error: error)
        }
    }
    
    @discardableResult
    func checkNetworkTypeError(error: DBErrors) -> Bool {
        guard isImpossibleNetwork == false else {
            DispatchQueue.main.async {
                ST3IndicatorPresenter.sharedInstance.stopAnimating(ST3IndicatorView.DEFAULT_FADE_OUT_ANIMATION)
            }
            
            return false
        }
        
        return showErrorAlert(error: error)
    }
    
    @discardableResult
    private func showErrorAlert(error: DBErrors) -> Bool {
        guard maintainanceAlert(error: error) == true else {
            isImpossibleNetwork = true
            failResponse = error
            
            DispatchQueue.main.async {
                ST3IndicatorPresenter.sharedInstance.stopAnimating(ST3IndicatorView.DEFAULT_FADE_OUT_ANIMATION)
            }
            
            return false
        }
        
        return true
    }
    
    private func maintainanceAlert(error: DBErrors) -> Bool {
        guard case .NetworkError(_, let code, _, let data, _, _, _) = error, code == 416, let data = data as? NetworkMaintainanceModel else {
            return true
        }
        
        let title = data.title
        let contents = (data.contents ?? "") +
                    "\n\n• 작업 일시 : \(data.inspectionDate ?? "")" +
                    "\n• 작업 내용 : \(data.inspectionMsg ?? "")"
        
        let alert = Alert(title: title, message: contents)
        alert.addAction("확인", style: .default) { (_) in exit(0) }
            
        alert.show()
        
        warningAlert = alert.getAlertController()
        
        return false
    }
}
