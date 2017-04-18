//
//  ObservableConvertibleType+Rx.swift
//  RxExtension
//
//  Created by xiaobin liu on 2017/4/18.
//  Copyright © 2017年 Sky. All rights reserved.
//

import Foundation
import RxSwift

/*
 例子: 
 let disposeBag = DisposeBag()
 Observable.of(1, 2, 3, 5, 1)
           .isEqualOriginValue()
           .debug("IsEqualOriginValue")
           .subscribe()
           .addDisposableTo(disposeBag)
 */


// MARK: - 检查输入结果是否和最初第一个值相同创建一个操作符，可以检查输入结果是否和最初的一样。比如一个 TextField 最初是 text1 ，经过一顿乱输，如何判断最终输入结果是否和最初相同？请尽量复用该操作符到各个场景。
public extension ObservableConvertibleType where E: Equatable {
    
    func isEqualOriginValue() -> Observable<(value: E, isEqualOriginValue: Bool)> {
        return self.asObservable()
            .scan(nil as (origin: E, current: E)?, accumulator: { acc, x -> (origin: E, current: E)? in
                if let acc = acc {
                    return (origin: acc.origin, current: x)
                } else {
                    return (origin: x, current: x)
                }
            })
            .map { diff -> (value: E, isEqualOriginValue: Bool) in
                return (diff!.current, isEqualOriginValue: diff!.origin == diff!.current)
        }
    }
}
