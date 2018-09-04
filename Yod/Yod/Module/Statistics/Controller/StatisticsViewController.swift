//
//  StatisticsViewController.swift
//  Yod
//
//  Created by eamon on 2018/7/22.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

class StatisticsViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    convenience init(dates: [YodDate]) {
        self.init()
        
        self.dates = dates
        initDataSource()
        
        YodService.getStatisticsData(month: currDate) {
            self.currModel = $0
            self.contentView.model = $0
        }
    }

    // MARK: - Getter | Setter
    
    /// 月份
    private var dates: [YodDate]?
    private var months: [StatisticsDateModel]! = []
    
    /// 当前选中的月份
    private var currDate: StatisticsDateModel!
    
    /// 当前选中月份的统计数据
    private var currModel: StatisticsModel!
    
    /// 导航栏
    private lazy var navigationView: YodNavigationView = {
        
        var navigationView = YodNavigationView()
        // 点击返回按钮
        navigationView.backBtnDidClickCallBack = { [weak self] in
            if let strongSelf = self {
                strongSelf.dismiss(animated: true, completion: nil)
            }
        }
        return navigationView
    }()
    
    /// 内容
    private lazy var contentView: StatisticsContentView = {
        
        var contentView = StatisticsContentView()
        return contentView
    }()
}

// MARK: - StatisticsNavigationViewDelegate
extension StatisticsViewController {
    
    /// 点击返回按钮
    func backBtnDidClick() {
        
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension StatisticsViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return DoflipTransitionAnimation(dir: .right)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return DoflipTransitionAnimation(dir: .left)
    }
}

// MARK: - Private Methods
extension StatisticsViewController {
    
    private func initView() {
        
        transitioningDelegate = self
        view.addSubview(navigationView)
        view.addSubview(contentView)
            
        setupLayout()
    }
    
    private func initDataSource() {
        
        if dates == nil {
            YodService.getDates {
                self.dates = $0
                self.initMonths()
            }
        } else {
            initMonths()
        }
    }
    
    private func initMonths() {
        
        months.removeAll()
        
        months = dates?.map {
            let dateModel = StatisticsDateModel(date: $0)
            if $0.isThisMonth {
                dateModel.isSelect = $0.isThisMonth
//                currDate = dateModel
                currDate = StatisticsDateModel(date: YodDate(year: "2018", month: "01"))
            }
            return dateModel
        }
        months.append(StatisticsDateModel(text: "全部"))
        
        contentView.dateModels = months
    }
    
    private func setupLayout() {
        
        navigationView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(view)
            make.height.equalTo(70+YodConfig.frame.safeTopHeight)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(navigationView.snp.bottom)
        }
    }
}
