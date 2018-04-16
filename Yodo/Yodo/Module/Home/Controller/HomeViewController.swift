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
        view.addSubview(tableView)
        
        let dates = viewM.getDateDataSource()
        navigationView.dates = dates
    }
     
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        navigationView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(145)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(navigationView.snp.bottom)
        }
    }
    
    // MARK: - Getter | Setter
    
    /// 导航栏
    private lazy var navigationView: HomeNavigationView = {
        
        var navigationView = HomeNavigationView()
        navigationView.delegate = self
        return navigationView
    }()
    
    /// 列表
    private lazy var tableView: UITableView = {
        
        var tableView = UITableView()
        tableView.backgroundColor = YodoConfig.color.backgroundColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = headerView
        
        return tableView
    }()
    
    /// 列表顶部view
    private lazy var headerView: HomeHeaderView = {
        let headerView = HomeHeaderView(frame: CGRect(x: 0, y: 0, width: view.width-40, height: 120))
        return headerView
    }()
    
    /// viewModel
    private let viewM = AccountViewModel()
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

// MARK: - HomeNavigationViewDelegate
extension HomeViewController: HomeNavigationViewDelegate {
    
    /// 点击日期
    func navigationView(_ navigationView: HomeNavigationView, itemDidSelectedAt indexPath: IndexPath, _ date: YodoDate) {
        
        // 获取列表数据
        let accounts = viewM.getListData(withYodoDate: date)
        let total = viewM.calculatePrice(withAccounts: viewM.accounts)
        
        headerView.expendMoney = total.expend
        headerView.expendMonth = date.month
        headerView.incomeMoney = total.income
        headerView.incomeMonth = date.month
    }
    
    
}


