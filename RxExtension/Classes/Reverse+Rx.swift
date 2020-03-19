//
//  Reverse+Rx.swift
//  RxExtension
//
//  Created by LiuSky on 03/19/2020.
//  Copyright (c) 2020 LiuSky. All rights reserved.
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

