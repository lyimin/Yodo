//
//  StatisticsContentView.swift
//  Yod
//
//  Created by eamon on 2018/8/26.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import Foundation

class StatisticsContentView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var largeLabel: UILabel = {
        
        var largeLabel = UILabel()
        largeLabel.text = "统计"
        largeLabel.textColor = YodConfig.color.blackTitle
        largeLabel.font = YodConfig.font.bold(size: 25)
        return largeLabel
    }()
    
    //MARK: - Getter | Setter
    private lazy var menuView: WMMenuView = {
        
        var menuView = WMMenuView()
        menuView.dataSource = self
        menuView.delegate = self
        return menuView
    }()
}

// MARK: - WMMenuViewDataSource, WMMenuViewDelegate
extension StatisticsContentView: WMMenuViewDataSource, WMMenuViewDelegate {
    
    func numbersOfTitles(in menu: WMMenuView!) -> Int {
        return 10
    }
    
    func menuView(_ menu: WMMenuView!, titleAt index: Int) -> String! {
        return "你好"
    }
}

extension StatisticsContentView {
    
    private func initView() {
        
        addSubview(largeLabel)
        addSubview(menuView)
        menuView.reload()
        setupLayout()
    }
    
    private func setupLayout() {
        
        largeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(25)
            make.size.equalTo(CGSize(width: 100, height: 40))
            make.top.equalTo(self).offset(15)
        }
 
        menuView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(largeLabel.snp.bottom).offset(20)
            make.height.equalTo(35)
        }
    }
}
