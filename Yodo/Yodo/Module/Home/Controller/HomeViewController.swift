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
        view.addSubview(displayView)
        
        navigationView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(navigationH)
        }
        
        AccountHelper.default.getDates { (dates) in
            self.dates = dates
        }
    }
   
    // MARK: - Getter | Setter
    
    
    /// 导航栏高度
    private let navigationH: CGFloat = 145
    
    /// 中间滚动器
    private lazy var displayView: DisplayView = {
        
        var displayView = DisplayView(frame: CGRect(x: 0, y: navigationH, width: view.width, height: view.height-navigationH))
        displayView.delegate = self
        
        return displayView
    }()
    
    /// 账单列表对应的日期
    /// 一.日期数组>=3的情况下
    /// 1.当前月份是最早的一个月(2017.4)  -> 2017.4, 2017.5, 2017,6 三个月的数据
    /// 2.当前月份是当前月份(2018.4) -> 2018.2, 2018.3, 2018.4 三个月的数据
    /// 二.日期数组小于3的情况下全部返回
    private var displayDates: [YodoDate] = []
    
    /// 所有日期数据
    private var dates: [YodoDate] = [] {
        didSet {
            if dates.count >= 3 {
                let right = dates.last!
                displayDates.append(right.getYodoDate(withIndex: -2))
                displayDates.append(right.getYodoDate(withIndex: -1))
                displayDates.append(right)
            } else {
                displayDates = dates
            }
            
            navigationView.dates = dates
            displayView.reloadData()
        }
    }
    
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
extension HomeViewController: DisplayViewDelegate {
    
    func numberOfContentView(_ displayView: DisplayView) -> Int {
        return displayDates.count
    }
    
    func displayView(_ displayView: DisplayView, contentViewForRowAt index: Int) -> UIView {
        
        let contentView = AccountContentView(frame: displayView.bounds)
        contentView.date = displayDates[index]
        return contentView
    }
    
    func displayViewScrollToBottom(_ displayView: DisplayView) -> Bool {

        if displayDates.count > 0 {
            return displayDates.last!.isThisMonth
        }
        
        return false
    }
    
    func displayViewScrollToTop(_ displayView: DisplayView) -> Bool {
        
        if displayDates.count > 0 {
            return displayDates.first!.isFirstMonth
        }
        
        return false
    }
    
    // TODO
    func displayView(_ displayView: DisplayView, shouldReloadDataAt leftView: UIView, _ centerView: UIView, _ rightView: UIView) {
        
    }
}

// MARK: - Getter | Setter
extension HomeViewController {
    
   
}


