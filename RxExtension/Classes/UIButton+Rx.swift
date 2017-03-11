//
//  UIButton+Rx.swift
//  DianDan
//
//  Created by xiaobin liu on 2017/3/10.
//  Copyright © 2017年 Sky. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIButton {
    public var select: ControlProperty<Bool> {
        let source = tap.map { [unowned button = self.base] _ -> Bool in
            button.isSelected = button.isSelected.reverseValue
            return button.isSelected
        }
        let sink = isSelected
        return ControlProperty(values: source, valueSink: sink)
    }
}
