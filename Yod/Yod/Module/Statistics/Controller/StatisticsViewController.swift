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
        
        transitioningDelegate = self
        view.addSubview(navigationView)
        setupLayout()
    }

    //MARK: - Getter | Setter
    private lazy var navigationView: StatisticsNavigationView = {
        
        var navigationView = StatisticsNavigationView()
        navigationView.delegate = self
        return navigationView
    }()
}

// MARK: - StatisticsNavigationViewDelegate
extension StatisticsViewController: StatisticsNavigationViewDelegate {
    
    /// 点击返回按钮
    func backBtnDidClick() {
        
        dismiss(animated: true, completion: nil)
    }
}

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
    
    private func setupLayout() {
        
        navigationView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(view)
            make.height.equalTo(180)
        }
    }
}
