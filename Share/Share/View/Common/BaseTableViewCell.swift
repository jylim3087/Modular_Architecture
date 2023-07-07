//
//  BaseTableViewCell.swift
//  Share
//
//  Created by 임주영 on 2023/07/03.
//

import Foundation
import UIKit
import RxSwift

public class BaseTableViewCell: UITableViewCell {

    // MARK: Rx

    var disposeBag = DisposeBag()

    // MARK: Layout Constraints

    private(set) var didSetupConstraints = false

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.didSetupConstraints {
            self.setupConstraints()
            self.didSetupConstraints = true
        }
    }

    required convenience init?(coder: NSCoder) {
        self.init(style: .default, reuseIdentifier: nil)
    }

    public func setupConstraints() {
        // Override
    }
}
