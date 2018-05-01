//
//  HomeHeaderView.swift
//  Yod
//
//  Created by eamon on 2018/4/11.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

/// 列表头部汇总
class HomeHeaderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(contentView)
        contentView.addSubview(incomeView)
        contentView.addSubview(expendView)
        contentView.addSubview(sepLineView)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.snp.makeConstraints { (make) in
            make.left.top.equalTo(self).offset(20)
            make.size.equalTo(CGSize(width: self.width, height: self.height-40))
        }
        
        incomeView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(contentView)
            make.width.equalTo(self.width*0.5)
        }
        
        expendView.snp.makeConstraints { (make) in
            make.right.top.bottom.equalTo(contentView)
            make.width.equalTo(self.width*0.5)
        }
        
        sepLineView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 1, height: 20))
            make.center.equalTo(contentView)
        }
    }
    
    //MARK: - Getter | Setter
    
    var incomeMoney: String = "0.00" {
        didSet {
            incomeView.money = incomeMoney
        }
    }
    
    var incomeMonth: String = "" {
        didSet {
            incomeView.month = "\(incomeMonth)月收入"
        }
    }
    
    var expendMoney: String = "0.00" {
        didSet {
            expendView.money = expendMoney
        }
    }
    
    var expendMonth: String = "" {
        didSet {
            expendView.month = "\(expendMonth)月支出"
        }
    }
    
    /// 内容区域
    private lazy var contentView: UIView = {
        
        var contentView = UIView()
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 5
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.1
        layer.shadowColor = UIColor.lightGray.cgColor
        contentView.layer.shadowOffset = CGSize(width: 3, height: 3)
        
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
        sepLineView.backgroundColor = YodConfig.color.sepLine
        
        return sepLineView
    }()
}


private class HomeHeaderItemView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(iconView)
        addSubview(moneyLabel)
        addSubview(titleLabel)
        
        setupLayout()
    }
    
    private func setupLayout() {
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
    
    var money: String! {
        didSet {
            moneyLabel.animate(toValue: Double(money)!)
        }
    }
    
    var month: String! {
        didSet {
            titleLabel.text = month
        }
    }
    
    /// 收入图标
    private lazy var iconView: UIImageView = {
        
        var iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        
        return iconView
    }()
    
    /// 收入金额
    private lazy var moneyLabel: CountingLabel = {
        
        var moneyLabel = CountingLabel()
        moneyLabel.textColor = YodConfig.color.blackTitle
        moneyLabel.font = YodConfig.font.bold(size: 20)
        
        return moneyLabel
    }()
    
    /// 收入标题
    private lazy var titleLabel: UILabel = {
        
        var titleLabel = UILabel()
        titleLabel.textColor = YodConfig.color.darkGraySubTitle
        titleLabel.font = YodConfig.font.bold(size: 12)
        
        return titleLabel
    }()
}
