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

/// UIButton.rx拓展
public extension Reactive where Base: UIButton {
    
    /// 选中ControlProperty
    var select: ControlProperty<Bool> {
        
        /// 点击事件源
        let source = tap.map { [unowned button = self.base] _ -> Bool in
            button.isSelected = !button.isSelected
            return button.isSelected
        }
        
        let sink = isSelected
        return ControlProperty(values: source, valueSink: sink)
    }
    
}
