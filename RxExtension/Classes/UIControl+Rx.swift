//
//  UIControl+Rx.swift
//  RxExtension
//
//  Created by LiuSky on 03/19/2020.
//  Copyright (c) 2020 LiuSky. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// MARK - UIControl
extension UIControl {
    
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
        return ControlProperty(values: values, valueSink: Binder(control) { control, value in
                setter(control, value)
         })
    }
}

