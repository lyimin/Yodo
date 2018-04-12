//
//  HomeDateItemCell.swift
//  Yodo
//
//  Created by 梁亦明 on 2018/3/8.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

class HomeDateItemCell: UICollectionViewCell, Reusable {
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 10
       
        addSubview(yearLabel)
        addSubview(monthLabel)
    }
    
    override func layoutSubviews() {
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Getter | Setter
    var date: YodoDate! {
        didSet {
            self.yearLabel.text = date.year
            self.monthLabel.text = date.month
            
            if date.isThisMonth {
                backgroundColor = UIColor(red: 0, green: 118.0/255, blue: 1, alpha: 1)
                yearLabel.textColor = .white
                monthLabel.textColor = .white
            } else {
                backgroundColor = UIColor.clear
                yearLabel.textColor = YodoConfig.color.darkGraySubTitle
                monthLabel.textColor = YodoConfig.color.blackTitle
            }
        }
    }
    
    private lazy var yearLabel: UILabel = {
       
        var yearLabel = UILabel()
        yearLabel.textAlignment = .center
        yearLabel.textColor = YodoConfig.color.darkGraySubTitle
        yearLabel.font = YodoConfig.font.bold(size: 13)
        
        return yearLabel
    }()
    
    private lazy var monthLabel: UILabel = {
      
        var monthLabel = UILabel()
        monthLabel.textAlignment = .center
        monthLabel.textColor = YodoConfig.color.blackTitle
        monthLabel.font = YodoConfig.font.bold(size: 28)
        
        return monthLabel
    }()
}

// MARK: Private Methods
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
