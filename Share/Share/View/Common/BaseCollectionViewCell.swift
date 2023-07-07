//
//  BaseCollectionViewCell.swift
//  Share
//
//  Created by 임주영 on 2023/07/03.
//
import UIKit
import RxSwift

public class BaseCollectionViewCell: UICollectionViewCell {

    // MARK: Rx
  
    var disposeBag = DisposeBag()
  
    // MARK: Layout Constraints

    private(set) var didSetupConstraints = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if !self.didSetupConstraints {
          self.setupConstraints()
          self.didSetupConstraints = true
        }
    }
  
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        if !self.didSetupConstraints {
          self.setupConstraints()
          self.didSetupConstraints = true
        }
    }
      
    public func setupConstraints() {
        // Override
    }
}
