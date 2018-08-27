//
//  Operators+Rx.swift
//  DianDan
//
//  Created by xiaobin liu on 2017/3/10.
//  Copyright © 2017年 Sky. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

infix operator <-> : DefaultPrecedence

public func nonMarkedText(_ textInput: UITextInput) -> String? {
    let start = textInput.beginningOfDocument
    let end = textInput.endOfDocument
    
    guard let rangeAll = textInput.textRange(from: start, to: end),
        let text = textInput.text(in: rangeAll) else {
            return nil
    }
    
    guard let markedTextRange = textInput.markedTextRange else {
        return text
    }
    
    guard let startRange = textInput.textRange(from: start, to: markedTextRange.start),
        let endRange = textInput.textRange(from: markedTextRange.end, to: end) else {
            return text
    }
    
    return (textInput.text(in: startRange) ?? "") + (textInput.text(in: endRange) ?? "")
}

public func <-> <Base>(textInput: TextInput<Base>, behaviorRelay: BehaviorRelay<String>) -> Disposable {
    let bindToUIDisposable = behaviorRelay.asObservable()
        .bind(to: textInput.text)
    let bindToVariable = textInput.text
        .subscribe(onNext: { [weak base = textInput.base] n in
            guard let base = base else {
                return
            }
            
            let nonMarkedTextValue = nonMarkedText(base)
            
            /**
             In some cases `textInput.textRangeFromPosition(start, toPosition: end)` will return nil even though the underlying
             value is not nil. This appears to be an Apple bug. If it's not, and we are doing something wrong, please let us know.
             The can be reproed easily if replace bottom code with
             
             if nonMarkedTextValue != variable.value {
             variable.value = nonMarkedTextValue ?? ""
             }
             
             and you hit "Done" button on keyboard.
             */
            if let nonMarkedTextValue = nonMarkedTextValue, nonMarkedTextValue != behaviorRelay.value {
                behaviorRelay.accept(nonMarkedTextValue)
            }
            }, onCompleted:  {
                bindToUIDisposable.dispose()
        })
    
    return Disposables.create(bindToUIDisposable, bindToVariable)
}


public func <-> <T>(property: ControlProperty<T>, behaviorRelay: BehaviorRelay<T>) -> Disposable {
    if T.self == String.self {
        #if DEBUG
        fatalError("It is ok to delete this message, but this is here to warn that you are maybe trying to bind to some `rx.text` property directly to variable.\n" +
            "That will usually work ok, but for some languages that use IME, that simplistic method could cause unexpected issues because it will return intermediate results while text is being inputed.\n" +
            "REMEDY: Just use `textField <-> variable` instead of `textField.rx.text <-> variable`.\n" +
            "Find out more here: https://github.com/ReactiveX/RxSwift/issues/649\n"
        )
        #endif
    }
    
    let bindToUIDisposable = behaviorRelay.asObservable()
        .bind(to: property)
    let bindToVariable = property
        .subscribe(onNext: { n in
            behaviorRelay.accept(n)
        }, onCompleted:  {
            bindToUIDisposable.dispose()
        })
    
    return Disposables.create(bindToUIDisposable, bindToVariable)
}
