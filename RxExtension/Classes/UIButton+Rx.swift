//
//  UIButton+Rx.swift
//  RxExtension
//
//  Created by LiuSky on 03/19/2020.
//  Copyright (c) 2020 LiuSky. All rights reserved.
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
