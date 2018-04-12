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
        
        setupLayout()
    }
    
    //MARK: - Getter | Setter
    
    private let itemHeight: CGFloat = 60
    
    var dates: [YodoDate] = []{
        didSet {
            dateCollectionView.reloadData()
            
            DispatchQueue.main.async {
                // 滚到底部
                if (self.dateCollectionView.contentSize.width > self.frame.width) {
                    let offset = CGPoint(x: self.dateCollectionView.contentSize.width-self.frame.width, y: 0)
                    self.dateCollectionView.setContentOffset(offset, animated: false)
                }
            }
            
        }
    }
    
    // 菜单
    private lazy var menuBtn: UIButton = {
        
        var menuBtn = UIButton()
        menuBtn.setImage(UIImage(named: "home_menu"), for: .normal)
        return menuBtn
    }()
    
    // 分割线
    private lazy var sepLine: UIView = {
        
        var sepLine = UIView()
        sepLine.backgroundColor = YodoConfig.color.sepLine
        return sepLine
    }()
    
    // 标题
    private lazy var titleLabel: UILabel = {
       
        var titleLabel = UILabel()
        titleLabel.text = "日常记账"
        titleLabel.textColor = YodoConfig.color.blackTitle
        titleLabel.font = YodoConfig.font.homeTitle
        return titleLabel
    }()
    
    // 图标
    private lazy var chartBtn: UIButton = {
        
        var chartBtn = UIButton()
        chartBtn.setImage(UIImage(named: "home_chart"), for: .normal)
        return chartBtn
    }()
    
    
    // 日期
    private lazy var dateCollectionView: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        var dateCollectionView: UICollectionView = UICollectionView(frame: CGRect(x: 0, y: frame.height-itemHeight-5.0, width: frame.width, height: itemHeight), collectionViewLayout: flowLayout)
        dateCollectionView.backgroundColor = .clear
        dateCollectionView.showsHorizontalScrollIndicator = false
        dateCollectionView.dataSource = self
        dateCollectionView.delegate = self
        dateCollectionView.registerClass(HomeDateItemCell.self)
        
        return dateCollectionView
    }()
}

extension HomeHeaderView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! HomeDateItemCell
        cell.date = dates[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(indexPath: indexPath) as HomeDateItemCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // YODO：
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 35, 0, 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

//MARK: - PrivateMethods
extension HomeHeaderView {
    
    
    /// 添加控件
    private func initView() {
        backgroundColor = .white
        
        addSubview(menuBtn)
        addSubview(sepLine)
        addSubview(titleLabel)
        addSubview(chartBtn)
        addSubview(dateCollectionView)
    }
    
    
    /// 约束
    private func setupLayout() {
        
        menuBtn.snp.makeConstraints{ (make) in
            make.left.equalTo(YodoConfig.frame.nvIconMarginBorder)
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.top.equalTo(self).offset(YodoConfig.frame.nvIconMarginTop)
        }
        
        sepLine.snp.makeConstraints { (make) in
            make.left.equalTo(menuBtn.snp.right).offset(YodoConfig.frame.nvIconMarginLeft)
            make.size.equalTo(CGSize(width: 1, height: 15))
            make.centerY.equalTo(menuBtn)
        }
        
        chartBtn.snp.makeConstraints { (make) in
            make.size.centerY.equalTo(menuBtn)
            make.right.equalTo(self).offset(-YodoConfig.frame.nvIconMarginBorder)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(sepLine.snp.right).offset(YodoConfig.frame.nvIconMarginLeft)
            make.height.equalTo(30)
            make.centerY.equalTo(menuBtn)
            make.right.equalTo(chartBtn.snp.left).offset(-YodoConfig.frame.nvIconMarginLeft)
        }
        
        dateCollectionView.frame = CGRect(x: 0, y: frame.height-itemHeight-5.0, width: frame.width, height: itemHeight)
    }
}
