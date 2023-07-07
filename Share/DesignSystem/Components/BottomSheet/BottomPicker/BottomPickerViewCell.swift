//
//  BottomPickerViewCell.swift
//  DabangPro
//
//  Created by 조동현 on 2022/01/27.
//

import UIKit
import Then
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

final public class BottomPickerViewCell: UITableViewCell {
    
    // MARK: - UI
    
    private let titleLabel = Body3_Regular()
    
    private let checkImageView = UIImageView().then {
        $0.image = UIImage(named: "ic_24_check_checked_oval")
    }
    
    // MARK: - Property
    
    var disposeBag = DisposeBag()
    
    var title: String? {
        didSet {
            titleLabel.text = title
            titleLabel.flex.markDirty()
            
            self.setNeedsLayout()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .white100
        
        contentView.flex.define { flex in
            flex.direction(.row).paddingVertical(16).justifyContent(.spaceBetween).alignItems(.center).define { flex in
                flex.addItem(titleLabel).shrink(1)
                flex.addItem(checkImageView).width(24).height(24)
            }
            flex.addItem().height(1).backgroundColor(.gray200).position(.absolute).bottom(0).horizontally(0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        setLayout()
    }
    
    override public func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        
        setLayout()
        
        return contentView.frame.size
    }
    
    private func setLayout() {
        contentView.flex.layout(mode: .adjustHeight)
    }
    
    override public var isSelected: Bool {
        didSet {
            if isSelected {
                titleLabel.font = .systemFont(ofSize: 14, weight: .bold)
                checkImageView.isHidden = false
            } else {
                titleLabel.font = .systemFont(ofSize: 14)
                checkImageView.isHidden = true
            }
        }
    }
}
