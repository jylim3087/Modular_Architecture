//
//  FlexLayout+Extension.swift
//  Share
//
//  Created by 임주영 on 2023/06/27.
//

import FlexLayout
import RxSwift
import RxCocoa

extension Flex {
    @discardableResult
    public func isHidden(_ isHidden: Bool) -> Flex {
        self.view?.isHidden = isHidden
        self.isIncludedInLayout(!isHidden)
        
        return self
    }
}

extension Reactive where Base: Flex {
    public var isHidden: Binder<Bool> {
        return Binder(base) { (flex, isHidden) in
            flex.isHidden(isHidden)
        }
    }
}
