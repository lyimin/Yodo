//
//  StatisticsContentView.swift
//  Yod
//
//  Created by eamon on 2018/8/26.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

class StatisticsContentView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Getter | Setter
    
    private var selectedIndex: Int = 0
    
    /// 日期数据
    var dateModels: [StatisticsDateModel]! {
        didSet {
            
            if dateModels.count < 2 {return}
            selectedIndex = dateModels.count-2
            
            menuView.reloadData()
            
            let item = collectionView(menuView, numberOfItemsInSection: 0) - 1
            let lastItemIndex = IndexPath(item: item, section: 0)
            
            menuView.scrollToItem(at: lastItemIndex, at: .left, animated: true)
            menuView.layoutIfNeeded()
        }
    }
    
    /// 大标题
    private lazy var largeTitleLabel: UILabel = {
        
        var largeTitleLabel = UILabel()
        largeTitleLabel.text = "统计"
        largeTitleLabel.textColor = YodConfig.color.blackTitle
        largeTitleLabel.font = YodConfig.font.bold(size: 25)
        return largeTitleLabel
    }()
  
    /// 月份列表
    private lazy var menuView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 35)
        layout.scrollDirection = .horizontal
        
        let rect = CGRect(x: 0, y: largeTitleLabel.frame.maxY+20, width: width, height: 35)
        var menuView = UICollectionView(frame: rect, collectionViewLayout: layout)
        menuView.showsHorizontalScrollIndicator = false
        menuView.backgroundColor = .white
        menuView.delegate = self
        menuView.dataSource = self
        menuView.registerClass(StatisticsMenuItem.self)
        return menuView
    }()
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension StatisticsContentView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dateModels.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = collectionView.dequeueReusableCell(indexPath: indexPath) as StatisticsMenuItem
        item.model = dateModels[indexPath.row]
        
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // 更改数据源
        dateModels[selectedIndex].isSelect = false
        dateModels[indexPath.row].isSelect = true
        selectedIndex = indexPath.row
        
        collectionView.reloadData()
        
        // 滚动到对应位置
        let selectItem = IndexPath(item: indexPath.row, section: 0)
        menuView.scrollToItem(at: selectItem, at: .centeredHorizontally, animated: true)
    }
}

// MARK: - PrivateMethods
extension StatisticsContentView {
    
    private func initView() {
        
        backgroundColor = .white
        
        addSubview(largeTitleLabel)
        addSubview(menuView)
        setupLayout()
    }
    
    private func setupLayout() {
        
        largeTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(25)
            make.size.equalTo(CGSize(width: 100, height: 40))
            make.top.equalTo(self)
        }
        
        menuView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.height.equalTo(35)
            make.top.equalTo(largeTitleLabel.snp.bottom).offset(20)
        }
    }
}
