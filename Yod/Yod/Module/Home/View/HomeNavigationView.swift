//
//  HomeNavigationView.swift
//  Yod
//
//  Created by eamon on 2018/3/6.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit
import SnapKit

/// 首页导航栏


protocol HomeNavigationViewDelegate: class {
    /// 点击item回调
    func navigationView(_ navigationView: HomeNavigationView, itemDidSelectedAt indexPath: IndexPath, _ date: YodDate)
}


class HomeNavigationView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Getter | Setter
    weak var delegate: HomeNavigationViewDelegate?
    
    /// item高度
    private let itemHeight: CGFloat = 60
    
    /// 当前选中cell
    private var selectedIndex: IndexPath?
    
    /// 导航栏日期数据
    var dates: [YodDate] = [] {
        didSet {
            
            dateView.reloadData()
            
            guard oldValue.count == 0 else {
                return
            }
            
            // 滚到底部
            let contentSizeW = dateView.collectionViewLayout.collectionViewContentSize.width;
            if (contentSizeW > frame.width) {
                
                let offset = CGPoint(x: contentSizeW-frame.width, y: 0)
                dateView.setContentOffset(offset, animated: false)
            }
            
            // 默认选中当前月份
            delay(delay: 0.2, closure: {
                
                self.dateView.insertSubview(self.selectView, at: 0)
                // 默认选中最后一个cell
                let lastSelectedIndex = IndexPath(row: self.dates.count-1, section: 0)
                let cell = self.dateView.cellForItem(at: lastSelectedIndex) as! HomeDateItemCell
                self.selectedIndex = lastSelectedIndex
                self.showAnimation(currentCell: cell)
            })
        }
    }
    
    /// 菜单
    private lazy var menuBtn: UIButton = {
        
        var menuBtn = UIButton()
        menuBtn.setImage(#imageLiteral(resourceName: "ic_home_menu"), for: .normal)
        return menuBtn
    }()
    
    /// 分割线
    private lazy var sepLine: UIView = {
        
        var sepLine = UIView()
        sepLine.backgroundColor = YodConfig.color.sepLine
        return sepLine
    }()
    
    /// 标题
    private lazy var titleLabel: UILabel = {
       
        var titleLabel = UILabel()
        titleLabel.text = "日常记账"
        titleLabel.textColor = YodConfig.color.blackTitle
        titleLabel.font = YodConfig.font.homeTitle
        return titleLabel
    }()
    
    /// 图标
    private lazy var chartBtn: UIButton = {
        
        var chartBtn = UIButton()
        chartBtn.setImage(#imageLiteral(resourceName: "ic_home_chart"), for: .normal)
        return chartBtn
    }()
    
    /// 选中背景view
    private lazy var selectView: UIView = {
        
        var selectView = UIView()
        selectView.layer.cornerRadius = 10
        selectView.backgroundColor = YodConfig.color.theme
        return selectView
    }()
    
    enum DateViewType: Int {
        case normal = 100
        case hight = 101
    }
    
    /// 日期
    private lazy var dateView: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        var dateView: UICollectionView = UICollectionView(frame: CGRect(x: 0, y: frame.height-itemHeight-5.0, width: frame.width, height: itemHeight), collectionViewLayout: flowLayout)
        dateView.tag = DateViewType.normal.rawValue
        dateView.backgroundColor = .clear
        dateView.showsHorizontalScrollIndicator = false
        dateView.dataSource = self
        dateView.delegate = self
        dateView.registerClass(HomeDateItemCell.self)
        dateView.delaysContentTouches = false
        
        return dateView
    }()
    
    /// 底部分割线
    private lazy var borderLine: UIView = {
        
        let borderLine = UIView()
        borderLine.backgroundColor = YodConfig.color.background
        
        return borderLine
    }()
}

extension HomeNavigationView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        
        let cell = collectionView.cellForItem(at: indexPath) as? HomeDateItemCell
        guard cell != nil && indexPath != selectedIndex else {
            return
        }
        
        // 执行动画
        if let last = selectedIndex {
            dates[last.row].isSelected = false
        }
        dates[indexPath.row].isSelected = true
        selectedIndex = indexPath
        
        showAnimation(withLastIndex: selectedIndex, indexPath, currentCell: cell!)
        
        // 震动效果
        if #available(iOS 10, *) {
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        }
        
        // 回调给控制器
        if let delegate = delegate {
            delegate.navigationView(self, itemDidSelectedAt: indexPath, dates[indexPath.row])
        }
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
extension HomeNavigationView {
    
    
    /// 添加控件
    private func initView() {
        backgroundColor = .white
        
        addSubview(menuBtn)
        addSubview(sepLine)
        addSubview(titleLabel)
        addSubview(chartBtn)
        addSubview(dateView)
        addSubview(borderLine)
        
        setupLayout()
    }
    
    
    /// 约束
    private func setupLayout() {
        
        menuBtn.snp.makeConstraints{ (make) in
            make.left.equalTo(YodConfig.frame.nvIconMarginBorder)
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.top.equalTo(self).offset(YodConfig.frame.nvIconMarginTop)
        }
        
        sepLine.snp.makeConstraints { (make) in
            make.left.equalTo(menuBtn.snp.right).offset(YodConfig.frame.nvIconMarginLeft)
            make.size.equalTo(CGSize(width: 1, height: 15))
            make.centerY.equalTo(menuBtn)
        }
        
        chartBtn.snp.makeConstraints { (make) in
            make.size.centerY.equalTo(menuBtn)
            make.right.equalTo(self).offset(-YodConfig.frame.nvIconMarginBorder)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(sepLine.snp.right).offset(YodConfig.frame.nvIconMarginLeft)
            make.height.equalTo(30)
            make.centerY.equalTo(menuBtn)
            make.right.equalTo(chartBtn.snp.left).offset(-YodConfig.frame.nvIconMarginLeft)
        }
        
        dateView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.bottom.equalTo(self).offset(-5)
            make.height.equalTo(itemHeight)
        }
        
        borderLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(0.5)
        }
    } 
    
    /// 选择框执行缩放和渐变动画
    private func showAnimation(withLastIndex last: IndexPath? = nil, _ index: IndexPath? = nil, currentCell current: HomeDateItemCell) {
    
        selectView.frame = current.frame
        selectView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        UIView.animate(withDuration: 0.2, animations: {
            self.selectView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) { (final) in
            
        }
        
    }
}
