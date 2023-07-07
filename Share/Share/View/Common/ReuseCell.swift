//
//  Reusable.swift
//  DabangSwift
//
//  Created by Ickhwan Ryu on 2020/09/25.
//  Copyright © 2020 young-soo park. All rights reserved.
//
import UIKit

public protocol CellTypes: AnyObject {
    var reuseIdentifier: String? { get }
}

public struct ReuseCell<Cell: CellTypes> {
    typealias Class = Cell
    
    let `class`: Class.Type = Class.self
    let identifier: String
    let nib: UINib?
    
    init(identifier: String? = nil, nib: UINib? = nil) {
        self.identifier = nib?.instantiate(withOwner: nil, options: nil).lazy
            .compactMap { ($0 as? CellTypes)?.reuseIdentifier }
            .first ?? identifier ?? UUID().uuidString
        self.nib = nib
    }
    
    init(identifier: String? = nil) {
        if Bundle.main.path(forResource: String(describing: Cell.self), ofType: "nib") != nil {
            let nib = UINib(nibName: String(describing: Cell.self), bundle: nil)
            self.init(identifier: identifier, nib: nib)
        } else {
            self.init(identifier: identifier, nib: nil)
        }
    }
}

extension UITableViewCell: CellTypes {
    
}

extension UICollectionViewCell: CellTypes {
    
}

extension UITableView {
    public func register<Cell>(_ cell: ReuseCell<Cell>) {
        if let nib = cell.nib {
            self.register(nib, forCellReuseIdentifier: cell.identifier)
        } else {
            self.register(Cell.self, forCellReuseIdentifier: cell.identifier)
        }
    }
    
    public func dequeue<Cell>(_ cell: ReuseCell<Cell>) -> Cell? {
        return self.dequeueReusableCell(withIdentifier: cell.identifier) as? Cell
    }
    
    public func dequeue<Cell>(_ cell: ReuseCell<Cell>, for indexPath: IndexPath) -> Cell {
        return self.dequeueReusableCell(withIdentifier: cell.identifier, for: indexPath) as! Cell
     }
}

extension UICollectionView {
    public func register<Cell>(_ cell: ReuseCell<Cell>) {
        if let nib = cell.nib {
            self.register(nib, forCellWithReuseIdentifier: cell.identifier)
        } else {
            self.register(Cell.self, forCellWithReuseIdentifier: cell.identifier)
        }
    }
    
    public func dequeue<Cell>(_ cell: ReuseCell<Cell>, for indexPath: IndexPath) -> Cell {
      return self.dequeueReusableCell(withReuseIdentifier: cell.identifier, for: indexPath) as! Cell
    }
}
