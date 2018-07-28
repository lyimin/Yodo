//
//  StatisticsViewController.swift
//  Yod
//
//  Created by eamon on 2018/7/22.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(backBtn)
//        view.addSubview(navigationView)
    }

    //MARK: - Getter | Setter
    
    private lazy var backBtn: UIButton = {
        
        var backBtn = UIButton()
        backBtn.setImage(#imageLiteral(resourceName: "ic_blue_back"), for: .normal)
//        backBtn.addTarget(self, action: #selector(backBtnDidClick), for: .touchUpInside)
        return backBtn
    }()
}
