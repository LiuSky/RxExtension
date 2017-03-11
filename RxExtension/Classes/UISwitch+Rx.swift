//
//  UISwitch+Rx.swift
//  DianDan
//
//  Created by xiaobin liu on 2017/3/10.
//  Copyright © 2017年 Sky. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UISwitch {
    public func isOn(animated: Bool = true) -> ControlProperty<Bool> {
        let source = self.controlEvent(.valueChanged)
            .map { [unowned uiSwitch = self.base] in uiSwitch.isOn }
        let sink = UIBindingObserver<UISwitch, Bool>(UIElement: self.base) { uiSwitch, isOn in
            guard uiSwitch.isOn != isOn else { return }
            uiSwitch.setOn(isOn, animated: animated)
        }
        return ControlProperty(values: source, valueSink: sink)
    }
}
