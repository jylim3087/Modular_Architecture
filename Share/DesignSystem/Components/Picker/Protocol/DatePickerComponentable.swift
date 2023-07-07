//
//  DatePickerComponentable.swift
//  Share
//
//  Created by 임주영 on 2023/06/30.
//

import Foundation
import RxSwift

protocol DatePickerComponentable {
    var date: Date { get set }
    var minDate: Date? { get set }
    var maxDate: Date? { get set }
    var dateSelected: PublishSubject<Date> { get }
}
