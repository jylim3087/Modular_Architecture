//
//  TextInputView.swift
//  test
//
//  Created by Ickhwan Ryu on 2021/07/13.
//

import UIKit
import Then
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

public protocol TextInputType {
    var error: PublishRelay<String?> { get }
    
    var text: String { get }
    var rxText: PublishRelay<String?> { get }
    var textObs: Observable<String> { get }
    
    var state: TextInputViewState { get }
    
    var validateTrigger: PublishRelay<Void> { get }
    
    var responderObs: PublishRelay<Bool> { get }
    var returnObs: PublishRelay<Void> { get }
    
    func vibrate()
    func focusOn(_ focus: Bool)
}

public class TextInputView<T: TextInputValidatorType>: UIView, TextInputType, UITextFieldDelegate, UITextViewDelegate {
    
    // MARK: UI
    
    private let rootContainer = UIView().then {
        $0.backgroundColor = .white0
    }
    
    private let rowView = UIView().then {
        $0.clipsToBounds = true
    }
    
    private let titleLabel = Body3_Bold()
    
    private let requiredLabel = Body3_Bold().then {
        $0.text = "*"
        $0.textColor = .blue500
    }
    
    private let textField = UITextField().then {
        $0.font = .body3_regular
        $0.autocorrectionType = .no
    }
    
    private let textView = UITextView().then {
        $0.font = .body3_regular
        $0.textContainerInset = UIEdgeInsets(top: 14, left: 11, bottom: 14, right: 11)
        $0.showsVerticalScrollIndicator = false
        $0.autocorrectionType = .no
    }
    
    private let textViewPlaceholderLabel = Body3_Regular().then {
        $0.numberOfLines = 0
    }
    
    private let iconImageView = UIImageView().then {
        $0.contentMode = .center
    }
    
    private let helpTextLabel = Caption1_Regular().then {
        $0.alpha = 0
        $0.numberOfLines = 0
        $0.textColor = .gray800
    }
    
    private let countLabel = Body3_Regular().then {
        $0.textAlignment = .right
    }
    
    private var leftView: UIView?
    
    private var rightView: UIView?
    
    // MARK: Property
    
    private let configuration: TextInputViewConfig<T>
    
    private var _error = PublishSubject<String?>()
    
    private var errorStr: String? = nil
    
    private let disposeBag = DisposeBag()
    
    private var _validateTrigger: PublishSubject<Void>!
    
    public let error = PublishRelay<String?>()
    public let rxText = PublishRelay<String?>()
    public let responderObs = PublishRelay<Bool>()
    public let returnObs = PublishRelay<Void>()
    public let validateTrigger = PublishRelay<Void>()
    
    public var state: TextInputViewState = .enabled {
        didSet {
            changeState(state)
        }
    }
    
    public var text: String {
        return configuration.type == .textfield ? textField.text ?? "" : textView.text
    }
    
    public var textObs: Observable<String> {
        if configuration.type == .textfield {
            return textField.rx.controlEvent(.editingChanged)
                .withLatestFrom(textField.rx.text.orEmpty)
        } else {
            return textView.rx.text.orEmpty.asObservable()
        }
    }
    
    public var isFocus: Bool {
        return configuration.type == .textfield ? textField.isFirstResponder : textView.isFirstResponder
    }
    
    // MARK: Init
    
    init(setting: (inout TextInputViewConfig<T>) -> ()) {
        var config = TextInputViewConfig<T>(type: .textfield(left: nil, right: nil))
        setting(&config)
        
        configuration = config
        
        switch configuration.type {
        case .textfield(let left, let right):
            leftView = left
            rightView = right
            
            if leftView == nil {
                let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.textField.frame.height))
                textField.leftView = leftView
                textField.leftViewMode = .always
            }
        default:
            break
        }
        
        super.init(frame: .zero)
        
        clipsToBounds = false
        
        textField.delegate = self
        textView.delegate = self
        
        changeState(config.enabled)
        configuration(config)
        layout(config)
        bindValidateTrigger()
        bindError()
        bindText(config)
        setToolBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        rootContainer.pin.all()
        textViewPlaceholderLabel.flex.maxHeight(textView.frame.maxY - 20)
    }
    
    private func configuration(_ config: TextInputViewConfig<T>) {
        titleLabel.text = config.title
        helpTextLabel.text = config.helpText
        textViewPlaceholderLabel.isHidden = config.placeHolder.isEmpty
        textField.keyboardType = config.keyboardType
        textView.keyboardType = config.keyboardType
        textField.isSecureTextEntry = config.secureTextEntry
        textField.autocapitalizationType = .none
        
        guard config.secureTextEntry == true else { return }
        
        if #available(iOS 12, *) {
            textField.textContentType = .oneTimeCode
        } else {
            textField.textContentType = .init(rawValue: "")
        }
    }
    
    // MARK: layout
    
    private func layout(_ config: TextInputViewConfig<T>) {
        rootContainer.flex.define { flex in
            if !config.title.isEmpty {
                flex.addItem().direction(.row).marginBottom(8).define { flex in
                    flex.addItem(titleLabel)
                    if config.isRequired {
                        flex.addItem(requiredLabel).marginLeft(4)
                    }
                }
            }
            
            flex.addItem(rowView).direction(.row).define { flex in
                switch config.type {
                case .textfield(let left, let right):
                    if let leftView = left {
                        flex.addItem(leftView).height(44)
                    }
                    
                    flex.addItem(textField).grow(1).shrink(1).height(44)
                    
                    if let rightView = right {
                        flex.addItem(rightView).height(44)
                    }
                    
                case .textview(let ratio):
                    flex.addItem(textView).grow(1).shrink(1).aspectRatio(ratio)
                    flex.addItem(textViewPlaceholderLabel).position(.absolute).top(10).horizontally(16)
                    
                    if config.showCount == true, let maxLength = config.maxLength, maxLength > 0 {
                        flex.addItem(countLabel).position(.absolute).height(24).bottom(10).horizontally(16)
                    }
                }
            }
            
            if config.helpText.isEmpty {
                flex.addItem(helpTextLabel).position(.absolute).horizontally(0).bottom(-8)
            } else {
                flex.addItem(helpTextLabel).marginTop(8).define { flex in
                    flex.view?.alpha = 1
                }
            }
        }
        
        addSubview(rootContainer)
    }
    
    private func changeState(_ state: TextInputViewState) {
        // RowView border 설정
        rowView.layer.borderWidth = 1
        rowView.layer.cornerRadius = 2
        rowView.isUserInteractionEnabled = state != .disable
        rowView.layer.borderColor = state.borderColor.cgColor
        
        // textColor 설정
        textField.textColor = state.textColor
        textView.textColor = state.textColor
        
        // InputField 백그라운드 색상
        textField.backgroundColor = state == .disable ? .gray50 : .white0
        textView.backgroundColor = state == .disable ? .gray50 : .white0
        
        // 텍스트뷰 placeholder 색상 지정
        textViewPlaceholderLabel.text = configuration.placeHolder
        textViewPlaceholderLabel.textColor = state.placeholderColor
        
        // textField placeholer 색상 지정
        textField.attributedPlaceholder = NSAttributedString(
            string: configuration.placeHolder,
            attributes: [
                .font : UIFont.body3_regular,
                .foregroundColor : state.placeholderColor
            ]
        )
        
        // helpText 색상 설정
        helpTextLabel.textColor = state.alarmTextColor
        
        // leftView, rightView 색상 설정
        accessoryViewState(state: state)
    }
    
    private func accessoryViewState(state: TextInputViewState) {
        if let leftImageView = leftView as? UIImageView {
            leftImageView.isHighlighted = state == .disable
        }
        
        if let rightImageView = rightView as? UIImageView {
            rightImageView.isHighlighted = state == .disable
        } else if let rightButton = rightView as? UIButton {
            rightButton.isEnabled = state != .disable
        } else if let rightLabel = rightView as? ComponentLabel {
            rightLabel.textColor = state == .disable ? rightLabel.disabledColor : rightLabel.enabledColor
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
    
    private func dynamicBindTrigger() {
        _validateTrigger = PublishSubject<Void>()
        
        _validateTrigger
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .take(until: validateTrigger)
            .flatMapLatest { [weak self] _ -> Observable<String?> in
                guard let self = self else { return .empty() }
                guard let validator = self.configuration.validator,
                      let type = self.configuration.validType else {
                    return .empty()
                }
                
                let text = self.configuration.type == .textfield ? self.textField.text : self.textView.text
                
                return validator.validation(type: type, text: text)
            }
            .subscribe { [weak self] errorText in
                self?._error.onNext(errorText)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindValidateTrigger() {
        dynamicBindTrigger()
        
        validateTrigger
            .flatMapLatest { [weak self] _ -> Observable<String?> in
                guard let self = self else { return .empty() }
                guard let validator = self.configuration.validator,
                      let type = self.configuration.validType else {
                    return .empty()
                }
                
                let text = self.configuration.type == .textfield ? self.textField.text : self.textView.text
                
                return validator.validation(type: type, text: text)
            }
            .subscribe(onNext: { [weak self] errorText in
                self?._error.onNext(errorText)
                self?.dynamicBindTrigger() // 원래 _error subscribe 까지 마치고 해야함.
            })
            .disposed(by: disposeBag)
    }
    
    private func bindError() {
        _error
            .withUnretained(self)
            .subscribe { (weakSelf, error) in
                weakSelf.errorStr = error
                let isHidden = error == nil && weakSelf.configuration.helpText.isEmpty
                
                if weakSelf.configuration.isErrorStateManaging {
                    weakSelf.helpTextLabel.text = error == nil ? weakSelf.configuration.helpText : error
                    weakSelf.animationHelpTextLabel(isHidden: isHidden)
                    
                    if error == nil {
                        weakSelf.state = weakSelf.textField.isFirstResponder == true ? .focus : .enabled
                    }
                    else {
                        weakSelf.state = .error
                    }
                }
                
                weakSelf.error.accept(error)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindText(_ config: TextInputViewConfig<T>) {
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        if config.type == .textfield {
            rxText
                .bind(to: textField.rx.text)
                .disposed(by: disposeBag)
        }
        else {
            rxText
                .bind(to: textView.rx.text)
                .disposed(by: disposeBag)
        }
    }
    
    private func setToolBar() {
        guard configuration.needDoneToolbar == true else { return }
        
        let bar = UIToolbar()
        let flexibleSpaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(doneTapped))
        bar.items = [flexibleSpaceItem, doneItem]
        bar.sizeToFit()
        textField.inputAccessoryView = bar
    }
    
    private func inputCheck(origin: String?, range: NSRange, new: String) -> Bool {
        if configuration.maxLength == nil && configuration.inputRegExp == nil {
            return true
        }
        
        if new.isEmpty { return true }
        
        var fullText: String = origin ?? ""
        guard let range = Range(range, in: fullText) else { return false }
        
        fullText.replaceSubrange(range, with: new)
        
        if let maxLength = configuration.maxLength {
            if configuration.type == .textview {
                fullText = fullText.replacingOccurrences(of: "\n", with: "")
            }
            
            if fullText.count > maxLength {
                return false
            }
        }
        
        if let inputValidator = configuration.inputRegExp {
            if new.isEmpty { return true }
            let predicate = NSPredicate(format:"SELF MATCHES %@", inputValidator)
            return predicate.evaluate(with: new)
        }
        
        return true
    }
    
    @objc private func doneTapped() {
        returnObs.accept(())
    }
    
    public func focusOn(_ focus: Bool) {
        let responder: UIResponder = configuration.type == .textfield ? textField : textView
        
        if focus == true {
            if responder.isFirstResponder == false {
                responder.becomeFirstResponder()
            }
        }
        else {
            if responder.isFirstResponder == true {
                responder.resignFirstResponder()
            }
        }
    }
    
    public func vibrate() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.3
        animation.values = [-10.0, 10.0, -10.0, 10.0, -7.0, 7.0, -3.0, 3.0, 0.0 ]
        rowView.layer.add(animation, forKey: "shake")
        
        errorFeedback()
    }
    
    // MARK: UITextFIeldDelegate, UITextViewDelegate
    
    @objc func textFieldDidChange(_ fileld :UITextField) {
        _validateTrigger.onNext(())
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if configuration.isErrorStateManaging == true {
            state = (errorStr ?? "").isEmpty ? .focus : .error
        }
        
        responderObs.accept(true)
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        if configuration.isErrorStateManaging == true {
            state = (errorStr ?? "").isEmpty ? .enabled : .error
        }
        
        responderObs.accept(false)
    }

    public func textViewDidBeginEditing(_ textView: UITextView) {
        state = (errorStr ?? "").isEmpty ? .focus : .error
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        state = (errorStr ?? "").isEmpty ? .enabled : .error
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        textViewPlaceholderLabel.isHidden = !textView.text.isEmpty
        
        countLabel.isHidden = textView.text.isEmpty
        
        if let maxLength = configuration.maxLength {
            countLabel.text = "\(textView.text.count)/\(maxLength)"
            countLabel.flex.markDirty()
        }
        
        _validateTrigger.onNext(())
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        returnObs.accept(())
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return inputCheck(origin: textField.text, range: range, new: string)
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return inputCheck(origin: textView.text, range: range, new: text)
    }
}

// ----------------------------------------------------------------------------------------------------------------------------------------------------------------

enum TextInputBase {
    case textField(UITextField)
    case textView(UITextView)
    
    var responder: UIResponder {
        switch self {
        case .textField(let textField): return textField
        case .textView(let textView): return textView
        }
    }
    
    var text: String? {
        switch self {
        case .textField(let textField): return textField.text
        case .textView(let textView): return textView.text
        }
    }
}

protocol TextInputValidateionProtocol: AnyObject {
    associatedtype ValidatorType: TextInputValidateType
    
    var inputBase: TextInputBase { get }
    var validator: ValidatorType { get }
    var validateType: ValidatorType.ValidationGroup { get }
    var validationState: PublishRelay<ValidationState<ValidatorType.Error>> { get }
    var debounce: Int { get }
    
    var textInputObservable: ControlProperty<String?> { get }
    
    var explicitValidateTrigger: PublishSubject<String?> { get }
    var dynamicValidateObserver: PublishSubject<String>? { get set }
    
    var disposeBag: DisposeBag { get }
}

extension TextInputValidateionProtocol {
    func dynamicBindTextChangedValidation(_ textChangedObservable: Observable<String>, _ explicitValidateObservable: Observable<String>) {
        Observable.merge(textChangedObservable, explicitValidateObservable)
            .flatMapLatest { [weak self] text -> Observable<ValidationState> in
                guard let self = self else { return .empty() }
                
                return self.validator.validate(type: self.validateType, text: text)
            }
            .bind(to: validationState)
            .disposed(by: disposeBag)
    }
    
    func bindTextChangedValidation() {
        let explicitValidateObservable = PublishSubject<String>()
        let textChangedObservable = textInputObservable
            .orEmpty
            .distinctUntilChanged()
            .skip(1)
            .debounce(DispatchTimeInterval.milliseconds(debounce), scheduler: MainScheduler.instance)
            .take(until: explicitValidateTrigger)
        
        dynamicValidateObserver = explicitValidateObservable
        
        dynamicBindTextChangedValidation(textChangedObservable, explicitValidateObservable)
        
        let validationWithTextObservable = explicitValidateTrigger
            .filter { $0 != nil }
            .compactMap { $0 }
        
        let validationObservable = explicitValidateTrigger
            .filter { $0 == nil }
            .compactMap { [weak self] _ in
                return self?.inputBase.text
            }
        
        Observable.merge(validationWithTextObservable, validationObservable)
            .do(afterNext: { [weak self] _ in
                self?.dynamicValidateObserver?.onCompleted()
                
                let new = PublishSubject<String>()
                self?.dynamicValidateObserver = new
                
                self?.dynamicBindTextChangedValidation(textChangedObservable, new)
            })
            .subscribe(onNext: { [weak self] text in
                self?.dynamicValidateObserver?.onNext(text)
            })
            .disposed(by: disposeBag)
    }
}

class TextInputValidationProcessor<ValidatorType: TextInputValidateType>: TextInputValidateionProtocol {
    var inputBase: TextInputBase
    
    var validator: ValidatorType
    var validateType: ValidatorType.ValidationGroup
    var validationState = PublishRelay<ValidationState<ValidatorType.Error>>()
    var debounce: Int
    
//    이거 확인해보고 교체할 수 있으면 교체. 그리고 ControlProperty<String?> 이것도 -> Observable<String> 이걸로.
//    그러면 Observable<String> 이걸 TextInputBaseView 에서 가져다가?
//    textField.rx.controlEvent(.editingChanged)
//        .withLatestFrom(textField.rx.text.orEmpty)
    
    var textInputObservable: ControlProperty<String?> {
        switch inputBase {
        case .textField(let textfield): return textfield.rx.text
        case .textView(let textview): return textview.rx.text
        }
    }
    
    var explicitValidateTrigger = PublishSubject<String?>()
    var dynamicValidateObserver: PublishSubject<String>?
    
    var disposeBag = DisposeBag()
    
    init(base: TextInputBase, validator: ValidatorType, type: ValidatorType.ValidationGroup, debounce: Int = 200) {
        self.inputBase = base
        self.validator = validator
        self.validateType = type
        self.debounce = debounce
    }
}

protocol TextInputValidationInterface {
    associatedtype ValidatorType: TextInputValidateType
    
    func validate(type: ValidatorType.ValidationGroup?)
    func changeValidate(type: ValidatorType.ValidationGroup)
}

protocol TextInputInterface: TextInputValidationInterface {
    var validationState: Observable<ValidationState<ValidatorType.Error>> { get }
    
    var text: String { get }
    var textBinder: Binder<String?> { get }
    var textChangedObservable: Observable<String> { get }
    
    var state: TextInputViewState { get }
    
    var focusObservable: Observable<Bool> { get }
    var returnTapObservable: Observable<Void> { get }
    
    var layoutNeedUpdate: Observable<Void> { get }
    
    func vibrate()
    func focusOn(_ focus: Bool)
}

class TextInputBaseView<ValidatorType: TextInputValidateType>: UIView, TextInputInterface {
    private let inputBase: TextInputBase
    
    let inputWrapView = UIView().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = TextInputViewState.enabled.borderColor.cgColor
        $0.layer.cornerRadius = 2
    }
    let alarmTextLabel = Caption1_Regular().then {
        $0.numberOfLines = 0
    }
    
    var configuration: TextInputConfig<ValidatorType>
    var validationProcessor: TextInputValidationProcessor<ValidatorType>?
    var isFocus: Bool = false
    
    let disposeBag = DisposeBag()
    //
    var validationState: Observable<ValidationState<ValidatorType.Error>>
    
    var text: String {
        get {
            switch inputBase {
            case .textField(let textField): return textField.text ?? ""
            case .textView(let textView): return textView.text ?? ""
            }
        }
        set {
            switch inputBase {
            case .textField(let textField): textField.text = newValue
            case .textView(let textView): textView.text = newValue
            }
        }
    }
    var textChangedObservable: Observable<String> {
        switch inputBase {
        case .textField(let textField):
            return textField.rx.controlEvent(.editingChanged)
                .withLatestFrom(textField.rx.text.orEmpty)
            
        case .textView(let textView):
            return textView.rx.text.orEmpty
                .distinctUntilChanged()
                .skip(1)
        }
    }
    var textBinder: Binder<String?> {
        return Binder.init(self) { base, text in
            switch base.inputBase {
            case .textField(let textField): textField.text = text
            case .textView(let textView): textView.text = text
            }
        }
    }
    
    var state: TextInputViewState = .enabled {
        didSet {
            changeState(state)
        }
    }
    var focusObservable: Observable<Bool> { focusObserver.asObservable() }
    var returnTapObservable: Observable<Void> { returnTapObserver.asObservable() }
    var layoutNeedUpdate: Observable<Void> { layouUpdateObserver }
    
    var secure: Bool {
        set {
            configuration.keyboardConfig.secureTextEntry = newValue
            
            switch inputBase {
            case .textField(let textField):
                textField.isSecureTextEntry = newValue
                
            case .textView(let textView):
                textView.isSecureTextEntry = newValue
            }
        }
        get {
            configuration.keyboardConfig.secureTextEntry
        }
    }
    
    //
    private let layouUpdateObserver = PublishSubject<Void>()
    fileprivate let focusObserver = PublishSubject<Bool>()
    fileprivate let returnTapObserver = PublishSubject<Void>()
    
    init(base: TextInputBase, configuration: TextInputConfig<ValidatorType>) {
        self.inputBase = base
        self.configuration = configuration
        
        self.validationState = .empty()
        
        if let validator = configuration.validatorConfig.validator, let validationType = configuration.validatorConfig.validType {
            self.validationProcessor = TextInputValidationProcessor(base: base, validator: validator, type: validationType, debounce: configuration.validatorConfig.debounce)
            self.validationState = validationProcessor!.validationState.asObservable().share(replay: 1)
        }
        
        super.init(frame: .zero)
        
        initLayout(configuration)
        
        keyboardConfiguration()
        changeState(configuration.initState)
        
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initLayout(_ config: TextInputConfig<ValidatorType>) {}
    
    fileprivate func bind() {
        validationProcessor?.bindTextChangedValidation()
        
        let initializedValidationState = BehaviorRelay<ValidationState<ValidatorType.Error>?>(value: nil)
        
        validationState
            .distinctUntilChanged()
            .bind(to: initializedValidationState)
            .disposed(by: disposeBag)
        
        let validationStateObservable = initializedValidationState
            .compactMap { [weak self] state -> (Bool, ValidationState<ValidatorType.Error>?)? in
                guard let self = self else { return nil }
                return (self.isFocus, state)
            }
        
        let focusObservable = focusObserver
            .do(onNext: { [weak self] isFocus in
                guard let self = self else { return }
                
                self.isFocus = isFocus
            })
            .withLatestFrom(initializedValidationState) { ($0, $1) }
        
        Observable.merge(validationStateObservable, focusObservable)
            .scan((false, false, nil)) { (prev, new) -> (Bool, Bool, ValidationState<ValidatorType.Error>?) in
                guard let newValidationState = new.1 else {
                    return (false, new.0, new.1)
                }
                
                guard let prevValidationState = prev.2 else {
                    switch newValidationState {
                    case .success:
                        return (false, new.0, new.1)
                        
                    case .fail:
                        return (true, new.0, new.1)
                    }
                }
                
                return (newValidationState != prevValidationState, new.0, new.1)
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] needUpdate, isFocus, state in
                let when = DispatchTime.now() + DispatchTimeInterval.milliseconds(0)
                
                switch state {
                case .success:
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        self?.state = isFocus == true ? .focus : .enabled
                    }
                    
                    if needUpdate == true {
                        self?.updateLayout(self?.configuration.textConfig.helpText, isFocus == true ? .focus : .enabled)
                    }
                    
                case .fail(let error):
                    if error.delegateErrorUI == false {
                        DispatchQueue.main.asyncAfter(deadline: when) {
                            self?.state = .error
                        }
                        
                        if needUpdate == true {
                            self?.updateLayout(error.errorDescription, .error)
                        }
                    }
                    
                case .none:
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        if self?.state == .error { return }
                        
                        if self?.state != .disable {
                            self?.state = isFocus == true ? .focus : .enabled
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func updateAlarmLabel(_ text: String?, _ state: TextInputViewState) {
        let aniTime: TimeInterval = TimeInterval(configuration.validatorConfig.debounce) / 1000
        let isHidden = alarmTextLabel.alpha == 0
        
        alarmTextLabel.flex.markDirty()
        
        if let text = text {
            alarmTextLabel.text = text
            alarmTextLabel.textColor = state.alarmTextColor
            
            if isHidden == true {
                alarmTextLabel.flex.position(.relative)
                
                UIView.animate(withDuration: aniTime, delay: 0) {
                    self.alarmTextLabel.alpha = 1
                }
            }
        }
        else {
            alarmTextLabel.flex.position(.absolute)
            
            UIView.animate(withDuration: aniTime, delay: 0) {
                self.alarmTextLabel.alpha = 0
            }
        }
    }
    
    private func changeState(_ state: TextInputViewState) {
        inputWrapView.backgroundColor = state.backgroundColor
        inputWrapView.isUserInteractionEnabled = state != .disable
        inputWrapView.layer.borderColor = state.borderColor.cgColor
        
        switch inputBase {
        case .textField(let textField):
            textField.textColor = state.textColor
            textField.attributedPlaceholder = NSAttributedString(
                string: configuration.textConfig.placeHolder ?? "",
                attributes: [
                    .font : UIFont.body3_regular,
                    .foregroundColor : state.placeholderColor
                ]
            )
            
        case .textView(let textView):
            textView.textColor = state.textColor
        }
    }
    
    private func keyboardConfiguration() {
        switch inputBase {
        case .textField(let textField):
            textField.keyboardType = configuration.keyboardConfig.keyboardType
            textField.isSecureTextEntry = configuration.keyboardConfig.secureTextEntry
            textField.returnKeyType = configuration.keyboardConfig.returnKeyType
            
        case .textView(let textView):
            textView.keyboardType = configuration.keyboardConfig.keyboardType
            textView.isSecureTextEntry = configuration.keyboardConfig.secureTextEntry
            textView.returnKeyType = configuration.keyboardConfig.returnKeyType
        }
    }
    
    func inputCheck(origin: String?, range: NSRange, new: String) -> Bool {
        let validType = configuration.validatorConfig.validType
        
        if validType?.limitOnInput == nil && validType?.regExpOnInput == nil {
            return true
        }
        
        if new.isEmpty { return true }
        
        var fullText: String = origin ?? ""
        guard let range = Range(range, in: fullText) else { return false }
        
        fullText.replaceSubrange(range, with: new)
        
        if let maxLength = validType?.limitOnInput {
            if fullText.count > maxLength {
                if validType?.notiErrorOnInput == true {
                    validationProcessor?.explicitValidateTrigger.onNext(fullText)
                }
                
                return false
            }
        }
        
        if let regExp = validType?.regExpOnInput {
            let predicate = NSPredicate(format:"SELF MATCHES %@", regExp)
            if !predicate.evaluate(with: fullText) {
                if validType?.notiErrorOnInput == true {
                    validationProcessor?.explicitValidateTrigger.onNext(fullText)
                }
                
                return false
            }
        }
        
        return true
    }
    
    private func updateLayout(_ alarmText: String?, _ state: TextInputViewState) {
        updateAlarmLabel(alarmText, state)
        layouUpdateObserver.onNext(())
    }
}

extension TextInputBaseView where ValidatorType: TextInputValidateType {
    func vibrate() {}
    
    func focusOn(_ focus: Bool) {
        let responder: UIResponder = inputBase.responder
        
        if focus == true {
            if responder.isFirstResponder == false {
                responder.becomeFirstResponder()
            }
        }
        else {
            if responder.isFirstResponder == true {
                responder.resignFirstResponder()
            }
        }
    }
    
    func validate(type: ValidatorType.ValidationGroup? = nil) {
        if let type = type {
            configuration.validatorConfig.validType = type
        }
        
        validationProcessor?.explicitValidateTrigger.onNext(nil)
    }

    func changeValidate(type: ValidatorType.ValidationGroup) {
        configuration.validatorConfig.validType = type
    }
}

class TextInputSingleLineView<ValidatorType: TextInputValidateType>: TextInputBaseView<ValidatorType>, UITextFieldDelegate {
    private let textField = UITextField().then {
        $0.font = .body3_regular
        $0.textColor = .gray900
        $0.backgroundColor = .clear
        
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
        $0.spellCheckingType = .no
        $0.smartDashesType = .no
        $0.smartQuotesType = .no
    }
    
    init(setting: (inout TextInputConfig<ValidatorType>) -> ()) {
        var config = TextInputConfig<ValidatorType>()
        
        setting(&config)
        
        super.init(base: .textField(textField), configuration: config)
        
        textField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initLayout(_ config: TextInputConfig<ValidatorType>) {
        flex.direction(.column).define { flex in
            if config.textConfig.title?.isEmpty == false {
                let titleLabel = Body3_Bold().then {
                    $0.text = config.textConfig.title
                }
                
                flex.addItem().direction(.row).marginBottom(8).define { flex in
                    flex.addItem(titleLabel)
                    
                    if config.isRequired == true {
                        let requiredLabel = UILabel().then {
                            $0.text = "*"
                            $0.textColor = .blue
                        }
                        
                        flex.addItem(requiredLabel).marginLeft(4)
                    }
                }
            }
            
            flex.addItem(inputWrapView).direction(.row).height(config.height).alignItems(.center).paddingLeft(config.contentPadding.left).paddingRight(config.contentPadding.right).define { flex in
                if config.needShadow == true {
                    let shadowView = UIView().then {
                        $0.backgroundColor = .white100
                        $0.cornerRadius = 2
                        $0.borderWidth = 1
                        $0.borderColor = .grey3
                        $0.layer.shadowColor = UIColor.black.cgColor
                        $0.layer.shadowOpacity = 0.08
                        $0.layer.shadowRadius = 20 / UIScreen.main.scale
                        $0.layer.shadowOffset = .zero
                    }
                    
                    flex.addItem(shadowView).position(.absolute).all(0)
                }
                
                if let startView = config.accessoryConfig.startView {
                    flex.addItem(startView).marginRight(8)
                }
                
                flex.addItem(textField).grow(1).shrink(1)
                
                if config.needClearButton == true {
                    let button = UIButton().then {
                        $0.setImage(UIImage(named: "ic_24_close_oval_gray"), for: .normal)
                        $0.setImage(UIImage(named: "ic_24_close_oval_gray"), for: .highlighted)
                        $0.isHidden = true
                    }
                                        
                    flex.addItem(button).width(24).height(24).marginLeft(8)
                    
                    bindClearButton(button)
                }
                
                if let endView = config.accessoryConfig.endView {
                    flex.addItem(endView).marginLeft(8)
                }
            }
            
            flex.addItem().direction(.column).define { flex in
                flex.addItem(alarmTextLabel).marginTop(8).horizontally(0)
                
                if config.textConfig.helpText?.isEmpty == false {
                    alarmTextLabel.flex.position(.relative)
                    
                    alarmTextLabel.do {
                        $0.text = config.textConfig.helpText
                        $0.textColor = TextInputViewState.enabled.alarmTextColor
                        $0.alpha = 1
                    }
                }
                else {
                    alarmTextLabel.flex.position(.absolute)
                    
                    alarmTextLabel.do {
                        $0.alpha = 0
                    }
                }
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        focusObserver.onNext(true)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        focusObserver.onNext(false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        returnTapObserver.onNext(())
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let delegateShouldChangeTextIn = configuration.delegateShouldChangeTextIn {
            return delegateShouldChangeTextIn(configuration.validatorConfig.validType, textField.text, range, string)
        }
        
        return inputCheck(origin: textField.text, range: range, new: string)
    }
}

extension TextInputSingleLineView where ValidatorType: TextInputValidateType {
    private func bindClearButton(_ button: UIButton) {
        textChangedObservable
            .map { $0.isEmpty }
            .bind(to: button.rx.isHidden)
            .disposed(by: disposeBag)
        
        button.rx.tap
            .asDriver()
            .do(onNext: { [weak self] _ in
                self?.textField.text = ""
            })
            .drive(onNext: { [weak self] in
                button.isHidden = true
                self?.validate()
            })
            .disposed(by: disposeBag)
    }
}

class TextInputMultiLineView<ValidatorType: TextInputValidateType>: TextInputBaseView<ValidatorType>, UITextViewDelegate {
    private let textWrapView = UIView()
    private let textView = UITextView().then {
        $0.font = .body3_regular
        $0.textColor = .gray900
        $0.backgroundColor = .clear
        
        $0.textContainerInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        $0.textContainer.lineFragmentPadding = 0
        
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
        $0.spellCheckingType = .no
        $0.smartDashesType = .no
        $0.smartQuotesType = .no
    }
    
    private var placeholderView: UILabel?
    
    var textViewSize: CGSize {
        textView.frame.size
    }
    
    var textViewMargin: UIEdgeInsets? {
        let bottom = inputWrapView.frame.size.height - textWrapView.frame.maxY
        
        guard bottom > 0 else { return nil } // 레이아웃이 잡히지 않은 경우. endView 가 없으면 최소 bottom 은 10.
        
        return .init(top: textWrapView.frame.origin.y,
                     left: textWrapView.frame.origin.x,
                     bottom: bottom,
                     right: textWrapView.frame.origin.x)
    }
    
    var textViewContainerInset: UIEdgeInsets {
        textView.textContainerInset
    }
    
    var contentOffset: CGPoint {
        get { textView.contentOffset }
        set { textView.contentOffset = newValue }
    }
    
    init(setting: (inout TextInputConfig<ValidatorType>) -> ()) {
        var config = TextInputConfig<ValidatorType>()
        
        setting(&config)
        
        super.init(base: .textView(textView), configuration: config)
        
        textView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initLayout(_ config: TextInputConfig<ValidatorType>) {
        flex.direction(.column).define { flex in
            if config.textConfig.title?.isEmpty == false {
                let titleLabel = Body3_Bold().then {
                    $0.text = config.textConfig.title
                }
                
                flex.addItem().direction(.row).marginBottom(8).define { flex in
                    flex.addItem(titleLabel)
                    
                    if config.isRequired == true {
                        let requiredLabel = Body3_Bold().then {
                            $0.text = "*"
                            $0.textColor = .blue500
                        }
                        
                        flex.addItem(requiredLabel).marginLeft(4)
                    }
                }
            }
            
            flex.addItem(inputWrapView).direction(.column).grow(1).shrink(1).paddingHorizontal(16).define { flex in
                flex.addItem(textWrapView).direction(.column).marginVertical(10).grow(1).shrink(1).define { flex in
                    flex.addItem(textView).grow(1).shrink(1)
                    
                    if config.textConfig.placeHolder?.isEmpty == false {
                        placeholderView = UILabel().then { // 컴포넌트 라벨을 사용하면 최소 높이값을 가지기 때문에 UILabel 사용.
                            $0.text = config.textConfig.placeHolder
                            $0.font = .body3_regular
                            $0.textColor = .gray600
                            $0.numberOfLines = 0
                        }
                        
                        flex.addItem(placeholderView!).position(.absolute).top(4).horizontally(0)
                    }
                }
                
                if let endView = config.accessoryConfig.endView {
                    flex.addItem(endView).marginBottom(10).alignSelf(.end)
                }
            }
            
            flex.addItem().direction(.column).define { flex in
                flex.addItem(alarmTextLabel).marginTop(8).horizontally(0)
                
                if config.textConfig.helpText?.isEmpty == false {
                    alarmTextLabel.flex.position(.relative)
                    
                    alarmTextLabel.do {
                        $0.text = config.textConfig.helpText
                        $0.textColor = TextInputViewState.enabled.alarmTextColor
                        $0.alpha = 1
                    }
                }
                else {
                    alarmTextLabel.flex.position(.absolute)
                    
                    alarmTextLabel.do {
                        $0.alpha = 0
                    }
                }
            }
        }
    }
    
    override func bind() {
        super.bind()
        
        textChangedObservable
            .bindOnMain { [weak self] text in
                guard let self = self else { return }
                
                self.placeholderView?.isHidden = text.isEmpty == false
            }
            .disposed(by: disposeBag)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        focusObserver.onNext(true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        focusObserver.onNext(false)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let delegateShouldChangeTextIn = configuration.delegateShouldChangeTextIn {
            return delegateShouldChangeTextIn(configuration.validatorConfig.validType, textView.text, range, text)
        }
        
        return inputCheck(origin: textView.text, range: range, new: text)
    }
    
    func fitHeight() {
        var height = textView.contentSize.height
        
        if let max = configuration.textConfig.maxHeight {
            height = min(max, height)
        }
        
        textView.flex.height(height)
    }
}

enum ValidationState<Error: ValidationErrorType>: Equatable {
    case success
    case fail(Error)
    
    static func == (lhs: ValidationState<Error>, rhs: ValidationState<Error>) -> Bool {
        switch (lhs, rhs) {
        case (.success, .success):
            return true
            
        case (.fail(let error1), .fail(let error2)):
            return error1.errorDescription == error2.errorDescription
            
        default:
            return false
        }
    }
}

protocol TextValidateType {
//        입력할 때 제한. 에러를 발생시키지 않고 입력만 안됨.
    var limitOnInput: Int? { get }
    var regExpOnInput: String? { get }
    var notiErrorOnInput: Bool { get }
}

extension TextValidateType {
    var notiErrorOnInput: Bool { false }
}

protocol ValidationErrorType {
//    true : validation state 는 error 이지만 TextInputViewState 를 error 로 바꾸지 않아 디자인 변경이 되지 않음. 바깥에서 처리.
    var delegateErrorUI: Bool { get }
    var errorDescription: String? { get }
}

extension ValidationErrorType {
    var delegateErrorUI: Bool { false }
    var errorDescription: String? { nil }
}

protocol TextInputValidateType {
    associatedtype ValidationGroup: TextValidateType
    associatedtype Error: ValidationErrorType
    
    func validate(type: ValidationGroup, text: String?) -> Observable<ValidationState<Error>>
}

extension TextInputValidateType {
    func validate(type: ValidationGroup, text: String?) -> Observable<ValidationState<Error>> {
        return .empty()
    }
}

class EmptyValidator: TextInputValidateType {
    enum ValidationGroup: TextValidateType {
        var limitOnInput: Int? { nil }
        var regExpOnInput: String? { nil }
    }
    
    enum Error: ValidationErrorType {}
}

struct TextInputConfig<ValidatorType: TextInputValidateType> {
    typealias ContentPadding = (left: CGFloat, right: CGFloat)
    
    struct Text {
        var title: String?
        var helpText: String?
        var placeHolder: String?
        var maxHeight: CGFloat?
    }
    
    struct Keyboard {
        var keyboardType: UIKeyboardType = .default
        var secureTextEntry: Bool = false
        var returnKeyType: UIReturnKeyType = .default
        var needDoneToolbar: Bool = false
    }
    
    struct Validator {
        var validator: ValidatorType!
        var validType: ValidatorType.ValidationGroup!
        var debounce: Int = 200 // milliseconds
    }
    
    struct Accessory {
        var startView: UIView?
        var endView: UIView?
    }
    
    var height: CGFloat = 44 // 삭제할 프로퍼티
    var needShadow: Bool = false // 삭제할 프로퍼티
    var isRequired: Bool = false // 타이틀옆 별모양 표기 여부
    var needClearButton: Bool = false
    var initState: TextInputViewState = .enabled
    
    var contentPadding: ContentPadding = ( 16, 16 )
    var textConfig = Text()
    var keyboardConfig = Keyboard()
    var validatorConfig = Validator()
    var accessoryConfig = Accessory()
    
    var delegateShouldChangeTextIn: ((ValidatorType.ValidationGroup?, String?, NSRange, String) -> Bool)?
}
