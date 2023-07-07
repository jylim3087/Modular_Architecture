//
//  Slider.swift
//  DabangSwift
//
//  Created by you dong woo on 2022/08/01.
//

import UIKit
import Then
import FlexLayout
import RxSwift

public class TwoHandleSlider: UIView {
    private let slidingView = UIView()
    private let areaView = UIView().then {
        $0.backgroundColor = .blue500
    }
    private var handleView1: SliderHandleView!
    private var handleView2: SliderHandleView!
    
    private var percentPerMark: CGFloat = 0
    private var widthPerMark: CGFloat = 0
    private var markList: [SliderMarkData] = []
    
    private let markChangeObsever = PublishSubject<(SliderMarkData, SliderMarkData)>()
    private let disposeBag = DisposeBag()
    
    public let configObserver = PublishSubject<TwoHandleSliderConfiguration>()
    public var markChangeObsevable: Observable<(SliderMarkData, SliderMarkData)> { markChangeObsever }
    
    init() {
        super.init(frame: .zero)
        
        handleView1 = SliderHandleView(slidingView: slidingView)
        handleView2 = SliderHandleView(slidingView: slidingView)
        
//    slidingView 기준의 handle center == handle 부모뷰 기준의 handle origin x
        flex.direction(.column).height(SliderHandleView.handleSize.height).justifyContent(.center).define { flex in
            flex.addItem(slidingView).height(8).backgroundColor(.gray300).marginHorizontal(SliderHandleView.handleSize.width / 2).define { flex in
                flex.view?.layer.cornerRadius = 4
                flex.addItem(areaView).height(8).position(.absolute)
            }
            flex.addItem(handleView1).size(SliderHandleView.handleSize).position(.absolute).top(0).view?.isHidden = true
            flex.addItem(handleView2).size(SliderHandleView.handleSize).position(.absolute).top(0).view?.isHidden = true
        }
        
        bindHandleAction(handleView1, handleView2, areaView)
        bindConfig(handleView1, handleView2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        guard markList.isEmpty == false else { return }
        
        let left1 = slidingView.frame.width * handleView1.currentMark.percent
        let left2 = slidingView.frame.width * handleView2.currentMark.percent
        
        handleView1.flex.left(left1)
        handleView2.flex.left(left2)
        
        areaView.flex.left(min(left1, left2))
        areaView.flex.width(abs(left1 - left2))
        
        widthPerMark = slidingView.frame.width * percentPerMark
    }
    
    private func findClosestMarkIndex(_ handleViewX: CGFloat) -> Int {
        return Int((handleViewX + (widthPerMark / 2)) / widthPerMark)
    }
    
    private func resizeAreaView(_ areaView: UIView, _ handle1x: CGFloat, _ handle2x: CGFloat) {
        var frame = areaView.frame
        frame.origin.x = min(handle1x, handle2x)
        frame.size.width = abs(handle1x - handle2x)
        areaView.frame = frame
    }
}

extension TwoHandleSlider {
    private func bindHandleAction(_ handleView1: SliderHandleView, _ handleView2: SliderHandleView, _ areaView: UIView) {
        bindHandleRangeState(handleView1, handleView2, areaView)
        bindHandleRangeState(handleView2, handleView1, areaView)
    }
    
    private func bindHandleRangeState(_ slideHandleView: SliderHandleView, _ fixedHandleView: SliderHandleView, _ areaView: UIView) {
        let slideEndHandleViewObservable = slideHandleView.slidingLocationObservable
            .filter { recognizer, _ in recognizer.state != .began && recognizer.state != .changed }
            .observe(on: MainScheduler.instance)
            .compactMap { [weak self] _, slideHandleX -> (SliderMarkData, SliderMarkData)? in
                guard let self = self else { return nil }
                
                let slideHandleMark = self.markList[self.findClosestMarkIndex(slideHandleX)]
                
                return (slideHandleMark, fixedHandleView.currentMark)
            }
            .share(replay: 1)
        
        slideEndHandleViewObservable
            .filter { $0.0.index != $0.1.index }
            .compactMap { slideHandleMark, fixedHandleMark -> SliderHandleSlidingRange? in
                if slideHandleMark.index > fixedHandleMark.index {
                    return .range(start: 0, end: slideHandleMark.percent)
                }
                else {
                    return .range(start: slideHandleMark.percent, end: 1)
                }
            }
            .bind(to: fixedHandleView.rangeObserver)
            .disposed(by: disposeBag)
        
        slideEndHandleViewObservable
            .filter { $0.0.index == $0.1.index }
            .map { _, _ in .unknown }
            .bind(to: slideHandleView.rangeObserver, fixedHandleView.rangeObserver)
            .disposed(by: disposeBag)
        
        slideEndHandleViewObservable
            .map { $0.0 }
            .bind(to: slideHandleView.currentMarkBinder)
            .disposed(by: disposeBag)
        
        slideHandleView.slidingLocationObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] recognizer, slideHandleX in
                guard let self = self else { return }
                
                switch recognizer.state {
                case .began, .changed:
                    self.resizeAreaView(areaView, slideHandleX, fixedHandleView.frame.origin.x)
                    
                default:
                    let slideHandleMark = self.markList[self.findClosestMarkIndex(slideHandleX)]
                    let slideHandleX = slideHandleMark.percent * self.slidingView.frame.width
                    
                    UIView.animate(withDuration: 0.1) {
                        slideHandleView.frame.origin =  CGPoint(x: slideHandleX, y: slideHandleView.frame.origin.y)
                        
                        self.resizeAreaView(areaView, slideHandleX, fixedHandleView.frame.origin.x)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        slideHandleView.slidingGestureObservable
            .filter { $0.state == .began }
            .observe(on: MainScheduler.instance)
            .do(onNext: { _ in
                slideHandleView.superview?.bringSubviewToFront(slideHandleView)
            })
            .withLatestFrom(slideHandleView.rangeObserver) { ($0, $1) }
            .filter { _, range in
                switch range {
                case .unknown: return true
                case .range: return false
                }
            }
            .compactMap { [weak self] recognizer, _ -> SliderHandleSlidingRange? in
                guard let self = self else { return nil }
                
                let velocity = recognizer.velocity(in: self.slidingView)
                
                if velocity.x < 0 {
                    return .range(start: 0, end: fixedHandleView.currentMark.percent)
                }
                else {
                    return .range(start: fixedHandleView.currentMark.percent, end: 1)
                }
            }
            .bind(to: slideHandleView.rangeObserver)
            .disposed(by: disposeBag)
        
        
        slideHandleView.slidingLocationObservable
            .compactMap { [weak self] _, slideHandleX -> Int? in
                guard let self = self else { return nil }
                
                return self.findClosestMarkIndex(slideHandleX)
            }
            .distinctUntilChanged()
            .compactMap { [weak self] index -> (SliderMarkData, SliderMarkData)? in
                guard let self = self else { return nil }
                
                let left: SliderMarkData = index > fixedHandleView.currentMark.index ? fixedHandleView.currentMark : self.markList[index]
                let right: SliderMarkData = index > fixedHandleView.currentMark.index ? self.markList[index] : fixedHandleView.currentMark
                
                return (left, right)
            }
            .bind(to: markChangeObsever)
            .disposed(by: disposeBag)
    }
    
    private func bindConfig(_ handleView1: SliderHandleView, _ handleView2: SliderHandleView) {
        let configObservable = configObserver
            .observe(on: MainScheduler.instance)
            .compactMap { [weak self] config -> (SliderMarkData, SliderMarkData)? in
                guard let self = self else { return nil }
                
                self.percentPerMark = 1 / CGFloat(config.range.data.count - 1)
                
                self.markList = config.range.data.enumerated()
                    .map { SliderMarkData(index: $0, percent: CGFloat($0) * self.percentPerMark, value: $1) }
                
                handleView1.isHidden = false
                handleView2.isHidden = false
                
                return (self.markList[config.initValue.index1], self.markList[config.initValue.index2])
            }
            .share(replay: 1)
        
        configObservable
            .subscribe(onNext: { [weak self] handleViewMark1, handleViewMark2 in
                if handleViewMark1.index == handleViewMark2.index {
                    handleView1.rangeObserver.onNext(.unknown)
                    handleView2.rangeObserver.onNext(.unknown)
                    
                    self?.markChangeObsever.onNext((handleViewMark1, handleViewMark2))
                }
                else {
                    let left = handleViewMark1.index < handleViewMark2.index ? handleViewMark1 : handleViewMark2
                    let right = handleViewMark1.index < handleViewMark2.index ? handleViewMark2 : handleViewMark1
                    
                    handleView1.rangeObserver.onNext(.range(start: 0, end: right.percent))
                    handleView2.rangeObserver.onNext(.range(start: left.percent, end: 1))
                    
                    self?.markChangeObsever.onNext((left, right))
                }
                
                self?.setNeedsLayout()
            })
            .disposed(by: disposeBag)
        
        configObservable
            .map { $0.0 }
            .bind(to: handleView1.currentMarkBinder)
            .disposed(by: disposeBag)
        
        configObservable
            .map { $0.1 }
            .bind(to: handleView2.currentMarkBinder)
            .disposed(by: disposeBag)
    }
}

class TwoHandleSliderView: UIView {
    private let slider = TwoHandleSlider()
    
    private let disposeBag = DisposeBag()
    
    public let configObserver = PublishSubject<TwoHandleSliderConfiguration>()
    public var markChangeObsevable: Observable<(Int, Int)> { slider.markChangeObsevable.map { ($0.index, $1.index) } }
    
    init(title: String) {
        super.init(frame: .zero)
        
        let dataLabel = Body2_Regular().then {
            $0.textColor = .blue500
            $0.textAlignment = .right
        }
        
        flex.direction(.column).define { flex in
            flex.addItem().direction(.row).justifyContent(.spaceBetween).define { flex in
                let titleLabel = Body2_Regular().then {
                    $0.text = title
                }
                
                flex.addItem(titleLabel).marginRight(10)
                flex.addItem(dataLabel).grow(1).shrink(1)
            }
            flex.addItem(slider)
        }
        
        bindSlider(slider, dataLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindSlider(_ slider: TwoHandleSlider, _ label: ComponentLabel) {
        configObserver
            .bind(to: slider.configObserver)
            .disposed(by: disposeBag)
        
        slider.markChangeObsevable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { mark1, mark2 in
                label.text = mark1.index == mark2.index ? "\(mark1.value)" : "\(mark1.value) ~ \(mark2.value)"
            })
            .disposed(by: disposeBag)
    }
}
