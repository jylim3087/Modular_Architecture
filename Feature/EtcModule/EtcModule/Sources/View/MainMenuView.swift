//
//  MainMenuView.swift
//  EtcModule
//
//  Created by 임주영 on 2023/07/14.
//

import Foundation
import UIKit
import Share
import RxSwift

final class MainMenuView: UIView {
    //MARK: PROPERTY
    private let menuSelectSubject = PublishSubject<MainMenuType>()
    
    var menuTapObservable: Observable<MainMenuType> {
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
extension MainMenuView {
    private func initLayout() {
        
        flex.direction(.column).marginHorizontal(0).height(98).justifyContent(.center).define { flex in
            flex.addItem().direction(.row).paddingHorizontal(15).define { flex in
                
                MainMenuType.allCases.forEach { menu in
                    let imageView = UIImageView(image: UIImage.getImage(name: menu.iconName))
                    let label = Body3_Regular().then {
                        $0.text = menu.title
                        $0.textColor = .gray700
                    }
                    let button = UIButton(type: .custom)
                    
                    flex.addItem().direction(.column).grow(1).basis(1).justifyContent(.center).alignItems(.center).define { flex in
                        flex.addItem(imageView)
                        flex.addItem(label).marginTop(2)
                        flex.addItem(button).position(.absolute).all(0)
                    }
                    
                    button.rx.tap
                        .map { _ in menu }
                        .bind(to: menuSelectSubject)
                        .disposed(by: disposeBag)
                        
                }
            }
        }
        
        flex.addItem().height(1).position(.absolute).bottom(0).left(0).right(0).backgroundColor(.gray200)
    }
}
