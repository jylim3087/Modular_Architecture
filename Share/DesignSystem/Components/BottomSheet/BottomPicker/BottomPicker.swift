//
//  BottomPicker.swift
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

final public class BottomPicker: NSObject {
    
    // MARK: - Property
    
    public var items: [BottomPickerItemType] = []
    
    public var selectedIdx: Int = 0
    
    public var title: String?
    
    public let itemSelected = PublishSubject<Int>()
    
    public let modelSelected = PublishSubject<BottomPickerItemType?>()
    
    private var disposeBag = DisposeBag()
    
    public func show() {
        let vc = BottomPickerViewController()
        vc.pickerTitle = title
        vc.items = items
        vc.selectedIdx = selectedIdx
        
        bind(vc: vc)
        vc.show()
    }
    
    private func bind(vc: BottomPickerViewController) {
        vc.modelSelected
            .subscribe(onNext: { [weak self] in self?.modelSelected.onNext($0) })
            .disposed(by: disposeBag)
        
        vc.itemSelected
            .subscribe(onNext: { [weak self] index in
                self?.selectedIdx = index
                self?.itemSelected.onNext(index)
            })
            .disposed(by: disposeBag)
    }
}

