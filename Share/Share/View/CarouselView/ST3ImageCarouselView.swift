//
//  ST3CarouselView.swift
//  DabangSwift
//
//  Created by young-soo park on 2017. 11. 23..
//  Copyright © 2017년 young-soo park. All rights reserved.
//

import UIKit
import PinLayout
import Kingfisher

private let kPanGestureThreshdoler: CGFloat = 100

@objc
protocol ST3ImageCarouselViewDeleagte : AnyObject {
    func selectView(at index: Int)
    func carousel(carousel : ST3ImageCarouselView, didShow index:Int, forMax count:Int)
}

extension ST3ImageCarouselViewDeleagte {
    func carousel(carousel : ST3ImageCarouselView, didShow index:Int, forMax count:Int) {}
}

class ST3ImageCarouselView: UIView {
    let panGesture      : UIPanGestureRecognizer    = UIPanGestureRecognizer()
    
    let contentView     : UIView                    = UIView()
    
    var leftView        : UIImageView               = UIImageView()
    var middleView      : UIImageView               = UIImageView()
    var rightView       : UIImageView               = UIImageView()
    var btnBanner       : UIButton                  = UIButton()
    var timer           : Timer?                    = nil
    var enableAutoScroll: Bool                      = true

    var urls            : [ImagePathType]  = [] { didSet { self.reloadViews() } }
    
    private var currentIndex    = 0 { didSet { self.sendCarouselIndexInfo() } }
    private var prevIndex : Int { return (currentIndex > 0) ? currentIndex - 1 : self.urls.count - 1 }
    private var nextIndex : Int { return (currentIndex < self.urls.count - 1) ? currentIndex + 1 : 0 }
    
    private var currentPathType  : ImagePathType? { return (currentIndex > -1 && currentIndex < self.urls.count) ? self.urls[currentIndex] : nil }
    private var prevPathType     : ImagePathType? { return (prevIndex > -1 && prevIndex < self.urls.count) ? self.urls[prevIndex] : nil }
    private var nextPathType     : ImagePathType? { return (nextIndex > -1 && nextIndex < self.urls.count) ? self.urls[nextIndex] : nil }

    @IBOutlet weak var delegate   : ST3ImageCarouselViewDeleagte?      = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.pin.all()
        
        leftView.pin.all()
        middleView.pin.all()
        rightView.pin.all()
        btnBanner.pin.all()
        
        let bounds = self.bounds
        self.leftView.transform     = self.transform.translatedBy(x: -bounds.width, y: 0)
        self.middleView.transform   = CGAffineTransform.identity
        self.rightView.transform    = self.transform.translatedBy(x: bounds.width, y: 0)
    }
    
    func setupViews() {
        self.clipsToBounds = true
        self.isUserInteractionEnabled = true
        
        addSubview(contentView)
        
        contentView.addSubview(self.leftView)
        contentView.addSubview(self.middleView)
        contentView.addSubview(self.rightView)
        contentView.addSubview(self.btnBanner)
        
        self.leftView.contentMode   = .scaleAspectFill
        self.middleView.contentMode = .scaleAspectFill
        self.rightView.contentMode  = .scaleAspectFill
        
        self.leftView.isUserInteractionEnabled = false
        self.middleView.isUserInteractionEnabled = false
        self.rightView.isUserInteractionEnabled = false
        
        self.panGesture.addTarget(self, action: #selector(ST3ImageCarouselView.panHandle(_:)))
        self.btnBanner.addTarget(self, action: #selector(ST3ImageCarouselView.touchUpBtn(sender:)), for: .touchUpInside)
        
        self.addGestureRecognizer(panGesture)
        self.panGesture.delegate = self
    }
    
    func reloadViews() {
        self.leftView.clipsToBounds     = true
        self.middleView.clipsToBounds   = true
        self.rightView.clipsToBounds    = true
        
        self.currentIndex = 0
        
        self.setupCenterContentView()
        self.setupSideContentViews()
        
        self.setupTimer()
    }
    
    func setupTimer() {
        self.timer?.invalidate()
        self.timer = nil

        guard self.urls.count > 1 else { return }
        guard enableAutoScroll == true else { return }
        
        self.timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(ST3ImageCarouselView.timerScrollTo), userInfo: nil, repeats: false)
    }
    
    func setupCenterContentView() {
        middleView.image   = nil
        
        guard let pathType = currentPathType else { return }
        
        setImage(middleView, pathType)
    }
    
    func setupSideContentViews() {
        leftView.image     = nil
        rightView.image    = nil
        
        if let pathType = prevPathType {
            setImage(leftView, pathType)
        }
        
        if let pathType = nextPathType {
            setImage(rightView, pathType)
        }
    }
    
    private func setImage(_ targetImageView: UIImageView, _ pathType: ImagePathType) {
        switch pathType {
        case .url(let url):
            targetImageView.kf.setImage(with: URL(string: url))
            
        case .asset(let name):
            targetImageView.image = UIImage(named: name)
        }
    }
    
    func clearSideContentViews() {
        self.leftView.image     = nil
        self.rightView.image    = nil
    }
    
    func sendCarouselIndexInfo() {
        self.delegate?.carousel(carousel: self, didShow: self.currentIndex, forMax: self.urls.count)
    }
    
    @objc func timerScrollTo() {
        self.timer?.invalidate()
        self.scrollToNext()
    }
    
    func scrollToNext() {
        let bounds = self.bounds
        let duration = 0.3 * ( (frame.width + self.middleView.frame.minX) / frame.width )
        UIView.animate(withDuration: Double(duration), animations: {
            self.leftView.transform     = self.transform.translatedBy(x: -(bounds.width * 2), y: 0)
            self.middleView.transform   = self.transform.translatedBy(x: -bounds.width, y: 0)
            self.rightView.transform    = CGAffineTransform.identity
        }, completion: { (_) in
            let leftView                = self.leftView
            self.leftView               = self.middleView
            self.middleView             = self.rightView
            self.rightView              = leftView
            self.rightView.transform    = self.transform.translatedBy(x: bounds.width, y: 0)
            self.currentIndex           = self.nextIndex
            self.setupSideContentViews()
            self.setupTimer()
        })
    }
    
    func scrollToPrev() {
        let bounds = self.bounds
        let duration = 0.3 * ( (frame.width - self.middleView.frame.minX) / frame.width )
        UIView.animate(withDuration: Double(duration), animations: {
            self.leftView.transform     = CGAffineTransform.identity
            self.middleView.transform   = self.transform.translatedBy(x: bounds.width, y: 0)
            self.rightView.transform    = self.transform.translatedBy(x: (bounds.width * 2), y: 0)
        }, completion: { (_) in
            let rightView               = self.rightView
            self.rightView              = self.middleView
            self.middleView             = self.leftView
            self.leftView               = rightView
            self.leftView.transform     = self.transform.translatedBy(x: -(bounds.width * 2), y: 0)
            self.currentIndex = self.prevIndex
            self.setupSideContentViews()
            self.setupTimer()
        })
    }
    
    func scrollToCurrent() {
        let bounds = self.bounds
        UIView.animate(withDuration: 0.3, animations: {
            self.leftView.transform     = self.transform.translatedBy(x: -bounds.width, y: 0)
            self.middleView.transform   = CGAffineTransform.identity
            self.rightView.transform    = self.transform.translatedBy(x: bounds.width, y: 0)
        })
    }
    
    @objc func touchUpBtn(sender: Any?) {
        self.delegate?.selectView(at: self.currentIndex)
    }
    
    @objc func panHandle(_ panGesture: UIPanGestureRecognizer) {
        let offset = panGesture.translation(in: panGesture.view)
        let velocity = panGesture.velocity(in: panGesture.view)
        guard self.urls.count > 1 else { return }
        
        let bounds = self.bounds
        switch panGesture.state {
        case .began:
            self.timer?.invalidate()
        case .changed:
            self.leftView.transform     = self.transform.translatedBy(x: -bounds.width + offset.x, y: 0)
            self.middleView.transform   = self.transform.translatedBy(x: offset.x, y: 0)
            self.rightView.transform    = self.transform.translatedBy(x: bounds.width + offset.x, y: 0)
        case .ended, .cancelled:
            if offset.x > 0 && velocity.x > 0 {
                self.scrollToPrev()
            } else if offset.x < 0 && velocity.x < 0 {
                self.scrollToNext()
            } else {
                self.scrollToCurrent()
            }
        default:
            break
        }
    }
}

extension ST3ImageCarouselView: UIGestureRecognizerDelegate {
    override public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else { return false }
        let velocity = panGestureRecognizer.velocity(in: self)
        
        return abs(velocity.x) > kPanGestureThreshdoler
    }
}
