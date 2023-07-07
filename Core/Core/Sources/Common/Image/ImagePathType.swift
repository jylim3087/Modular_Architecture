//
//  ImagePathType.swift
//  Core
//
//  Created by 임주영 on 2023/07/03.
//

import Foundation

enum ImagePathType: Equatable {
    case url(with: String)
    case asset(name: String)
}
