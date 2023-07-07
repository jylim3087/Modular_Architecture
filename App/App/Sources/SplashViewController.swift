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
import RxSwift
import RxCocoa
import FlexLayout

class SplashViewController: UIViewController {

    //caption2_bold
    private let caption2BoldLabel = UILabel().then {
        $0.font = .caption2_bold
        $0.textAlignment = .center
        $0.text = "This is caption2_bold font"
    }
    
    var disposeBag = DisposeBag()
    
    private let image = UIImageView(image: UIImage.ic24RadioDisabled)
    
    private let scrollView = UIScrollView()
    
    let rootView = UIView()

    private let button = UIButton().then {
        $0.backgroundColor = .white
        $0.setTitle("Open Popup", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        scrollView.addSubview(rootView)
        
        
        view.addSubview(button)
        
        let photoView = PhtoView()
        let photoView2 = PhtoView()

        rootView.flex.marginHorizontal(0).marginTop(20).define { flex in
            flex.addItem(photoView).horizontally(0).minHeight(200)
            flex.addItem(photoView2).horizontally(0).minHeight(200).backgroundColor(.yellow).marginVertical(20)

        }
        
        //photoView.flex.layout(mode: .adjustHeight)
        view.backgroundColor = .red400

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        button.pin.bottom(view.pin.safeArea).horizontally().height(50).layout()
        scrollView.pin.above(of: button).horizontally().vertically().layout()
        
        rootView.pin.top().horizontally()
        rootView.flex.layout(mode: .adjustHeight)
        
        scrollView.contentSize = rootView.frame.size
        
    }
}
