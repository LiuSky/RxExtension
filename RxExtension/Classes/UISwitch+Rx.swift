//
//  UISwitch+Rx.swift
//  RxExtension
//
//  Created by LiuSky on 03/19/2020.
//  Copyright (c) 2020 LiuSky. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: UISwitch {
    
    func isOn(animated: Bool = true) -> ControlProperty<Bool> {
        
        let source = self.controlEvent(.valueChanged)
            .map { [unowned uiSwitch = self.base] in uiSwitch.isOn }
        
        let sink = Binder<Bool>(self.base) { uiSwitch, isOn in
            guard uiSwitch.isOn != isOn else { return }
            uiSwitch.setOn(isOn, animated: animated)
        }

        return ControlProperty(values: source, valueSink: sink)
    }
}
