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

/// 相反值
public protocol Reverseable {
    var reverseValue: Self { get }
}

extension Bool: Reverseable {
    public var reverseValue: Bool {
        return !self
    }
}

public extension BehaviorRelay where Element: Reverseable {
    /// 设置相反的值
    func reversed() {
        accept(value.reverseValue)
    }
}

public extension ObservableType where Element: Reverseable {
    func reverse() -> Observable<Element> {
        return asObservable().map { $0.reverseValue }
    }
}

