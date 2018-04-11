//
//  File.swift
//  Yodo
//
//  Created by 梁亦明 on 2018/3/2.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(headerView)
        let viewM = AccountViewModel()
        viewM.getDateDataSource()
    }
     
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(140)
        }
    }
    
    // MARK: - Getter | Setter
    private lazy var headerView: HomeHeaderView = {
        
        var headerView = HomeHeaderView()
        return headerView
    }()
}
