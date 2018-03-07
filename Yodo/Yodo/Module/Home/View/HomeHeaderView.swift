//
//  HomeHeaderView.swift
//  Yodo
//
//  Created by 梁亦明 on 2018/3/6.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit
import SnapKit


class HomeHeaderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    
    //MARK: - Getter | Setter
    // 菜单
    private lazy var menuBtn: UIButton = {
        
        var menuBtn = UIButton()
        menuBtn.setImage(UIImage(named: "home_menu"), for: .normal)
        return menuBtn
    }()
    
    // 分割线
    private lazy var sepLine: UIView = {
        
        var sepLine = UIView()
        return sepLine
    }()
    
    // 标题
    private lazy var titleLabel: UILabel = {
       
        var titleLabel = UILabel()
        titleLabel.text = "日常记账"
        return titleLabel
    }()
    
    // 图标
    private lazy var chartBtn: UIButton = {
        
        var chartBtn = UIButton()
        chartBtn.setImage(UIImage(named: "home_chart"), for: .normal)
        return chartBtn
    }()
    
    
    private lazy var collectionView: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        var collectionView:UICollectionView = UICollectionView(frame: CGRect(x: 0, y: 10, width: frame.width, height: 50), collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
 
}

extension HomeHeaderView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

//MARK: - PrivateMethods
extension HomeHeaderView {
    
    
    /// 添加控件
    private func initView() {
        
        addSubview(menuBtn)
        addSubview(sepLine)
        addSubview(titleLabel)
        addSubview(chartBtn)
    }
    
    
    /// 约束
    private func setupLayout() {
        
        menuBtn.snp.makeConstraints{ (make) in
            make.left.equalTo(YodoConfig.frame.nvIconMarginBorder)
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.top.equalTo(self).offset(YodoConfig.frame.nvIconMarginTop)
        }
        
        sepLine.snp.makeConstraints { (make) in
            make.left.equalTo(menuBtn).offset(YodoConfig.frame.nvIconMarginLeft)
            make.size.equalTo(CGSize(width: 1, height: 15))
            make.centerY.equalTo(menuBtn)
        }
        
        chartBtn.snp.makeConstraints { (make) in
            make.size.centerY.equalTo(menuBtn)
            make.right.equalTo(self).offset(-YodoConfig.frame.nvIconMarginBorder)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(sepLine).offset(YodoConfig.frame.nvIconMarginLeft)
            make.height.equalTo(30)
            make.centerY.equalTo(menuBtn)
            make.right.equalTo(chartBtn.snp.left).offset(-YodoConfig.frame.nvIconMarginLeft)
        }
    }
}