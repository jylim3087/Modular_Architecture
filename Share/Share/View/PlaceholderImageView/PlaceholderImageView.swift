//
//  PlaceholderImageView.swift
//  DabangSwift
//
//  Created by 조동현 on 2020/11/04.
//  Copyright © 2020 young-soo park. All rights reserved.
//

import Kingfisher
import UIKit

public class PlaceholderImageView: Placeholder {
    
    let image: UIImage?
    let contentMode: UIView.ContentMode
    
    init(_ image: UIImage?, placeHolder contentMode: UIView.ContentMode = .center) {
        self.image = image
        self.contentMode = contentMode
    }
    
    public func add(to imageView: KFCrossPlatformImageView) {
        imageView.image = image
        imageView.contentMode = contentMode
    }
    
    public func remove(from imageView: KFCrossPlatformImageView) {
        imageView.image = nil
        imageView.contentMode = .scaleAspectFill
    }
}
