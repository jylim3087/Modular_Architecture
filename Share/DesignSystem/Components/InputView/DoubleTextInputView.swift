//
//  DoubleTextInputView.swift
//  DabangSwift
//
//  Created by Ickhwan Ryu on 2021/08/05.
//

import UIKit
import RxSwift
import FlexLayout

public final class DoubleTextInputView: UIView {
    
    public typealias T = PasswordValidator
    
    // MARK: UI
    
    public let firstInputView: TextInputView<T>
    
    public let secondInputView: TextInputView<T>
    
    private let helpTextLabel = Caption1_Regular().then {
        $0.textColor = .gray800
        $0.numberOfLines = 0
    }
    
    // MARK: Property
    
    private let passwordValidator = PasswordValidator()
    
    private let configuration: TextInputViewConfig<PasswordValidator>
    
    public let firstError = PublishSubject<String?>()
    public let secondError = PublishSubject<String?>()
    
    public var stateObs = PublishSubject<TextInputViewState>()
    
    public var error: Observable<String?> {
        return Observable.merge(firstError, secondError)
    }
    
    private let disposeBag = DisposeBag()
    
    public init(setting: (inout TextInputViewConfig<PasswordValidator>) -> ()) {
        var config = TextInputViewConfig<PasswordValidator>(type: .textfield(left: nil, right: nil))
        setting(&config)
        
        config.placeHolder = "8자리 이상 영문, 숫자, 특수문자 포함"
        config.isErrorStateManaging = false
        config.validator = passwordValidator
        config.validType = .pw
        
        configuration = config
        
        firstInputView = TextInputView<PasswordValidator> {
            $0 = config
        }
        
        config.title = ""
        config.placeHolder = "비밀번호 확인"
        config.validType = .configmPw
        
        secondInputView = TextInputView<PasswordValidator> {
            $0 = config
        }
        
        super.init(frame: .zero)
        
        layout(config)
        bindState()
        bindError()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(_ config: TextInputViewConfig<PasswordValidator>) {
        flex.define { flex in
            flex.addItem(firstInputView)
            flex.addItem(secondInputView).marginTop(8)
            
            if config.helpText.isEmpty {
                flex.addItem(helpTextLabel).position(.absolute).horizontally(0).bottom(-8)
            } else {
                flex.addItem(helpTextLabel).marginTop(8).define { flex in
                    flex.view?.alpha = 1
                }
            }
        }
    }
    
    private func animationHelpTextLabel(isHidden: Bool) {
        if isHidden {
            helpTextLabel.flex.isIncludedInLayout(false)
        } else {
            helpTextLabel.flex.position(.relative).marginTop(8).bottom(0).isIncludedInLayout(true)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.helpTextLabel.alpha = isHidden ? 0 : 1
        }
    }
    
    private func errorFeedback() {
        let feedback = UINotificationFeedbackGenerator()
        feedback.notificationOccurred(.error)
    }
    
    private func changeState(_ errorMsg: String?, inputView: TextInputView<PasswordValidator>) {
        let isHidden = errorMsg == nil && configuration.helpText.isEmpty
        
        if errorMsg == nil {
            inputView.state = inputView.isFocus == true ? .focus : .enabled
        }
        else {
            inputView.state = .error
        }
        
        helpTextLabel.textColor = inputView.state.alarmTextColor
        helpTextLabel.text = errorMsg != nil ? errorMsg : configuration.helpText
        animationHelpTextLabel(isHidden: isHidden)
    }
    
    private func bindState() {
        stateObs
            .bindOnMain(onNext: { [weak self] state in
                self?.firstInputView.state = state
                self?.secondInputView.state = state
            })
            .disposed(by: disposeBag)
    }
    
    private func bindError() {
        firstInputView.error
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (weakSelf, errorMsg) in
                weakSelf.changeState(errorMsg, inputView: weakSelf.firstInputView)
                if errorMsg == nil && weakSelf.secondInputView.state == .error {
                    weakSelf.changeState(PasswordValidator.ValidType.configmPw.msg, inputView: weakSelf.secondInputView)
                }
                weakSelf.firstError.onNext(errorMsg)
                
                if errorMsg == nil && !weakSelf.secondInputView.text.isEmpty {
                    weakSelf.secondInputView.validateTrigger.accept(())
                }
            })
            .disposed(by: disposeBag)
        
        secondInputView.error
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (weakSelf, errorMsg) in
                weakSelf.changeState(errorMsg, inputView: weakSelf.secondInputView)
                if errorMsg == nil && weakSelf.firstInputView.state == .error {
                    weakSelf.changeState(PasswordValidator.ValidType.pw.msg, inputView: weakSelf.firstInputView)
                }
                weakSelf.secondError.onNext(errorMsg)
            })
            .disposed(by: disposeBag)
    }
}

