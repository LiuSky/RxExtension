//
//  UITableViewCell+Rx.swift
//  RxExtension
//
//  Created by xiaobin liu on 2017/3/28.
//  Copyright © 2017年 Sky. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

private var prepareForReuseBag: Int8 = 0

public extension UITableViewCell {
    
    var rx_prepareForReuse: Observable<Void> {
        return Observable.of(self.rx.sentMessage(#selector(UITableViewCell.prepareForReuse)).map { _ in () }, self.rx.deallocated).merge()
    }
    
    
    var rx_prepareForReuseBag: DisposeBag {
        MainScheduler.ensureExecutingOnScheduler()
        
        if let bag = objc_getAssociatedObject(self, &prepareForReuseBag) as? DisposeBag {
            return bag
        }
        
        let bag = DisposeBag()
        objc_setAssociatedObject(self, &prepareForReuseBag, bag, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        
        _ = self.rx.sentMessage(#selector(UITableViewCell.prepareForReuse)).subscribe(onNext: { [weak self] _ in
            let newBag = DisposeBag()
            objc_setAssociatedObject(self as Any, &prepareForReuseBag, newBag, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        })
        
        return bag
    }
}


public extension Reactive where Base: UITableViewCell {

    var prepareForReuseBag: DisposeBag {
        return base.rx_prepareForReuseBag
    }
}

public extension Reactive where Base: UITableViewCell {
    
    var isMarked: Binder<Bool> {
        return Binder(self.base) {  (cell, isMarked) in
            cell.accessoryType = isMarked ? .checkmark : .none
        }
    }
}


