//
//  EctContainerView.swift
//  EtcModule
//
//  Created by 임주영 on 2023/06/30.
//

import UIKit
import Share
import ReactorKit
import RxSwift

final class EctContainerView: UIView, ReactorKit.View {
    //MARK: UI
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let userProfileView = UserProfileView()
    private let mainMenuView = MainMenuView()
    private let subMenuView = SubMenuView()
    private let familyServiceView = FamilyServiceView()
    private let snsView = SnsView()
    private let termView = TermsView()
    private let informationView = InformationView()
    
    //MARK: PROPERTY
    var disposeBag: DisposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.pin.all()
        contentView.pin.top().horizontally()
        
        contentView.flex.layout(mode: .adjustHeight)
        scrollView.contentSize.height = contentView.frame.height
        
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: pin.safeArea.bottom, right: 0)
    }
    
    func bind(reactor: EtcMainViewReactor) {
        
        mainMenuView.menuTapObservable
            .map { .tapMainEvent($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
extension EctContainerView {
    private func initLayout() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.flex.define { flex in
            flex.addItem(userProfileView)
            flex.addItem(mainMenuView)
            flex.addItem(subMenuView)
            flex.addItem(boundaryView())
            flex.addItem(familyServiceView)
            flex.addItem(boundaryView())
            flex.addItem(snsView)
            flex.addItem(boundaryView())
            flex.addItem(termView)
            flex.addItem(informationView)
        }
    }
    
    private func boundaryView(isThin: Bool = false) -> UIView {
        return UIView().then {
            $0.backgroundColor = isThin == true ? .gray200 : .gray100
            $0.flex.height(isThin == true ? 1 : 16)
        }
    }
}
