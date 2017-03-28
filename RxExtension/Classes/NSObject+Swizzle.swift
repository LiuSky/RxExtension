//
//  NSObject+Swizzle.swift
//  RxExtension
//
//  Created by xiaobin liu on 2017/3/27.
//  Copyright © 2017年 Sky. All rights reserved.
//

import Foundation
import ObjectiveC

internal var swizzeledClasses: [AnyClass] = []

extension NSObject {
    class func swizzleMethodForSelector(_ originalSelector: Selector,
                                        withMethodForSelector swizzledSelector: Selector) {
        if swizzeledClasses.contains(where: { $0 === self }) {
            return
        } else {
            swizzeledClasses.append(self)
        }
        
        let originalMethod = class_getInstanceMethod(self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
        
        let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        
        if didAddMethod {
            class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}
