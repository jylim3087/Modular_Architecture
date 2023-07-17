//
//  Image+Extension.swift
//  EtcModule
//
//  Created by 임주영 on 2023/07/14.
//

import Foundation
import UIKit

extension UIImage {
    static func getImage(name: String) -> UIImage? {
        return UIImage(named: name, in: Bundle(for: EtcModuleResources.self), compatibleWith: nil)
    }
}
