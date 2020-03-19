//
//  UITableView+Rx.swift
//  RxExtension
//
//  Created by LiuSky on 03/19/2020.
//  Copyright (c) 2020 LiuSky. All rights reserved.
//

import UIKit
import RxSwift


public extension Reactive where Base: UITableView {
    
    /// 自动隐藏点击效果
    func enableAutoDeselect() -> Disposable {
        return itemSelected
            .map { (at: $0, animated: true) }
            .subscribe(onNext: base.deselectRow)
    }
    
}

public extension Reactive where Base: UICollectionView {
    
    /// 自动隐藏点击效果
    func enableAutoDeselect() -> Disposable {
        return itemSelected
            .map { (at: $0, animated: true) }
            .subscribe(onNext: base.deselectItem)
    }
    
}

