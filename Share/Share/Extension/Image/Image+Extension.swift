//
//  Image+Extension.swift
//  Share
//
//  Created by 임주영 on 2023/06/27.
//

import Foundation
import UIKit

extension UIImage {
    static func getImage(name: String) -> UIImage? {
        return UIImage(named: name, in: Bundle(for: Share.ShareResources.self), compatibleWith: nil)
    }
}
