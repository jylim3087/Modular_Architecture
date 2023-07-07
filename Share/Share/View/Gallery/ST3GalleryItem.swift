//
//  ST3GalleryItem.swift
//  DabangSwift
//
//  Created by young-soo park on 2017. 8. 1..
//  Copyright © 2017년 young-soo park. All rights reserved.
//

import UIKit

struct ST3GalleryItem {
    private var _image          : UIImage?
    private var _placeHolder    : UIImage?  = #imageLiteral(resourceName: "imgLoading")
    private var _url            : String?   = nil
    private var _isLotting      : Bool      = false
    private var _text           : String?   = nil
    private var _isRoomSize     : Bool      = false
    
    var image           : UIImage? { return self._image }
    var placeHolder     : UIImage? { return self._placeHolder }
    var url             : String? { return self._url }
    var isLotting       : Bool { return self._isLotting }
    var text            : String? { return self._text }
    var isRoomSize      : Bool { return self._isRoomSize }
    
    init(image: UIImage) {
        self._image = image
    }
    
    init(url: String, placeHolder : UIImage? = #imageLiteral(resourceName: "imgLoading"), isLotting: Bool = false, text: String? = nil, isRoomSize: Bool = false) {
        self._url = url
        self._placeHolder = placeHolder
        self._isLotting = isLotting
        self._text = text
        self._isRoomSize = isRoomSize
    }
}

extension ST3GalleryItem : Equatable {
    static func == (lhs: ST3GalleryItem, rhs: ST3GalleryItem) -> Bool {
        return lhs.image == rhs.image && lhs.url == rhs.url && lhs.placeHolder == rhs.placeHolder
    }
}
