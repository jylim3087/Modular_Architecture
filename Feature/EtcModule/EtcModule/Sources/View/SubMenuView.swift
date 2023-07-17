//
//  SubMenuView.swift
//  EtcModule
//
//  Created by 임주영 on 2023/07/17.
//

import Foundation
import Share
import UIKit
import RxSwift

final class SubMenuView: UIView {
    //MARK: PROPERTY
    private let menuSelectSubject = PublishSubject<SubMenuType>()
    
    var menuTapObservable: Observable<SubMenuType> {
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
extension SubMenuView {
    private func initLayout() {
        
        flex.direction(.column).marginHorizontal(0).paddingTop(16).paddingBottom(24).justifyContent(.center).define { flex in
            SubMenuType.allCases.forEach { menu in
                let imageView = UIImageView(image: UIImage.readAssetFromShare(name: "ic_24_arrow_right_gray900"))
                let label = Body3_Regular().then {
                    $0.text = menu.title
                    $0.textColor = .gray900
                }
                let button = UIButton(type: .custom)
                
                flex.addItem().direction(.row).grow(1).paddingHorizontal(20).height(58).justifyContent(.spaceBetween).alignItems(.center).define { flex in
                    flex.addItem(label)
                    flex.addItem(imageView).width(24).height(24)

                    flex.addItem(button).position(.absolute).all(0)
                }
                
//                button.rx.tap
//                    .map { _ in menu }
//                    .bind(to: menuSelectSubject)
//                    .disposed(by: disposeBag)
                    
            }
        }
        
//        flex.addItem().height(16).position(.absolute).bottom(0).left(0).right(0).backgroundColor(.gray200)
    }
}
