//
//  SetTimeout.swift
//  Share
//
//  Created by 임주영 on 2023/07/03.
//

import Foundation

import UIKit

public func setTimeout(after:Int, execute: @escaping @convention(block) () -> () ) {
    let when = DispatchTime.now() + DispatchTimeInterval.milliseconds(after)
    DispatchQueue.main.asyncAfter(deadline:when, execute:execute)
}
