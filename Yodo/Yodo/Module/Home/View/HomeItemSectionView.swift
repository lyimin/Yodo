//
//  HomeItemSectionView.swift
//  Yodo
//
//  Created by eamon on 2018/4/18.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

class HomeItemSectionView: UIView {

    //MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(weekLabel)
        addSubview(dateLabel)
        addSubview(priceLabel)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.top.equalTo(self).offset(10)
            make.height.equalTo(20)
            make.width.greaterThanOrEqualTo(200)
        }
        
        weekLabel.snp.makeConstraints { (make) in
            make.left.height.equalTo(dateLabel)
            make.bottom.equalTo(self).offset(-10)
            make.width.greaterThanOrEqualTo(200)
        }
        
        priceLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-30)
            make.left.equalTo(dateLabel.snp.right).offset(10)
        }
    }
    
    
    
    
    //MARK: - Getter | Setter
    
    /// 星期
    private lazy var weekLabel: UILabel = {
        
        var weekLabel = UILabel()
        weekLabel.textColor = YodoConfig.color.blackTitle
        weekLabel.font = YodoConfig.font.bold(size: 18)
        
        return weekLabel
    }()
    
    /// 日期
    private lazy var dateLabel: UILabel = {
        
        var dateLabel = UILabel()
        dateLabel.textColor = YodoConfig.color.darkGraySubTitle
        dateLabel.font = YodoConfig.font.bold(size: 10)
        
        return dateLabel
    }()
    
    /// 当天收支汇总
    private lazy var priceLabel: UILabel = {
        
        var priceLabel = UILabel()
        priceLabel.font = YodoConfig.font.bold(size: 10)
        priceLabel.textAlignment = .right
        priceLabel.textColor = YodoConfig.color.darkGraySubTitle
        
        return priceLabel
    }()
}
