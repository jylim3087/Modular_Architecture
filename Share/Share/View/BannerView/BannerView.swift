//
//  SignDetailBannerView.swift
//  DabangSwift
//
//  Created by 조동현 on 2022/03/21.
//

import ReactorKit
import RxSwift
import RxCocoa
import FlexLayout
import PinLayout
import UIKit

enum BannerRatioType {
    case fullWidth
    case horizontalMargin
    
    var ratio: CGFloat {
        switch self {
        case .fullWidth: return 375 / 100
        case .horizontalMargin: return 335 / 102
        }
    }
}

final class BannerView: UIView, ReactorKit.View {
    
    // MARK: - UI
    
    private let bannerView = UIView()
    
    private lazy var imageCarouselView = ST3ImageCarouselView().then {
        $0.delegate = self
    }
    
    private let countView = UIView().then {
        $0.backgroundColor = .gray900.withAlphaComponent(0.4)
    }
    
    private let currentLabel = Caption1_Bold().then {
        $0.textColor = .white0
    }
    
    private let totalLabel = Caption1_Regular().then {
        $0.textColor = .white0
    }
    
    private let dividerView = UIView().then {
        $0.backgroundColor = .gray100
    }
    
    // MARK: - Property
    
    var disposeBag = DisposeBag()
    
    var bannerIndex: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initComponent()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initComponent()
    }
    
    private func initComponent() {
        initLayout()
    }
    
    func bind(reactor: BannerViewReactor) {
        reactor.state
            .map { $0.ratioType }
            .take(1)
            .bindOnMain { [weak self] ratioType in
                self?.imageCarouselView.flex.aspectRatio(ratioType.ratio)
                self?.flex.layout(mode: .adjustHeight)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { !($0.models.count > 0) }
            .bindOnMain { [weak self] isHidden in
                self?.bannerView.flex.isHidden(isHidden)
                self?.dividerView.flex.isHidden(!isHidden)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.models }
            .filter { !$0.isEmpty }
            .take(1)
            .bindOnMain { [weak self] models in
                self?.imageCarouselView.urls = models.map { $0.imagePathType }
                self?.countView.isHidden = models.count <= 1
            }
            .disposed(by: disposeBag)
    }
}

extension BannerView {
    private func initLayout() {
        flex.addItem(bannerView).isHidden(true).define { flex in
            flex.addItem(imageCarouselView).grow(1).shrink(1)
            
            flex.addItem().position(.absolute).right(8).bottom(8).define { flex in
                flex.addItem(countView).direction(.row).paddingHorizontal(12).paddingVertical(4).justifyContent(.center).alignItems(.center).define { flex in
                    flex.addItem(currentLabel)
                    flex.addItem(totalLabel)
                }
            }
        }
        
        flex.addItem(dividerView).height(16)
    }
}

extension BannerView: ST3ImageCarouselViewDeleagte {
    func carousel(carousel: ST3ImageCarouselView, didShow index: Int, forMax count: Int) {
        currentLabel.text = "\(index + 1)/"
        totalLabel.text   = "\(count)"
        
        currentLabel.flex.markDirty()
        totalLabel.flex.markDirty()
        
        countView.flex.layout(mode: .adjustWidth)
        
        setNeedsLayout()
        
        bannerIndex = index
        reactor?.action.onNext(.didShow(at: index))
    }
    
    func selectView(at index: Int) {
        reactor?.action.onNext(.detail(index))
    }
}
