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
        
        // 初始化view
        initView()
        
        YodService.getDates {
            self.dates = $0
            self.displayView.currentDate = $0.last!
            self.navigationView.selectedIndex = self.dates.count - 1
            self.navigationView.setContentOffSet(animate: false)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = coordinator
    }
   
    // MARK: - Getter | Setter
    
    /// 转场动画
    private let coordinator = TransitionCoordinator()
    
    /// 导航栏高度
    private let navigationH: CGFloat = 145 + YodConfig.frame.safeTopHeight
    
    /// 中间滚动器
    private lazy var displayView: HomeDisplayView = {
        var displayView = HomeDisplayView(frame: CGRect(x: 0, y: navigationH, width: view.width, height: view.height-navigationH))
        displayView.leftView.delegate = self
        displayView.rightView.delegate = self
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
            if dates.count == 0 { return }
            navigationView.dates = dates
        }
    }
    
    /// 导航栏
    internal lazy var navigationView: HomeNavigationView = {
        
        var navigationView = HomeNavigationView()
        navigationView.delegate = self
        return navigationView
    }()
    
    /// 添加记账按钮
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
    func navigationView(_ navigationView: HomeNavigationView, itemDidSelectedAt index: Int, _ date: YodDate) {
        displayView.currentDate = date
    }
    
    /// 点击菜单
    func navigationView(_ navigationView: HomeNavigationView, menuBtnDidClick: UIButton) {
    }
    
    /// 点击统计
    func navigationView(_ navigationView: HomeNavigationView, chartBtn: UIButton) {
        let chartController = StatisticsViewController()
        present(chartController, animated: true, completion: nil)
    }
}

// MARK: - AccountContentViewDelegate
extension HomeViewController: AccountContentViewDelegate {
    
    /// 监听ScrollView滚动方向，联动Navigation
    func accountContentView(_ contentView: AccountContentView, scrollDirection: AccountContentView.ScrollDirection) {
        
        /* TODO: 由于iPhoneX导航栏问题，目前先取消这个xu'q
        var transform: CGAffineTransform
        if scrollDirection == .down {
            
            transform = .identity
        } else {
            transform = CGAffineTransform(translationX: 0, y: -55)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.navigationView.transform = transform
        }
        */
    }
    
    /// 点击删除账单
    func accountContentView(_ contentView: AccountContentView, itemDeleted withIndexPath: IndexPath, callBack: @escaping (Bool) -> Void) {
        
        guard let account = contentView.monthModel?.dailyModels[withIndexPath.section].accounts[withIndexPath.row] else {
            return
        }
        
        showSheet(msg: "您要删除此账单吗?", otherBtn: "删除") { (_) in
            
            self.deleteAction(account: account, callBack: callBack)
        }
    }
    
    /// 点击item
    func accountContentView(_ contentView: AccountContentView, itemDidClick withIndexPath: IndexPath) {
        
        let HomeDetail = HomeDetailViewController(controllerType: .edit)
        
        HomeDetail.delegate = self
        navigationController?.pushViewController(HomeDetail, animated: true)
        if let model = contentView.monthModel?.dailyModels[withIndexPath.section].accounts[withIndexPath.row] {
            HomeDetail.account = model
        }
    }
}

// MARK: - HomeDetailViewControllerDelegate
extension HomeViewController: HomeDetailViewControllerDelegate {
    
    func accountDidChange(type: HomeDetailControllerType, account: Account) {
        
        YodService.getDates {
            self.dates = $0
            self.displayView.currentDate = account.date
            
            for i in 0..<$0.count {
                if $0[i] <=> account.date {
                    self.navigationView.selectedIndex = i
                    self.navigationView.setContentOffSet(animate: true)
                    break
                }
            }
        }
    }
}

// MARK: - Transition
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

    // 点击删除item操作
    private func deleteAction(account: Account, callBack: @escaping (Bool) -> Void) {
        
        YodService.deleteAccount(account) {
            self.noticeSuccess("删除成功👌👌")
            shake(action: .success)
            
            delay(delay: 1, closure: {
                callBack(true)
            })
        }
    }
    
    // 点击添加记账
    @objc private func createdBtnDidClick() {
        
        let ctrl = HomeDetailViewController(controllerType: .created)
        ctrl.delegate = self
        navigationController?.pushViewController(ctrl, animated: true)
    }
}

extension HomeViewController {
    
    // 初始化view
    private func initView() {
        
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
            make.bottom.equalTo(self.view).offset(-(30+YodConfig.frame.safeBottomHeight))
        }
    }
}
