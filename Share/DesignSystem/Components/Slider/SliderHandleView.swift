//
//  SliderHandleView.swift
//  DabangSwift
//
//  Created by you dong woo on 2022/08/09.
//

import UIKit
import Then
import RxSwift

public class SliderHandleView: UIView {
    static let handleSize = CGSize(width: 24, height: 24)
    
    private let disposeBag = DisposeBag()
    
    private var range: SliderHandleSlidingRange = .unknown
    private(set) var currentMark: SliderMarkData!
    
    public let rangeObserver = BehaviorSubject<SliderHandleSlidingRange>(value: .unknown)
    public var slidingLocationObservable: Observable<(UIPanGestureRecognizer, CGFloat)>!
    public var slidingGestureObservable: Observable<(UIPanGestureRecognizer)>!
    public var currentMarkBinder: Binder<SliderMarkData>!
    
    init(slidingView: UIView) {
        super.init(frame: .zero)
        
        layer.cornerRadius = SliderHandleView.handleSize.width / 2
        layer.borderColor = UIColor.blue500.cgColor
        layer.borderWidth = 2
        backgroundColor = .white0
        
        let gesture = UIPanGestureRecognizer()
        addGestureRecognizer(gesture)
        
        slidingGestureObservable = gesture.rx.event.asObservable()
        slidingLocationObservable = bindHandleGesture(gesture, slidingView)
        currentMarkBinder = Binder.init(self) { (base, mark) in
            base.currentMark = mark
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindHandleGesture(_ gesture: UIPanGestureRecognizer, _ slidingView: UIView) -> Observable<(UIPanGestureRecognizer, CGFloat)> {
        let observable = gesture.rx.event
            .withLatestFrom(rangeObserver) { ($0, $1) }
            .compactMap { [weak self] recognizer, range -> (UIPanGestureRecognizer, CGFloat)? in
                guard let self = self else { return nil }
                
                let start: CGFloat
                let end: CGFloat
                
                switch range {
                case .range(let s, let e):
                    start = s
                    end = e
                    
                case .unknown: return nil
                }
                
                let transition = recognizer.translation(in: self)
                let slidingViewWidth = slidingView.frame.size.width
                let rangePixel: (start: CGFloat, end: CGFloat) = (slidingViewWidth * start, slidingViewWidth * end)
                
                var changedX = self.frame.origin.x + transition.x
                
                if changedX < rangePixel.start {
                    changedX = rangePixel.start
                }
                
                if changedX > rangePixel.end {
                    changedX = rangePixel.end
                }
                
                return (recognizer, changedX)
            }
            .observe(on: MainScheduler.instance)
        
        observable
            .subscribe(onNext: { [weak self] recognizer, changedX in
                guard let self = self else { return }
                
                self.frame.origin =  CGPoint(x: changedX, y: self.frame.origin.y)
                
                recognizer.setTranslation(CGPoint.zero, in: self)
            })
            .disposed(by: disposeBag)
        
        return observable
    }
}
