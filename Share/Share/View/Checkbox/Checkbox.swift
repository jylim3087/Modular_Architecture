//
//  Checkbox.swift
//  Checkbox
//
//  Created by 진하늘 on 30/09/2019.
//  Copyright © 2019 진하늘. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class Checkbox: UIControl {
    private var selectImageView     : UIImageView       = UIImageView()
    private var deselectImageView   : UIImageView       = UIImageView()

    var style                       : CheckboxStyle     = .square
    var animateType                 : CheckboxAnimate   = .fill
    var isAnimating                 : Bool              = false
    
    var isSelectedObs               : PublishSubject<Bool> = PublishSubject<Bool>()
    
    override var isSelected: Bool {
        didSet {
            self.isSelectedObs.onNext(self.isSelected)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initCheckbox()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.initCheckbox()
    }
    
    private func initCheckbox() {
        addTarget(self, action: #selector(toggle), for: .touchUpInside)
        setLayout(deselectImageView)
        setLayout(selectImageView)
        selectImageView.image = style.selectImage
        deselectImageView.image = style.deselectImage
        animate(self.isSelected, type: .none)
    }
    
    private func setLayout(_ imageView: UIImageView) {
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let anchors = [imageView.topAnchor.constraint(equalTo: topAnchor),
                       imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
                       imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                       imageView.trailingAnchor.constraint(equalTo: trailingAnchor)]
        NSLayoutConstraint.activate(anchors)
    }
    
    func setSelected(_ isSelected: Bool) {
        guard !isAnimating else { return }
        self.isSelected = isSelected
        self.animate(isSelected, type: .none)
    }
    
    private func animate(_ isSelected: Bool, type animate: CheckboxAnimate) {
        self.selectImageView.isHidden = false
        guard animate != .none else { return selectImageView.isHidden = !isSelected }
        
        self.isAnimating = true
        if isSelected { selectImageView.transform = CGAffineTransform(scaleX: 0, y: 0) }
        let transform = CGAffineTransform(scaleX: !isSelected ? 0.001 : 1, y: !isSelected ?  0.001 : 1)
        
        UIView.animate(withDuration: 0.15,
                       delay: 0,
                       usingSpringWithDamping: animate == .bounce ? 0.5 : 1.0,
                       initialSpringVelocity: 1.0,
                       animations: {
                            if animate != .none { self.selectImageView.transform = transform }
                        }, completion: { _ in
                            self.selectImageView.isHidden = !isSelected
                            self.isAnimating = false
                        })
    }
    
    @objc func toggle() {
        guard !isAnimating else { return }
        self.isSelected.toggle()
        self.animate(isSelected, type: animateType)
    }
    
}
