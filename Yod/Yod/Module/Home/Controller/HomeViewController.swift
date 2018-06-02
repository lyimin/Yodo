//
//  File.swift
//  Yod
//
//  Created by eamon on 2018/3/2.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController, UINavigationControllerDelegate {
    
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
            make.bottom.equalTo(self.view).offset(-30)
        }
        
        YodService.getDates {
            self.dates = $0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
   
    // MARK: - Getter | Setter
    /// 导航栏高度
    private let navigationH: CGFloat = 145
    
    /// 中间滚动器
    private lazy var displayView: HomeDisplayView = {
        var displayView = HomeDisplayView(frame: CGRect(x: 0, y: navigationH, width: view.width, height: view.height-navigationH))
        return displayView
    }()
    
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

extension HomeViewController: CircleTransitionable {
    
    var triggerButton: UIButton {
        return createdBtn
    }
    
    var mainView: UIView {
        return view
    }
}


// MARK: - Event | Action
extension HomeViewController {
    
    @objc func createdBtnDidClick() {
        navigationController?.pushViewController(BillDetailViewController(), animated: true)
    }
}



// MARK:- Getter | Setter
extension HomeViewController {
    
    
}


