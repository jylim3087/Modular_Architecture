//
//  BottomPickerViewController.swift
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

final public class BottomPickerViewController: ModalTranslucenceViewController {
    
    private struct Reuse {
        static let pickerCell = ReuseCell<BottomPickerViewCell>()
    }
    
    // MARK: - UI
    
    private let titleLabel = Body3_Bold()
    
    private lazy var tableView = UITableView().then {
        $0.register(Reuse.pickerCell)
        $0.separatorStyle = .none
        $0.backgroundColor = .white100
        $0.showsVerticalScrollIndicator = false
        $0.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
    }
    
    // MARK: - Property
    
    private let cells: PublishSubject<[(String?, Bool)]> = PublishSubject()
    
    private var notchTop: CGFloat {
        if #available(iOS 13.0,  *) {
            return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0
        } else {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0
        }
    }
    
    private var notchBottom: CGFloat {
        if #available(iOS 13.0,  *) {
            return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.bottom ?? 0
        } else {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0
        }
    }
    
    public var pickerTitle: String? {
        didSet {
            titleLabel.text = pickerTitle
        }
    }
    
    public var items: [BottomPickerItemType] = [] {
        didSet {
            cells.onNext(items.enumerated().map { ($0.1.title, $0.0 == selectedIdx) })
        }
    }
    
    public var selectedIdx: Int = 0 {
        didSet {
            cells.onNext(items.enumerated().map { ($0.1.title, $0.0 == selectedIdx) })
        }
    }
    
    public let itemSelected = PublishSubject<Int>()
    public let modelSelected = PublishSubject<BottomPickerItemType?>()
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        bind()
    }
    
    override public func loadView() {
        super.loadView()
        
        bodyView.flex.paddingHorizontal(20).define { flex in
            flex.addItem(titleLabel).marginTop(4)
            flex.addItem().marginTop(16).height(1).backgroundColor(.gray200)
            flex.addItem(tableView)
        }
        
//        bodyView.flex.layout(mode: .adjustHeight)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func show(animated: Bool = false, completion: (() -> Void)? = nil) {
        if let viewController = UIApplication.shared.keyWindow?.rootViewController {
            var presentedController = viewController
            while let presented = presentedController.presentedViewController,
                presentedController.presentedViewController?.isBeingDismissed == false {
                    presentedController = presented
            }
            
            modalPresentationStyle = .overFullScreen
            
            presentedController.present(self, animated: animated) {
                UIView.animate(withDuration: 0.1,
                               delay: 0,
                               options: .curveEaseOut,
                               animations: {
                                self.view.layoutIfNeeded()
                })
            }
        }
    }
}

extension BottomPickerViewController {
    private func bind() {
        cells
            .bind(to: tableView.rx.items) { (tableView, index, element) in
                let cell = tableView.dequeue(Reuse.pickerCell, for: IndexPath(row: index, section: 0))
                cell.title = element.0
                cell.isSelected = element.1
                
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx.observe(CGSize.self, #keyPath(UITableView.contentSize), options: [.new])
            .observe(on: MainScheduler.asyncInstance)
            .compactMap { $0 }
            .compactMap { [weak self] size -> CGFloat? in
                guard let self = self else { return nil }
                
                let maxH = (self.view.frame.maxY - self.notchTop - 40) - 64
                let contentH = size.height + self.notchBottom
                
                self.tableView.isScrollEnabled = maxH <= contentH
                
                return min(contentH, maxH)
            }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] height in
                guard let self = self else { return }
                
                self.tableView.flex.height(height)
                self.updateLayout()
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .map { $0.row }
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] index in
                guard let self = self, index < self.items.count else { return }
                
                let item = self.items[index]
                
                self.dismissWithAnimation {
                    self.itemSelected.onNext(index)
                    self.modelSelected.onNext(item)
                }
            })
            .disposed(by: disposeBag)
    }
}
