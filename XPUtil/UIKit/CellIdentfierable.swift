//
//  CellidentfierCompatible.swift
//  XPUtilExample
//
//  Created by Apple on 2018/12/18.
//  Copyright © 2018年 xyj. All rights reserved.
//

import UIKit

// MARK: - TableViewCell、CollectionViewCell，遵循Cell标志协议，实现为默认实现
extension UITableViewCell: CellidentfierCompatible {}

extension UICollectionViewCell: CellidentfierCompatible{}

extension UITableViewHeaderFooterView: CellidentfierCompatible{}


// MARK: - Cell标志协议
public protocol CellidentfierCompatible {
    associatedtype CompatibleType
    var cell: CompatibleType { get }
    
    var identier: String { get }
}

public struct CellIdentier<Base> {
    let base: Base
}

public extension CellidentfierCompatible {

    static var cell: CellIdentier<Self.Type>{
        return CellIdentier.init(base: self.self)
    }


    var cell: CellIdentier<Self> {
        return CellIdentier.init(base: self)
    }
    
    var identier: String {
        return "\(cell.base)"
    }
    
    static var identier: String {
        return "\(cell.base)"
    }
    
}


// MARK: - TableViewCell、CollectionViewCell，遵循Cell标志协议，实现为默认实现
extension UITableViewCell: Cellidentfierable {}

extension UICollectionViewCell: Cellidentfierable{}

extension UITableViewHeaderFooterView: Cellidentfierable{}

// MARK: - Cell标志协议
protocol Cellidentfierable {
    static var cellIdentfier: String { get }
}

extension Cellidentfierable where Self: UITableViewCell {
    static var cellIdentfier: String {
        return "\(self)"
    }
    
    var cellIdentfier: String {
        return Self.cellIdentfier
    }
}

extension Cellidentfierable where Self: UICollectionViewCell {
    static var cellIdentfier: String {
        return "\(self)"
    }
    
    var cellIdentfier: String {
        return Self.cellIdentfier
    }
}

extension Cellidentfierable where Self: UITableViewHeaderFooterView {
    static var cellIdentfier: String {
        return "\(self)"
    }
    
    var cellIdentfier: String {
        return Self.cellIdentfier
    }
}



/// 注册cell
protocol CellRegistable {}

extension UITableView: CellRegistable {}
extension UICollectionView: CellRegistable {}

extension CellRegistable where Self: UITableView {
    func registerCells<T: UITableViewCell>(_ cellClasses: [T.Type]) {
        cellClasses.forEach {
            self.registerSingleCell($0)
        }
    }

    func registerSingleCell<T: UITableViewCell>(_ cellClass: T.Type) {
        let className = "\(cellClass)"
        /// 存在nib文件
        if let resourcePath = Bundle.main.resourcePath, FileManager.default.fileExists(atPath: resourcePath + "/\(className).nib") {
            let nib  = UINib(nibName: className, bundle: nil)
            self.register(nib, forCellReuseIdentifier: cellClass.cellIdentfier)
        }else {
            self.register(cellClass, forCellReuseIdentifier: cellClass.cellIdentfier)
        }
    }
}

extension CellRegistable where Self: UICollectionView {
    func registerCells<T: UICollectionViewCell>(_ cellClasses: [T.Type]) {
        cellClasses.forEach {
            self.registerSingleCell($0)
        }
    }

    func registerSingleCell<T: UICollectionViewCell>(_ cellClass: T.Type) {
        let className = "\(cellClass)"
        /// 存在nib文件
        if let resourcePath = Bundle.main.resourcePath, FileManager.default.fileExists(atPath: resourcePath + "/\(className).nib") {
            let nib  = UINib(nibName: className, bundle: nil)
            self.register(nib, forCellWithReuseIdentifier: cellClass.cellIdentfier)
        }else {
            self.register(cellClass, forCellWithReuseIdentifier: cellClass.cellIdentfier)
        }
    }
}


