//
//  ST3GalleryViewController.swift
//  DabangSwift
//
//  Created by young-soo park on 2017. 8. 2..
//  Copyright © 2017년 young-soo park. All rights reserved.
//

import UIKit

@objc public protocol ST3GalleryDelegate : AnyObject {
    @objc optional func gallery(_ gallery: ST3GalleryViewController, indexChangeTo index: Int)
}

public class ST3GalleryViewController: UIViewController {
    
    public weak var delegate       : ST3GalleryDelegate?       = nil
    public weak var sourceView     : UIView?                   = nil
    
    fileprivate var items           : [ST3GalleryItem]  = []
    fileprivate var galleryViews    : [ST3GalleryView]  = []
    
    public var pagingScrollView    : UIScrollView  = UIScrollView()
    public var closeButton         : UIButton      = UIButton()
    public var pageLabel           : UILabel       = UILabel()
    
    public var currentIdx          : Int           = 0
    public var currentView         : ST3GalleryView? {
        guard self.currentIdx > -1 && self.currentIdx < self.galleryViews.count else { return nil }
        return self.galleryViews[self.currentIdx]
    }
    
    public var interactor      : ST3GalleryInteractor      = ST3GalleryInteractor()
    public var dismissAnimator : ST3GalleryDismissAnimator = ST3GalleryDismissAnimator()
    
    public var currentImageView    : UIImageView? { return self.currentView?.imageView }
    public var hiddenWatermark: Bool = false
    
    public var toDismiss       : (() -> Void)?                 = nil
    
    public override var prefersStatusBarHidden: Bool { return true }
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) { super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil) }
    
    private var contentSize : CGSize {
        return CGSize(width: self.pagingScrollView.bounds.width * CGFloat(self.items.count), height: self.pagingScrollView.bounds.height)
    }
    
    convenience init(items: [ST3GalleryItem], currentIdx : Int = 0, hiddenWatermark: Bool = false) {
        self.init(nibName: nil, bundle: nil)
        self.items = items
        self.currentIdx = currentIdx
        self.hiddenWatermark = hiddenWatermark
        self.interactor.viewController = self
        self.transitioningDelegate = self
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.pagingScrollView.delegate = self
        self.scrollToIndex(self.currentIdx, animated: false)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updatePageText()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.pagingScrollView.delegate = nil
        
        if let toDismiss = toDismiss {
            toDismiss()
        }
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.clearImagesFarFromIndex(self.currentIdx)
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.updateView(size)
        }, completion: nil)
    }
    
    private func setupView() {
        self.view.backgroundColor = UIColor.black
        self.setupScrollView()
        self.setupGalleryViews()
        self.setupCloseBtn()
        self.setupPageLabel()
        self.loadImagesNextToIndex(self.currentIdx)
    }
    
    private func setupScrollView() {
        self.pagingScrollView.frame = self.getScrollViewFrame(self.view.bounds.size)
        self.pagingScrollView.isPagingEnabled = true
        self.pagingScrollView.showsVerticalScrollIndicator = false
        self.pagingScrollView.showsHorizontalScrollIndicator = false
        self.pagingScrollView.contentSize = self.contentSize
        self.view.addSubview(self.pagingScrollView)
    }
    
    private func setupGalleryViews() {
        var idx = 0
        self.galleryViews = self.items.map({ (item) -> ST3GalleryView in
            let frame = self.getGalleryViewFrame(self.pagingScrollView.frame, pictureIndex: idx)
            let galleryView = ST3GalleryView(item: item, frame: frame, hiddenWatermark: hiddenWatermark)
            galleryView.delegate = self
            pagingScrollView.addSubview(galleryView)
            idx += 1
            return galleryView
        })
    }
    
    private func setupCloseBtn() {
        if self.closeButton.superview != nil { self.closeButton.removeFromSuperview() }
        self.closeButton.setImage(UIImage(named: "ic24AppBarCloseWhite"), for: .normal)
        self.closeButton.setImage(UIImage(named: "ic24AppBarCloseWhite"), for: .highlighted)
        self.closeButton.addTarget(self, action: #selector(ST3GalleryViewController.closeButtonTapped(_:)), for: .touchUpInside)
        self.view.addSubview(self.closeButton)
        
        self.closeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(9)
            $0.leading.equalTo(11)
            $0.width.height.equalTo(32)
        }
    }
    
    private func setupPageLabel() {
        self.pageLabel.numberOfLines = 0
        self.pageLabel.textAlignment = .center
        self.pageLabel.textColor = UIColor.white
        self.pageLabel.font = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.bold)
        self.view.addSubview(pageLabel)
        
        self.pageLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
    }
    
    fileprivate func getScrollViewFrame(_ avaiableSize: CGSize) -> CGRect {
        let x: CGFloat = -10.0
        let y: CGFloat = 0.0
        let width: CGFloat = avaiableSize.width + 10.0
        let height: CGFloat = avaiableSize.height
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    fileprivate func getGalleryViewFrame(_ scrollFrame: CGRect, pictureIndex: Int) -> CGRect {
        let x: CGFloat = ((scrollFrame.size.width) * CGFloat(pictureIndex)) + 10.0
        let y: CGFloat = 0.0
        let width: CGFloat = scrollFrame.size.width - (1 * 10.0)
        let height: CGFloat = scrollFrame.size.height
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    private func updateView(_ avaiableSize: CGSize) {
        self.pagingScrollView.frame = self.getScrollViewFrame(avaiableSize)
        self.pagingScrollView.contentSize = self.contentSize
        var idx = 0
        self.galleryViews.forEach { (view) in
            view.frame = getGalleryViewFrame(self.pagingScrollView.frame, pictureIndex: idx)
            idx += 1
        }
        
        setupCloseBtn()
    }
    
    fileprivate func loadImagesNextToIndex(_ index: Int) {
        guard index > -1 && index < self.galleryViews.count else { return }
        self.galleryViews[index].loadImage()
        for gap in 1 ... 3 {
            let prevIdx = index - gap
            let nextIdx = index + gap
            if prevIdx > -1 { galleryViews[prevIdx].loadImage() }
            if nextIdx < self.galleryViews.count { galleryViews[nextIdx].loadImage() }
        }
    }
    
    fileprivate func clearImagesFarFromIndex(_ index: Int) {
        guard index > -1 && index < self.galleryViews.count else { return }
        let firstIdx = max(index - 3, 0)
        let lastIdx = min(index + 3, self.galleryViews.count - 1)
        self.galleryViews.forEach { (view) in
            if let idx = self.galleryViews.firstIndex(of: view), (idx < firstIdx || idx > lastIdx) {
                view.clearImage()
            }
        }
    }
    
    private func updateContentOffset() {
        let x = (self.pagingScrollView.frame.width * CGFloat(self.currentIdx))
        self.pagingScrollView.setContentOffset(CGPoint(x: x, y: 0.0), animated: false)
    }
    
    fileprivate func toggleControlVisibility() {
        if self.closeButton.isHidden {
            self.showControls()
        } else {
            self.hideControls()
        }
    }
    
    fileprivate func showControls() {
        self.closeButton.isHidden = false
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.pageLabel.alpha = 1.0
            self?.galleryViews.forEach { $0.descriptionView.alpha = 1.0 }
        }
    }
    
    fileprivate func hideControls() {
        self.closeButton.isHidden = true
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.pageLabel.alpha = 0.0
            self?.galleryViews.forEach { $0.descriptionView.alpha = 0.0 }
        }
    }
    
    fileprivate func updatePageText() {
        self.pageLabel.text = "\(self.currentIdx + 1)/\(self.items.count)"
    }
    
    @objc func closeButtonTapped(_ sender: Any?) {
        dismiss(animated: true)
    }
    
    func scrollToIndex(_ index: Int, animated: Bool = true) {
        self.currentIdx = index
        loadImagesNextToIndex(self.currentIdx)
        let x = self.pagingScrollView.frame.width * CGFloat(self.currentIdx)
        self.pagingScrollView.setContentOffset(CGPoint(x: x, y: 0), animated: animated)
    }
    
    func presentInViewController(_ sourceViewController: UIViewController) {
        self.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.modalTransitionStyle = .crossDissolve
        sourceViewController.present(self, animated: true, completion: nil)
    }
}

extension ST3GalleryViewController : UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.galleryViews.forEach { (view) in
            let x = (scrollView.contentOffset.x - view.frame.origin.x + 10)
            view.scrollView.contentOffset = CGPoint(x: x * -0.2, y:0)
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        if page != self.currentIdx { self.delegate?.gallery?(self, indexChangeTo: page) }
        self.currentIdx = page
        self.loadImagesNextToIndex(self.currentIdx)
        self.updatePageText()
    }
}

extension ST3GalleryViewController : UIViewControllerTransitioningDelegate {
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.dismissAnimator
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactor.interacting ? self.interactor : nil
    }
}

extension ST3GalleryViewController : ST3GalleryViewDelegate {
    func galleryViewTapped(_ galleryView: ST3GalleryView) {
        guard let view = self.currentView else { return }
        guard view.scrollView.zoomScale == view.scrollView.minimumZoomScale else { return }
        self.toggleControlVisibility()
    }
    
    func galleryViewDidZoomIn(_ galleryView: ST3GalleryView) { self.hideControls() }
    
    func galleryViewDidRestoreZoom(_ galleryView: ST3GalleryView) { self.showControls() }
    
    func galleryViewDidEnableScroll(_ galleryView: ST3GalleryView) { self.pagingScrollView.isScrollEnabled = false }
    
    func galleryViewDidDisableScroll(_ galleryView: ST3GalleryView) { self.pagingScrollView.isScrollEnabled = true }
}
