//
//  HomeDateItemCell.swift
//  Yod
//
//  Created by eamon on 2018/3/8.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit
import SnapKit


/// 导航栏日期列表的item
class HomeDateItemCell: UICollectionViewCell, Reusable {
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(yearLabel)
        addSubview(monthLabel)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Getter | Setter
    
    /// 数据
    var date: YodDate! {
        didSet {
            self.yearLabel.text = date.year
            self.monthLabel.text = date.month
            
            if date.isSelected {
                yearLabel.textColor = .white
                monthLabel.textColor = .white
            } else {
                yearLabel.textColor = YodConfig.color.darkGraySubTitle
                monthLabel.textColor = YodConfig.color.blackTitle
            }
        }
    }
    
    /// 年份
    private lazy var yearLabel: UILabel = {
       
        var yearLabel = UILabel()
        yearLabel.textAlignment = .center
        yearLabel.textColor = YodConfig.color.darkGraySubTitle
        yearLabel.font = YodConfig.font.bold(size: 13)
        
        return yearLabel
    }()
    
    /// 月份
    private lazy var monthLabel: UILabel = {
      
        var monthLabel = UILabel()
        monthLabel.textAlignment = .center
        monthLabel.textColor = YodConfig.color.blackTitle
        monthLabel.font = YodConfig.font.bold(size: 28)
        
        return monthLabel
    }()
}

// MARK: - Private Methods
extension HomeDateItemCell {
    
    /// 约束
    private func setupLayout() {
        
        yearLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self).offset(5)
            make.height.equalTo(20)
        }
    
        monthLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.height.equalTo(30)
            make.top.equalTo(yearLabel.snp.bottom)
        }
    }
}
