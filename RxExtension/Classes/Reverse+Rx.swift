//
//  Reverse+Rx.swift
//  DianDan
//
//  Created by xiaobin liu on 2017/3/10.
//  Copyright © 2017年 Sky. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public protocol Reverseable {
    var reverseValue: Self { get }
}

extension Bool: Reverseable {
    public var reverseValue: Bool {
        return !self
    }
}

extension Variable where Element: Reverseable {
    /// 设置相反的值
    public func reversed() {
        value = value.reverseValue
    }
}

extension ObservableType where E: Reverseable {
    public func reverse() -> Observable<E> {
        return asObservable().map { $0.reverseValue }
    }
}

