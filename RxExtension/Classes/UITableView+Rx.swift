//
//  UITableView+Rx.swift
//  DianDan
//
//  Created by xiaobin liu on 2017/3/10.
//  Copyright © 2017年 Sky. All rights reserved.
//

import UIKit
import RxSwift


extension Reactive where Base: UITableView {
    public func enableAutoDeselect() -> Disposable {
        return itemSelected
            .map { (at: $0, animated: true) }
            .subscribe(onNext: base.deselectRow)
    }
}

extension Reactive where Base: UICollectionView {
    public func enableAutoDeselect() -> Disposable {
        return itemSelected
            .map { (at: $0, animated: true) }
            .subscribe(onNext: base.deselectItem)
    }
}

