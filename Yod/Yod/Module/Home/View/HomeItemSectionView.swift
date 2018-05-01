//
//  HomeItemSectionView.swift
//  Yod
//
//  Created by eamon on 2018/4/18.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

/// 首页每日账单的头部
class HomeItemSectionView: UITableViewHeaderFooterView, Reusable {
    
    
    //MARK: - Life Cycle
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = YodConfig.color.background
        
        contentView.addSubview(weekLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(priceLabel)
        
        setupLayout()
    }

    
 
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(20)
            make.top.equalTo(self.contentView).offset(0)
            make.height.equalTo(20)
            make.width.greaterThanOrEqualTo(200)
        }
        
        weekLabel.snp.makeConstraints { (make) in
            make.left.equalTo(dateLabel)
            make.bottom.equalTo(self.contentView).offset(-15)
            make.width.greaterThanOrEqualTo(200)
            make.height.equalTo(25)
        }
        
        priceLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.right.equalTo(self.contentView).offset(-30)
            make.left.equalTo(dateLabel.snp.right).offset(10)
        }
    }
    
    
    
    //MARK: - Getter | Setter
    static var sectionViewHeight: CGFloat = 60
    
    var dailyModel: HomeDailyModel! {
        didSet {
            if dailyModel.isToday {
                weekLabel.text = "Today"
                dateLabel.text = "\(dailyModel.date.month)月\(dailyModel.date.day)日 \(dailyModel.week)"
            } else {
                weekLabel.text = dailyModel.week
                dateLabel.text = "\(dailyModel.date.month)月\(dailyModel.date.day)日"
                
            }
        }
    }
    
    /// 星期
    private lazy var weekLabel: UILabel = {
        
        var weekLabel = UILabel()
        weekLabel.textColor = YodConfig.color.blackTitle
        weekLabel.font = YodConfig.font.bold(size: 18)
        
        return weekLabel
    }()
    
    /// 日期
    private lazy var dateLabel: UILabel = {
        
        var dateLabel = UILabel()
        dateLabel.textColor = YodConfig.color.darkGraySubTitle
        dateLabel.font = YodConfig.font.bold(size: 10)
        
        return dateLabel
    }()
    
    /// 当天收支汇总
    private lazy var priceLabel: UILabel = {
        
        var priceLabel = UILabel()
        priceLabel.font = YodConfig.font.bold(size: 10)
        priceLabel.textAlignment = .right
        priceLabel.textColor = YodConfig.color.darkGraySubTitle
        
        return priceLabel
    }()
}
