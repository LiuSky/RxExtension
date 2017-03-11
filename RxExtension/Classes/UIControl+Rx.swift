//
//  UIControl+Rx.swift
//  DianDan
//
//  Created by xiaobin liu on 2017/3/8.
//  Copyright © 2017年 Sky. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public extension UIControl {
    static func valuePublic<T, ControlType: UIControl>(_ control: ControlType, getter:  @escaping (ControlType) -> T, setter: @escaping (ControlType, T) -> ()) -> ControlProperty<T> {
        let values: Observable<T> = Observable.deferred { [weak control] in
            guard let existingSelf = control else {
                return Observable.empty()
            }
            
            return (existingSelf as UIControl).rx.controlEvent([.allEditingEvents, .valueChanged])
                .flatMap { _ in
                    return control.map { Observable.just(getter($0)) } ?? Observable.empty()
                }
                .startWith(getter(existingSelf))
        }
        return ControlProperty(values: values, valueSink: UIBindingObserver(UIElement: control) { control, value in
            setter(control, value)
        })
    }
}
