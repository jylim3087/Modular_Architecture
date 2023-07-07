////
////  EtcUserInfoView.swift
////  EtcModule
////
////  Created by 임주영 on 2023/06/30.
////
//
//import UIKit
//import ReactorKit
//import FlexLayout
//import Kingfisher
//import Share
//
//final class EtcUserInfoView: UIView {
//    private let agentDescriptionView = UIView()
//    
//    private let nameLabel = Body1_Bold()
//    private let emailLabel = Caption1_Regular().then {
//        $0.textColor = .gray600
//    }
//    private let profileView = UIView()
//    private let profileImageView = UIImageView().then {
//        $0.image = UIImage(named: "profileMore")
//        $0.clipsToBounds = true
//        $0.layer.cornerRadius = 24
//        $0.contentMode = .scaleAspectFill
//    }
//    private let editImageView = UIImageView().then {
//        $0.image = UIImage(named: "ic_edit")
//    }
//    private let arrowImageView = UIImageView().then {
//        $0.image = UIImage(named: "ic_24_arrow_right_gray700")
//    }
//
//    var disposeBag = DisposeBag()
//
//    init(reactor: EtcUserInfoViewReactor) {
//        super.init(frame: .zero)
//
//        self.reactor = reactor
//
//        initLayout(reactor)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func initLayout(_ reactor: EtcUserInfoViewReactor) {
//        flex.direction(.column).define { flex in
//            flex.addItem().direction(.row).height(74).define { flex in
//                flex.addItem().direction(.row).alignItems(.center).grow(1).shrink(1).define { flex in
//                    flex.addItem(profileView).width(48).height(48).marginLeft(20).define { flex in
//                        flex.addItem(profileImageView).width(48).height(48)
//                        flex.addItem(editImageView).position(.absolute).width(24).height(24).bottom(0).right(-12)
//                    }
//                    flex.addItem().direction(.column).justifyContent(.center).marginLeft(20).marginRight(16).grow(1).shrink(1).define { flex in
//                        flex.addItem().direction(.row).alignItems(.center).define { flex in
//                            flex.addItem(nameLabel)
//                            flex.addItem(arrowImageView).marginLeft(13)
//                        }
//
//                        flex.addItem(emailLabel).isHidden(true)
//                    }
//
//                    let button = UIButton()
//
//                    flex.addItem(button).position(.absolute).all(0)
//
//                    bindUserAction(reactor, button)
//                }
//            }
//            flex.addItem().height(1).backgroundColor(.gray200)
//            flex.addItem(agentDescriptionView).isHidden(true).direction(.column).height(52).define { flex in
//                flex.addItem().grow(1).direction(.row).marginLeft(20).define { flex in
//                    let agentLabel = Caption1_Regular().then {
//                        $0.text = "공인중개사 회원은 다방 프로를 이용해주세요."
//                    }
//
//                    flex.addItem(agentLabel).alignSelf(.center)
//                }
//            }
//        }
//    }
//}
//
//extension EtcUserInfoView: ReactorKit.View {
//    func bind(reactor: EtcUserInfoViewReactor) {
////        타입 추론에 따른 빌드 타임 지연으로 loginStateObservable 추가.
//        let loginStateObservable: Observable<(EtcUserInfoViewReactor.LoginState, String?, String?)> = reactor.state
//            .filter { $0.state == .userState }
//            .map { $0.loginState }
//            .map { state -> (EtcUserInfoViewReactor.LoginState, String?, String?) in
//                switch state {
//                case .none: return (state, "로그인 및 회원가입", nil)
//                case .user(let name, _): return (state, name, nil)
//                case .agent(let name, let email, _): return (state, name, email)
//                }
//            }
//            .distinctUntilChanged { $0.1 == $1.1 && $0.2 == $1.2 }
//
//        loginStateObservable
//            .bindOnMain { [weak self] state, name, email in
//                self?.nameLabel.text = name
//                self?.emailLabel.text = email
//
//                self?.nameLabel.flex.markDirty()
//                self?.emailLabel.flex.markDirty()
//
//                self?.profileView.flex.isHidden(!state.isLogin)
//                self?.arrowImageView.flex.isHidden(state.isLogin)
//
//                self?.agentDescriptionView.flex.isHidden(!state.isAgent)
//                self?.emailLabel.flex.isHidden(!state.isAgent)
//                self?.editImageView.flex.isHidden(state.isAgent)
//
//                self?.flex.layout(mode: .adjustHeight)
//            }
//            .disposed(by: disposeBag)
//
//        reactor.state
//            .filter { $0.state == .userState }
//            .map { $0.loginState }
//            .map { state -> ImagePathType? in
//                switch state {
//                case .none: return nil
//                case .user(_, let imagePathType): return imagePathType
//                case .agent(_, _, let imagePathType): return imagePathType
//                }
//            }
//            .bindOnMain { [weak self] imagePathType in
//                switch imagePathType {
//                case .url(let url):
//                    let placeHolder = UIImage(named: "profileMore")
//
//                    self?.profileImageView.kf.setImage(with: URL(string: url),
//                                                       placeholder: placeHolder,
//                                                       options: [.forceRefresh, .onFailureImage(placeHolder), .keepCurrentImageWhileLoading])
//
//                default: break
//                }
//            }
//            .disposed(by: disposeBag)
//    }
//
//    private func bindUserAction(_ reactor: EtcUserInfoViewReactor, _ button: UIButton) {
//        button.rx.tap
//            .map { .userAction }
//            .bind(to: reactor.action)
//            .disposed(by: disposeBag)
//    }
//}
