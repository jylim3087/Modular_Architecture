//
//  FamilyServiceView.swift
//  EtcModule
//
//  Created by 임주영 on 2023/07/17.
//

import Foundation
import UIKit
import Share
import FlexLayout
import RxSwift

final class FamilyServiceView: UIView {
    //MARK: PROPERTY
    private let menuSelectSubject = PublishSubject<FamilyServiceType>()
    
    var menuTapObservable: Observable<FamilyServiceType> {
        return menuSelectSubject.asObservable()
    }
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension FamilyServiceView {
    private func initLayout() {
        
        flex.direction(.column).paddingTop(24).paddingBottom(40).define { flex in
            let label = Body3_Bold().then {
                $0.text = "다방 패밀리 서비스"
                $0.textColor = .gray600
            }
            flex.addItem(label).marginLeft(20)
            flex.addItem().direction(.row).marginTop(24).height(64).paddingHorizontal(15).define { flex in
                FamilyServiceType.allCases.forEach { menu in
                    let imageView = UIImageView(image: UIImage.getImage(name: menu.iconName))
                    let label = Body3_Regular().then {
                        $0.text = menu.title
                        $0.textColor = .gray700
                    }
                    let button = UIButton(type: .custom)
                    
                    flex.addItem().direction(.column).grow(1).basis(1).justifyContent(.center).alignItems(.center).define { flex in
                        flex.addItem(imageView).width(32).height(32)
                        flex.addItem(label).marginTop(8)
                        flex.addItem(button).position(.absolute).all(0)
                    }
                    
                    button.rx.tap
                        .map { _ in menu }
                        .bind(to: menuSelectSubject)
                        .disposed(by: disposeBag)
                    
                }
            }
        }
    }
}
