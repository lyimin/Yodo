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

    //MARK: - Getter | Setter
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
    
    private func setupLayout() {
        
        navigationView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(view)
            make.height.equalTo(80)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(navigationView.snp.bottom)
        }
    }
}
