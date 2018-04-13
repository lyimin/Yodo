//
//  HomeHeaderView.swift
//  Yodo
//
//  Created by eamon on 2018/4/11.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

class HomeHeaderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(contentView)
        contentView.addSubview(incomeView)
        contentView.addSubview(expendView)
        contentView.addSubview(sepLineView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.snp.makeConstraints { (make) in
            make.left.top.equalTo(self).offset(20)
            make.bottom.right.equalTo(self).offset(-20)
        }
        
        incomeView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(contentView)
            make.width.equalTo(contentView).multipliedBy(0.5)
        }
        
        expendView.snp.makeConstraints { (make) in
            make.right.top.bottom.equalTo(contentView)
            make.width.equalTo(contentView).multipliedBy(0.5)
        }
        
        sepLineView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 1, height: 20))
            make.center.equalTo(contentView)
        }
    }
    
    //MARK: - Getter | Setter
    
    /// 内容区域
    private lazy var contentView: UIView = {
        
        var contentView = UIView()
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 5
        
        return contentView
    }()
    
    /// 收入
    private lazy var incomeView: HomeHeaderItemView = {
        
        var incomeView = HomeHeaderItemView()
        incomeView.icon = UIImage(named: "ic_home_income")
        return incomeView
    }()
    
    /// 支出
    private lazy var expendView: HomeHeaderItemView = {
        
        var expendView = HomeHeaderItemView()
        expendView.icon = UIImage(named: "ic_home_expend")
        
        return expendView
    }()
    
    /// 分割线
    private lazy var sepLineView: UIView = {
        
        var sepLineView = UIView()
        sepLineView.backgroundColor = YodoConfig.color.sepLine
        
        return sepLineView
    }()
}


private class HomeHeaderItemView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(iconView)
        addSubview(moneyLabel)
        addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 30, height: 30))
            make.left.equalTo(self).offset(20)
            make.centerY.equalTo(self)
        }
        
        moneyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(20)
            make.height.equalTo(25)
            make.right.equalTo(self).offset(-10)
            make.centerY.equalTo(iconView).offset(-10)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(moneyLabel)
            make.height.equalTo(20)
            make.centerY.equalTo(iconView).offset(10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Getter | Setter
    var icon: UIImage! {
        didSet {
            iconView.image = icon
        }
    }
    
    /// 收入图标
    private lazy var iconView: UIImageView = {
        
        var iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        
        return iconView
    }()
    
    /// 收入金额
    private lazy var moneyLabel: UILabel = {
        
        var moneyLabel = UILabel()
        moneyLabel.text = "5403.35"
        moneyLabel.textColor = YodoConfig.color.blackTitle
        moneyLabel.font = YodoConfig.font.bold(size: 20)
        
        return moneyLabel
    }()
    
    /// 收入标题
    private lazy var titleLabel: UILabel = {
        
        var titleLabel = UILabel()
        titleLabel.text = "1月收入"
        titleLabel.textColor = YodoConfig.color.darkGraySubTitle
        titleLabel.font = YodoConfig.font.bold(size: 12)
        
        return titleLabel
    }()
}
