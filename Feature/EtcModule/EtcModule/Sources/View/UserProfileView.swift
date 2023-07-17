//
//  UserProfileView.swift
//  EtcModule
//
//  Created by 임주영 on 2023/07/14.
//

import Foundation
import UIKit
import Share

final class UserProfileView: UIView {
    
    private let profileView = UIView()
    private let profileImageView = UIImageView()
    private let nameLabel = Body1_Bold()
    private let editImageView = UIImageView(image:  UIImage.getImage(name: "ic_edit"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
extension UserProfileView {
    private func initLayout() {
        profileImageView.do {
            $0.layer.cornerRadius = 24
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.image = UIImage.getImage(name: "icProfileNone48")
            $0.backgroundColor = .white0
        }
        
        nameLabel.do {
            $0.text = "임주영"
        }
        
        flex.direction(.column).marginHorizontal(0).define { flex in
            flex.addItem().direction(.row).marginHorizontal(0).height(74).define { flex in
                flex.addItem().direction(.row).alignItems(.center).marginLeft(20).marginRight(16).define { flex in
                    flex.addItem(profileView).width(48).height(48).define { flex in
                        profileView.flex.addItem(profileImageView).all(0).height(48)
                        profileView.flex.addItem(editImageView).width(24).height(24).position(.absolute).bottom(0).right(-12)
                    }
                    flex.addItem(nameLabel).marginLeft(20).grow(1).shrink(1)
                }
            }
            flex.addItem().height(1).backgroundColor(.gray200)
        }
    }
}
