//
//  File.swift
//  Yod
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
        view.addSubview(createdBtn)
        
        navigationView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(navigationH)
        }
        
        createdBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.size.equalTo(CGSize(width: 45, height: 45))
            make.bottom.equalTo(self.view).offset(-20)
        }
        
        YodService.getDates {
            self.dates = $0
        }
    }
   
    // MARK: - Getter | Setter
    
    /// 导航栏高度
    private let navigationH: CGFloat = 145
    
    /// 中间滚动器
    private lazy var displayView: HomeDisplayView = {
        var displayView = HomeDisplayView(frame: CGRect(x: 0, y: navigationH, width: view.width, height: view.height-navigationH))
        return displayView
    }()
    
//    private lazy var displayView: DisplayView = {
//
//        var displayView = DisplayView(frame: CGRect(x: 0, y: navigationH, width: view.width, height: view.height-navigationH))
//        displayView.delegate = self
//
//        return displayView
//    }()
    
    /// 账单列表对应的日期
    /// 一.日期数组>=3的情况下
    /// 1.当前月份是最早的一个月(2017.4)  -> 2017.4, 2017.5, 2017,6 三个月的数据
    /// 2.当前月份是当前月份(2018.4) -> 2018.2, 2018.3, 2018.4 三个月的数据
    /// 二.日期数组小于3的情况下全部返回
    
    /// 所有日期数据
    private var dates: [YodDate] = [] {
        didSet {
            displayView.currentDate = dates.last!
            navigationView.dates = dates
        }
    }
    
    /// 导航栏
    private lazy var navigationView: HomeNavigationView = {
        
        var navigationView = HomeNavigationView()
        navigationView.delegate = self
        return navigationView
    }()
    
    private lazy var createdBtn: UIButton = {
        
        var createdBtn = UIButton()
        createdBtn.setImage(#imageLiteral(resourceName: "ic_home_created"), for: .normal)
        createdBtn.addTarget(self, action: #selector(createdBtnDidClick), for: .touchUpInside)
        createdBtn.layer.shadowRadius = 5
        createdBtn.layer.shadowOpacity = 0.3
        createdBtn.layer.shadowColor = UIColor.lightGray.cgColor
        createdBtn.layer.shadowOffset = CGSize(width: 5, height: 5)
        return createdBtn
    }()
}


// MARK: - HomeNavigationViewDelegate
extension HomeViewController: HomeNavigationViewDelegate {
    
    /// 点击日期
    func navigationView(_ navigationView: HomeNavigationView, itemDidSelectedAt indexPath: IndexPath, _ date: YodDate) {
       
        displayView.currentDate = date
    }
}


// MARK: - Event | Action
extension HomeViewController {
    
    @objc func createdBtnDidClick() {
        present(BillDetailViewController(), animated: true, completion: nil)
    }
}

/*
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
    
    func displayView(_ displayView: DisplayView, shouldResetFrame leftView: UIView, _ centerView: UIView, _ rightView: UIView, _ dir: DisplayView.ScrollDirection) -> Bool {
        
        let left = leftView as! AccountContentView
        let right = rightView as! AccountContentView
        
        guard let leftDate = left.date, let rightDate = right.date else {
            return false
        }
        
        // 获取第一个date和最后一个date
        let firstDate = dates.first!
        let lastDate = dates.last!
        
        if (firstDate <=> leftDate && dir == .left) || (lastDate <=> rightDate && dir == .right) {
            return false
        }
        
        return true
    }
    
    func displayView(_ displayView: DisplayView, didResetFrame leftView: UIView, _ centerView: UIView, _ rightView: UIView, _ dir: DisplayView.ScrollDirection) {
        
        let currView = centerView as! AccountContentView
        let currDate = currView.date
        
        guard currDate != nil else {
            return
        }
        
        if dir == DisplayView.ScrollDirection.left {
            
            let lastDate = currDate!.getYodDate(withIndex: -1)
            (leftView as! AccountContentView).tableView.setContentOffset(CGPoint.zero, animated: false)
            (leftView as! AccountContentView).date = lastDate
            // 更新date
        } else if dir == DisplayView.ScrollDirection.right {
            
            let nextDate = currDate!.getYodDate(withIndex: 1)
            (rightView as! AccountContentView).tableView.setContentOffset(CGPoint.zero, animated: false)
            (rightView as! AccountContentView).date = nextDate
        }
    }
}
*/

// MARK:- Getter | Setter
extension HomeViewController {
    
    
}


