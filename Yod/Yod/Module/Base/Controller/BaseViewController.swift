//
//  BaseViewController.swift
//  Yod
//
//  Created by eamon on 2018/3/2.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = YodConfig.color.background
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default;
    }
    
    
}
