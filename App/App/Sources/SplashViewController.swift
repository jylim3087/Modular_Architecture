//
//  SplashViewController.swift
//  App
//
//  Created by 임주영 on 2023/06/27.
//  Copyright © 2023 co.station3.kr. All rights reserved.
//

import UIKit
import PinLayout
import Then
import Share

class SplashViewController: UIViewController {
    private let label = UILabel().then {
        $0.font = .h1_regular
        $0.textAlignment = .center
        $0.text = "This is h1 regular font"
    }
    //caption2_bold
    private let caption2BoldLabel = UILabel().then {
        $0.font = .caption2_bold
        $0.textAlignment = .center
        $0.text = "This is caption2_bold font"
    }
    
    private let image = UIImageView(image: UIImage.ic24RadioDisabled)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(label)
        view.addSubview(caption2BoldLabel)
        view.addSubview(image)
        
        view.backgroundColor = .red400


    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        label.pin.horizontally().center().sizeToFit(.width).layout()
        caption2BoldLabel.pin.below(of: label).horizontally().center().marginTop(30).sizeToFit(.width).layout()
        image.pin.below(of: caption2BoldLabel).hCenter().width(100).height(100).layout()
    }
}
