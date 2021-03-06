//
//  NSObject+Rx.swift
//  RxExtension
//
//  Created by LiuSky on 03/19/2020.
//  Copyright (c) 2020 LiuSky. All rights reserved.
//  fork https://github.com/RxSwiftCommunity/NSObject-Rx

import Foundation
import RxSwift
import RxCocoa
import ObjectiveC


fileprivate var disposeBagContext: UInt8 = 0

/// MARK - 
extension Reactive where Base: AnyObject {
    
    func synchronizedBag<T>( _ action: () -> T) -> T {
        objc_sync_enter(self.base)
        let result = action()
        objc_sync_exit(self.base)
        return result
    }
    
}

public extension Reactive where Base: AnyObject {
    
    /// a unique DisposeBag that is related to the Reactive.Base instance only for Reference type
    /// 为对象添加rx.disposeBag,只用于引用类型对象
    var disposeBag: DisposeBag {
        get {
            return synchronizedBag {
                if let disposeObject = objc_getAssociatedObject(base, &disposeBagContext) as? DisposeBag {
                    return disposeObject
                }
                let disposeObject = DisposeBag()
                objc_setAssociatedObject(base, &disposeBagContext, disposeObject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return disposeObject
            }
        }
        
        set {
            synchronizedBag {
                objc_setAssociatedObject(base, &disposeBagContext, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
}



