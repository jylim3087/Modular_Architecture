//
//  DatePicker.swift
//  DabangPro
//
//  Created by 조동현 on 2023/03/03.
//

import UIKit
import RxSwift
import RxCocoa
import PinLayout
import FlexLayout

public class DatePicker: UIView, DatePickerComponentable {
    typealias Picker = PickerComponent<DefaultPickerItemView>
    
    // MARK: - UI
    
    private let bodyView = UIView()
    
    private let topShadowView = UIView().then {
        $0.isUserInteractionEnabled = false
    }
    
    private let bottomShadowView = UIView().then {
        $0.isUserInteractionEnabled = false
    }
    
    private let yearPicker = Picker()
    
    private let monthPicker = Picker()
    
    private let dayPicker = Picker()
    
    // MARK: - Property
    
    private var disposeBag = DisposeBag()
    private var itemDisposeBag = DisposeBag()
    
    private let years = (1900...2100).map { $0 }
    private let months = (1...12).map { $0 }
    private let days = (1...31).map { $0 }
    
    private let _minDate: [Int] = [1900, 1, 1]
    private let _maxDate: [Int] = [2100, 12, 31]
    
    private var minYear: Int { minDate?.year ?? years.first ?? _minDate[0] }
    private var maxYear: Int { maxDate?.year ?? years.last ?? _maxDate[0] }
    
    private var minMonth: Int { minDate?.month ?? months.first ?? _minDate[1] }
    private var maxMonth: Int { maxDate?.month ?? months.last ?? _maxDate[1] }
    
    private var minDay: Int { minDate?.day ?? days.first ?? _minDate[2] }
    private var maxDay: Int { maxDate?.day ?? days.last ?? _maxDate[2] }
    
    private var _date = Date()
    
    public var date: Date {
        set {
            _date = newValue
            setDate()
        }
        
        get {
            getDate()
        }
    }
    
    public var minDate: Date? {
        didSet {
            setPicker()
        }
    }
    
    public var maxDate: Date? {
        didSet {
            setPicker()
        }
    }
    
    public var dateSelected = PublishSubject<Date>()
    
    public var gradientColor: UIColor = .gray100 {
        didSet {
            setShadow(topShadowView, bounds: topShadowView.frame, rotate: CGFloat(0.0))
            
            var frame = bottomShadowView.frame
            frame.origin = .zero
            setShadow(bottomShadowView, bounds: frame, rotate: CGFloat(180.0))
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initComponent()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initComponent()
    }
    
    private func initComponent() {
        backgroundColor = .gray100
        layer.cornerRadius = 2
        
        initLayout()
        bind()
        
        setDate()
        setPicker()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        bodyView.pin.all()
        bodyView.flex.layout()
    }
    
    private func bind() {
        bindShadowView()
    }
}

extension DatePicker {
    private func initLayout() {
        addSubview(bodyView)
        
        bodyView.flex.minHeight(190).grow(1).shrink(1).define { flex in
            flex.addItem().grow(1).shrink(1).direction(.row).justifyContent(.center).define { flex in
                flex.addItem(yearPicker)
                flex.addItem(monthPicker)
                flex.addItem(dayPicker)
            }
            flex.addItem(topShadowView).position(.absolute).top(0).horizontally(0).height(40%)
            flex.addItem(bottomShadowView).position(.absolute).bottom(0).horizontally(0).height(40%)
        }
    }
    
    private func bindShadowView() {
        let topShadow = topShadowView.rx.observe(CGRect.self, #keyPath(UIView.frame))
            .compactMap { $0 }
            .distinctUntilChanged()
            .map { [weak self] bounds -> (UIView?, CGRect, CGFloat) in
                return (self?.topShadowView, bounds, CGFloat(0.0))
            }
        
        let bottomShadow = bottomShadowView.rx.observe(CGRect.self, #keyPath(UIView.frame))
            .compactMap { $0 }
            .map { $0.size }
            .distinctUntilChanged()
            .map { [weak self] size -> (UIView?, CGRect, CGFloat) in
                let bounds = CGRect(origin: .zero, size: size)
                return (self?.bottomShadowView, bounds, CGFloat(180.0))
            }
        
        Observable.merge(topShadow, bottomShadow)
            .subscribe(onNext: { [weak self] (view, bounds, rotate) in
                self?.setShadow(view, bounds: bounds, rotate: rotate)
            })
            .disposed(by: disposeBag)
    }
    
    private func setShadow(_ view: UIView?, bounds: CGRect, rotate: CGFloat) {
        if let layer = view?.layer.sublayers?.first as? CAGradientLayer {
            layer.removeFromSuperlayer()
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.colors = [gradientColor.withAlphaComponent(1.0).cgColor,
                                gradientColor.withAlphaComponent(0.0).cgColor]
        gradientLayer.transform = CATransform3DMakeRotation(rotate / 180.0 * CGFloat.pi, 0, 0, 1)
        gradientLayer.frame = bounds
        view?.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setPicker() {
        let pickers = [yearPicker, monthPicker, dayPicker]
        [getYears(), getMonths(), getDays()].enumerated().forEach { (index, items) in
            let picker = pickers[index]
            picker.items = items
            picker.alignment = (index == 0 ? .end : .start)
            
            if index == 1 {
                picker.flex.grow(0).shrink(0)
            } else {
                picker.flex.grow(1).shrink(1)
            }
        }
        
        bindPicker()
        setDate()
    }
    
    private func bindPicker() {
        itemDisposeBag = DisposeBag()
        
        yearPicker.itemSelected
            .subscribe(onNext: { [weak self] year in
                guard let self = self else { return }
                
                self.monthPicker.items = self.getMonths()
                self.dayPicker.items = self.getDays()
            })
            .disposed(by: itemDisposeBag)
        
        monthPicker.itemSelected
            .subscribe(onNext: { [weak self] month in
                guard let self = self else { return }
                
                self.dayPicker.items = self.getDays()
            })
            .disposed(by: itemDisposeBag)
        
        
        Observable.of(yearPicker.itemSelected, monthPicker.itemSelected, dayPicker.itemSelected)
            .merge()
            .map { [weak self] _ in self?.date ?? Date() }
            .bind(to: dateSelected)
            .disposed(by: itemDisposeBag)
    }
}

// MARK: - Date Function
extension DatePicker {
    private func setDate() {
        let yearIndex = min(max(0, _date.year - _minDate[0]), years.count - 1)
        let monthIndex = min(max(0, _date.month - _minDate[1]), months.count - 1)
        let dayIndex = min(max(0, _date.day - _minDate[2]), days.count - 1)
        
        yearPicker.selectedIndex = yearIndex
        monthPicker.selectedIndex = monthIndex
        dayPicker.selectedIndex = dayIndex
    }
    
    private func getDate() -> Date {
        let year =  min(max(yearPicker.selectedIndex + _minDate[0], minYear), maxYear)
        let month = min(max(monthPicker.selectedIndex + _minDate[1], minMonth), maxMonth)
        let day = min(max(dayPicker.selectedIndex + _minDate[2], minDay), maxDay)
        
        var dateComponent = DateComponents(year: year, month: month)
        let selectedDate = Calendar.current.date(from: dateComponent)
        let lastDay = selectedDate?.endOfMonth.day ?? 30
        
        dateComponent = DateComponents(year: year, month: month, day: day <= lastDay ? day : lastDay )
        
        let date = Calendar.current.date(from: dateComponent) ?? Date()
        self.date = date
        
        return date
    }
    
    private func getYears() -> [PickerItem] {
        if minDate == nil, maxDate == nil {
            return years.map { PickerItem("\($0)년") }
        }
        
        return years.map { PickerItem("\($0)년", isEnabled: $0 >= minYear && $0 <= maxYear) }
    }
    
    private func getMonths() -> [PickerItem] {
        if minDate == nil, maxDate == nil {
            return months.map { PickerItem("\($0)월") }
        }
        
        let currentYear = date.year
        
        var monthList = months
        
        if currentYear <= minYear {
            monthList = monthList.filter { $0 >= minMonth }
        }
        
        if currentYear >= maxYear {
            monthList = monthList.filter { $0 <= maxMonth }
        }
        
        return months.map { PickerItem("\($0)월", isEnabled: monthList.contains($0)) }
    }
    
    private func getDays() -> [PickerItem] {
        let lastDay = date.endOfMonth.day
        
        if minDate == nil, maxDate == nil {
            return days.map { PickerItem("\($0)일", isEnabled: $0 <= lastDay) }
        }
        
        let currentYear = date.year
        let currentMonth = date.month
                
        var dayList = days
        
        if currentYear <= minYear, currentMonth <= minMonth {
            dayList = dayList.filter { $0 >= minDay }
        }
        
        if currentYear >= maxYear, currentMonth >= maxMonth {
            dayList = dayList.filter { $0 <= maxDay }
        }
        
        return days.map { PickerItem("\($0)일", isEnabled: dayList.contains($0) && $0 <= lastDay) }
    }
}

extension Date {
    public var startOfMonth: Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)

        return  calendar.date(from: components)!
    }
    
    public var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }
    
    public var year: Int {
        return Calendar.current.component(.year, from: self)
    }
        
    public var month: Int {
         return Calendar.current.component(.month, from: self)
    }
    
    public var day: Int {
         return Calendar.current.component(.day, from: self)
    }
}
