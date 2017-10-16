//
//  ViewController.swift
//  RxExtension
//
//  Created by xiaobin liu on 2017/3/11.
//  Copyright © 2017年 Sky. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pushButton = UIButton(type: .custom)
        pushButton.backgroundColor = .red
        pushButton.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
        pushButton.addTarget(self, action: #selector(self.push), for: .touchUpInside)
        self.view.addSubview(pushButton)
        
        let popButton = UIButton(type: .custom)
        popButton.backgroundColor = .yellow
        popButton.frame = CGRect(x: 100, y: 200, width: 100, height: 50)
        popButton.addTarget(self, action: #selector(self.popV), for: .touchUpInside)
        self.view.addSubview(popButton)
        
        Observable.just("1").subscribe().disposed(by: rx.disposeBag)
        
    }
    
    @objc private func push() {
        
        let vc = ViewController()
        vc.view.backgroundColor = .black
        self.show(vc, sender: nil)
    }
    
    @objc private func popV() {
        self.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        debugPrint("释放当前控制器")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

