//
//  File.swift
//  Yodo
//
//  Created by eamon on 2018/3/2.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(navigationView)
//        view.addSubview(displayView)
        
        navigationView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(145)
        }
        
//        displayView.snp.makeConstraints { (make) in
//            make.left.right.bottom.equalTo(self.view)
//            make.top.equalTo(navigationView.snp.bottom)
//        }
        
        viewM.getHomeData { [unowned self](homeModel) in
            self.dataSource = homeModel
            self.navigationView.dates = homeModel.dates
        }
    }
   
    private var dataSource: HomeModel?
    
    // MARK: - Getter | Setter
    private lazy var displayView: DisplayView = {
        
        var displayView = DisplayView()
        displayView.ds = self
        return displayView
    }()
    
    /// 导航栏
    private lazy var navigationView: HomeNavigationView = {
        
        var navigationView = HomeNavigationView()
        navigationView.delegate = self
        return navigationView
    }()

    
    /// viewModel
    private let viewM = AccountViewModel()
}


// MARK: - HomeNavigationViewDelegate
extension HomeViewController: HomeNavigationViewDelegate {
    
    /// 点击日期
    func navigationView(_ navigationView: HomeNavigationView, itemDidSelectedAt indexPath: IndexPath, _ date: YodoDate) {
        
        /* TODO
        // 获取列表数据
        dataSource = viewM.getListData(withYodoDate: date)
        let total = viewM.calculatePrice(withAccounts: viewM.accounts)
        
        headerView.expendMoney = total.expend
        headerView.expendMonth = date.month
        headerView.incomeMoney = total.income
        headerView.incomeMonth = date.month
        
        tableView.reloadData()
        
        // cell动画
        cellsOffsetAnimat()
        */
    }
}

// MARK: - DisplayViewDataSrouce
extension HomeViewController: DisplayViewDataSrouce {
    
    func displayView(_ displayView: DisplayView, contentViewForRowAt index: Int) -> UIView {
        return UIView()
    }
}

// MARK: - Getter | Setter
extension HomeViewController {
    
   
}


