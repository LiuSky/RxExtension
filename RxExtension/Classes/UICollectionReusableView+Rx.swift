//
//  UICollectionReusableView+Rx.swift
//  RxExtension
//
//  Created by LiuSky on 03/19/2020.
//  Copyright (c) 2020 LiuSky. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

private var prepareForReuseBag: Int8 = 0

public extension UICollectionReusableView {
    
    var rx_prepareForReuse: Observable<Void> {
        return Observable.of(self.rx.sentMessage(#selector(UICollectionReusableView.prepareForReuse)).map { _ in () }, self.rx.deallocated).merge()
    }
    
    
    var rx_prepareForReuseBag: DisposeBag {
        MainScheduler.ensureExecutingOnScheduler()
        
        if let bag = objc_getAssociatedObject(self, &prepareForReuseBag) as? DisposeBag {
            return bag
        }
        
        let bag = DisposeBag()
        objc_setAssociatedObject(self, &prepareForReuseBag, bag, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        
        _ = self.rx.sentMessage(#selector(UICollectionReusableView.prepareForReuse)).subscribe(onNext: { [weak self] _ in
            let newBag = DisposeBag()
            objc_setAssociatedObject(self as Any, &prepareForReuseBag, newBag, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        })
        
        return bag
    }
}


public extension Reactive where Base: UICollectionReusableView {
    
    var prepareForReuseBag: DisposeBag {
        return base.rx_prepareForReuseBag
    }
}
