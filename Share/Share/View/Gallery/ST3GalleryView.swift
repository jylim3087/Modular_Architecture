//
//  ST3GalleryView.swift
//  DabangSwift
//
//  Created by young-soo park on 2017. 8. 1..
//  Copyright © 2017년 young-soo park. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol ST3GalleryViewDelegate : AnyObject {
    func galleryViewTapped(_ galleryView: ST3GalleryView)
    func galleryViewDidZoomIn(_ galleryView: ST3GalleryView)
    func galleryViewDidRestoreZoom(_ galleryView: ST3GalleryView)
    func galleryViewDidEnableScroll(_ galleryView: ST3GalleryView)
    func galleryViewDidDisableScroll(_ galleryView: ST3GalleryView)
}

public class ST3GalleryView: UIView {
    weak var delegate   : ST3GalleryViewDelegate?   = nil
    
    var item            : ST3GalleryItem            = ST3GalleryItem(image: UIImage())
    
    var scrollView      : UIScrollView              = UIScrollView()
    var imageView       : UIImageView               = UIImageView()
    var watermarkView   : WaterMarkView             = WaterMarkView(frame: CGRect.zero)
    var indicator       : ST3IndicatorView          = ST3IndicatorView(frame: CGRect(x: 0, y: 0, width: 40.0, height: 40.0))
    var descriptionView : UIView                    = UIView()
    var descriptionScrollView: UIScrollView         = UIScrollView()
    var label           : Body2_Medium              = Body2_Medium()
    
    var moreButton      : UIButton                  = UIButton()
    
    var moreLabel       : Body3_Bold                = Body3_Bold().then {
        $0.text = "펼쳐보기"
        $0.textColor = .white0
    }
    
    var moreArrowImage  : UIImageView               = UIImageView().then {
        $0.image = UIImage(named: "ic24ArrowUpWhite")
    }
    
    var gradient        : CAGradientLayer           = CAGradientLayer()
    
    var isZoomed    : Bool { return self.scrollView.zoomScale > scrollView.minimumZoomScale }
    var hiddenWatermark: Bool = false
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(item: ST3GalleryItem, frame: CGRect, hiddenWatermark: Bool = false) {
        self.init(frame: frame)
        self.item = item
        self.hiddenWatermark = hiddenWatermark
        self.setupView()
        self.setupGestures()
    }
    
    private func setupView() {
        backgroundColor = UIColor.clear
        self.setupScrollView()
        self.setupImageView()
        self.setupActivityIndicatorView()
        self.setupWaterMarkView()
        
        if let text = item.text, !text.isEmpty {
            self.setupLabel()
        }
    }
    
    private func setupScrollView() {
        self.scrollView.frame           = self.bounds
        self.scrollView.contentSize     = self.bounds.size
        self.scrollView.isScrollEnabled = false
        self.scrollView.bounces         = false
        
        self.scrollView.minimumZoomScale    = 1.0
        self.scrollView.maximumZoomScale    = 5.0
        self.scrollView.decelerationRate    = UIScrollView.DecelerationRate.fast
        self.scrollView.backgroundColor     = UIColor.clear
        
        self.scrollView.showsVerticalScrollIndicator    = false
        self.scrollView.showsHorizontalScrollIndicator  = false
        
        self.scrollView.delegate = self
        
        self.addSubview(self.scrollView)
    }
    
    private func setupImageView() {
        self.imageView.frame            = self.bounds
        self.imageView.contentMode      = .scaleAspectFit
        self.imageView.backgroundColor  = UIColor.clear
        scrollView.addSubview(self.imageView)
    }
    
    private func setupActivityIndicatorView() {
        self.indicator.center           = self.imageView.center
        self.indicator.color            = .gray
        self.addSubview(self.indicator)
    }
    
    private func setupWaterMarkView() {
        self.watermarkView.isHidden = hiddenWatermark
        self.watermarkView.frame        = self.bounds
        self.addSubview(self.watermarkView)
    }
    
    private func setupLabel() {
        self.label.textColor = .white0
        self.label.numberOfLines = 3
        self.descriptionView.backgroundColor = UIColor.gray900.withAlphaComponent(0.4)
        
        self.addSubview(descriptionView)
        self.descriptionView.addSubview(descriptionScrollView)
        self.descriptionScrollView.addSubview(label)
        
        self.descriptionView.addSubview(moreButton)
        self.moreButton.addSubview(moreLabel)
        self.moreButton.addSubview(moreArrowImage)
        
        let gap: CGFloat = UIDevice.current.hasNotch ? 10 : 0
        let originTop = self.frame.height - (138 + gap)
        
        self.descriptionView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(originTop)
        }
        
        self.descriptionScrollView.snp.makeConstraints {
            $0.top.equalTo(16)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
        }
        
        self.label.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.lessThanOrEqualTo(0)
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().priority(.low)
        }
        
        self.moreButton.snp.makeConstraints {
            $0.bottom.equalTo(-16 - gap)
            $0.top.equalTo(descriptionScrollView.snp.bottom).offset(4)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        self.moreLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(21)
        }
        
        self.moreArrowImage.snp.makeConstraints {
            $0.leading.equalTo(moreLabel.snp.trailing).offset(4)
            $0.trailing.equalTo(-20)
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(24)
            $0.height.equalTo(24)
        }
        
        setExpand()
        setAttributeString()
        setGradient()
    }
    
    private func setExpand() {
        let gap: CGFloat = UIDevice.current.hasNotch ? 10 : 0
        let originTop = self.frame.height - (138 + gap)
        
        self.moreButton.rx.tap
            .withUnretained(self)
            .bindOnMain(onNext: { (weakSelf, _) in
                let expand = !weakSelf.moreButton.isSelected
                
                weakSelf.descriptionView.snp.updateConstraints {
                    let top = expand ? UIDevice.current.topPadding + 50 : originTop
                    $0.top.equalTo(top)
                }
                
                weakSelf.label.numberOfLines = expand ? 0 : 3
                weakSelf.label.sizeToFit()
                
                weakSelf.moreLabel.text = expand ? "접기" : "펼쳐보기"
                weakSelf.moreButton.isSelected = expand
                
                UIView.animate(withDuration: 0.2, animations: {
                    weakSelf.moreArrowImage.transform = expand == true ? CGAffineTransform(rotationAngle: .pi) : .identity
                    weakSelf.layoutIfNeeded()
                }, completion: { completion in
                    if completion {
                        var contentSize = weakSelf.descriptionScrollView.contentSize
                        contentSize.height = weakSelf.label.frame.height
                        weakSelf.descriptionScrollView.contentSize = contentSize
                        
                        if expand && contentSize.height + 50 > weakSelf.descriptionScrollView.bounds.height {
                            weakSelf.descriptionScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
                        } else {
                            weakSelf.descriptionScrollView.contentInset = .zero
                        }
                        
                        weakSelf.updateGradient(expand: expand)
                    }
                })
            })
            .disposed(by: disposeBag)
    }
    
    private func setGradient() {
        gradient.colors = [UIColor.black1.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0.85, 1]
        gradient.delegate = self
        
        descriptionScrollView.rx.didScroll
            .withUnretained(self)
            .bindOnMain { (weakSelf, _) in
                weakSelf.updateGradient(expand: weakSelf.moreButton.isSelected)
            }
            .disposed(by: disposeBag)
        
        updateGradient(expand: false)
    }
    
    private func updateGradient(expand: Bool) {
        guard expand else {
            label.layer.mask = nil
            gradient.frame = .zero
            return
        }
        
        label.layer.mask = gradient
        gradient.frame = CGRect(x: 0,
                                y: descriptionScrollView.contentOffset.y,
                                width: descriptionScrollView.bounds.width,
                                height: descriptionScrollView.bounds.height)
    }
    
    private func setAttributeString() {
        guard let text = item.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        let range = NSRange(location: 0, length: attributedString.length)
        
        paragraphStyle.lineSpacing = label.lineSpacing
        paragraphStyle.alignment = item.isRoomSize ? .center : .left
        paragraphStyle.lineBreakMode = label.lineBreakMode
        
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                      value: paragraphStyle,
                                      range: range)
        
        label.attributedText = attributedString
        moreButton.isHidden = getLineCount() < 3
    }
    
    private func getLineCount() -> Int {
        guard let font = label.font else { return 0 }
        let maxSize = CGSize(width: label.frame.width, height: CGFloat(Float.infinity))
        let text = (label.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize,
                                         options: .usesLineFragmentOrigin,
                                         attributes: [.font: font],
                                         context: nil)
        
        return Int(ceil(textSize.height / font.lineHeight))
    }
    
    private func setupGestures() {
        var tap: UITapGestureRecognizer?
        
        self.rx.tapGesture(.recognized) { gesture in
            gesture.numberOfTapsRequired = 1
            gesture.numberOfTouchesRequired = 1
            tap = gesture
        }.bindOnMain { [weak self] _ in guard let self = self else { return }
            if self.scrollView.zoomScale > self.scrollView.minimumZoomScale { self.restoreZoom() }
            self.delegate?.galleryViewTapped(self)
        }.disposed(by: disposeBag)

        self.rx.tapGesture(.recognized) { gesture in
            gesture.numberOfTapsRequired = 2
            gesture.numberOfTouchesRequired = 1
            tap?.require(toFail: gesture)
        }.bindOnMain { [weak self] gesture in
            guard let self = self else { return }
            guard self.moreButton.isSelected == false else { return }
            let pointInView = gesture.location(in: self.imageView)
            self.zoomToPoint(pointInView)
        }.disposed(by: disposeBag)
    }
    
    public override func layoutSubviews() {
        scrollView.frame = self.bounds
        scrollView.contentSize = self.bounds.size
        scrollView.zoomScale = scrollView.minimumZoomScale
        descriptionScrollView.contentSize = label.bounds.size
        updateImageViewSize()
    }
    
    private func zoomToScale(_ newZoomScale: CGFloat, pointInView: CGPoint) {
        let scrollViewSize = self.bounds.size
        let width   = scrollViewSize.width / newZoomScale
        let height  = scrollViewSize.height / newZoomScale
        
        let x = pointInView.x - (width / 2.0)
        let y = pointInView.y - (height / 2.0)
        let zoomRect = CGRect(x: x, y: y, width: width, height: height)
        self.scrollView.zoom(to: zoomRect, animated: true)
    }
    
    fileprivate func fitFrameImageViewToCenter() {
        var zoomFrame = self.imageView.frame
        zoomFrame.origin.x = (zoomFrame.width < self.scrollView.bounds.width) ? self.scrollView.bounds.centerXForRect(zoomFrame) : 0.0
        zoomFrame.origin.y = (zoomFrame.height < self.scrollView.bounds.height) ?
        self.scrollView.bounds.centerYForRect(zoomFrame) : 0.0
        self.imageView.frame = zoomFrame
    }
    
    private func updateImageViewSize() {
        guard let image = self.imageView.image else { return }
        var imageSize = CGSize(width: image.size.width / image.scale, height: image.size.height / image.scale)
        let widthRatio = imageSize.width / self.bounds.width
        let heightRatio = imageSize.height / self.bounds.height
        let imageScaleRatio = max(widthRatio, heightRatio)
        imageSize = CGSize(width: imageSize.width / imageScaleRatio, height: imageSize.height / imageScaleRatio)
        imageView.frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
        restoreZoom(false)
        fitFrameImageViewToCenter()
    }
    
    func zoomToPoint(_ pointInView: CGPoint) {
        let newZoomScale = (self.scrollView.zoomScale < (self.scrollView.maximumZoomScale / 2.0)) ? self.scrollView.maximumZoomScale : self.scrollView.minimumZoomScale
        self.zoomToScale(newZoomScale, pointInView: pointInView)
    }
    
    func restoreZoom(_ animated: Bool = true) {
        if animated {
            zoomToScale(self.scrollView.minimumZoomScale, pointInView: CGPoint.zero)
        } else {
            self.scrollView.zoomScale = self.scrollView.minimumZoomScale
        }
    }
    
    func loadImage() {
        guard self.imageView.image == nil else { return }
        if let image = self.item.image {
            self.imageView.image = image
            updateImageViewSize()
            return
        }
        if let url = self.item.url {
            self.indicator.startAnimating()
            self.imageView.kf.setImage(with: URL(string:url),
                                       placeholder: PlaceholderImageView(UIImage(named: "imgDefaultPhoto")),
                                       completionHandler: { [weak self] result in
                guard let self = self else { return }
                self.indicator.stopAnimating()
                switch result {
                case .success:
                    self.updateImageViewSize()
                    self.watermarkView.isHidden = self.hiddenWatermark
                    self.imageView.backgroundColor = .clear
                case .failure:
                    self.watermarkView.isHidden = true
                    self.imageView.backgroundColor = .grey1
                }
            })
        }
    }
    
    func clearImage() {
        self.imageView.image = nil
    }
}

extension ST3GalleryView : UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? { return self.imageView }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > scrollView.maximumZoomScale {
            scrollView.zoomScale = scrollView.maximumZoomScale
        }
        self.fitFrameImageViewToCenter()
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if scrollView.zoomScale == scrollView.minimumZoomScale {
            self.delegate?.galleryViewDidRestoreZoom(self)
        } else {
            self.delegate?.galleryViewDidZoomIn(self)
        }
        let oldState = scrollView.isScrollEnabled
        scrollView.isScrollEnabled = (scrollView.zoomScale > scrollView.minimumZoomScale)
        if scrollView.isScrollEnabled != oldState {
            if scrollView.isScrollEnabled {
                delegate?.galleryViewDidEnableScroll(self)
            } else {
                delegate?.galleryViewDidDisableScroll(self)
            }
        }
    }
}
