//
//  HomeItemCell.swift
//  Yodo
//
//  Created by eamon on 2018/4/11.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

class HomeItemCell: UITableViewCell, Reusable {
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        contentView.addSubview(content)
        content.addSubview(iconView)
        content.addSubview(categoryLabel)
        content.addSubview(descLabel)
        content.addSubview(priceLabel)
    }
    
    public class func cell(withTableView tableView: UITableView) -> HomeItemCell {
        var cell = tableView.dequeueReusableCell() as HomeItemCell?
        if cell == nil {
            cell = HomeItemCell(style: .default, reuseIdentifier: HomeItemCell.reuseIdentifier)
        }
        return cell!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        content.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-20)
            make.top.bottom.equalTo(contentView)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(content).offset(10)
            make.centerY.equalTo(content)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        categoryLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(15)
            make.centerY.equalTo(iconView)
            make.height.equalTo(20)
            make.width.lessThanOrEqualTo(150)
        }
        
        priceLabel.snp.makeConstraints { (make) in
            make.right.equalTo(content).offset(-10)
            make.centerY.equalTo(content)
            make.height.equalTo(20)
            make.left.equalTo(categoryLabel.snp.right).offset(10)
        }
    }
    
    //MARK: - Getter | Setter
    
    var account: Account! {
        didSet {
            iconView.image = UIImage(named: "ic_category_traffic")
            priceLabel.text = "\(account.money)"
            categoryLabel.text = account.category
        }
    }
    
    /// 内容区域
    private lazy var content: UIView = {
       
        let content = UIView()
        content.backgroundColor = .white
        
        return content
    }()
    
    
    /// 图标
    private lazy var iconView: UIImageView = {
        
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        
        return iconView
    }()
    
    /// 分类
    private lazy var categoryLabel: UILabel = {
        
        let categoryLabel = UILabel()
        categoryLabel.textColor = YodoConfig.color.blackTitle
        categoryLabel.font = YodoConfig.font.bold(size: 16)
        
        return categoryLabel
    }()
    
    /// 描述
    private lazy var descLabel: UILabel = {
        
        let descLabel = UILabel()
        descLabel.textColor = YodoConfig.color.darkGraySubTitle
        descLabel.font = YodoConfig.font.bold(size: 11)
    
        return descLabel
    }()
    
    /// 价格
    private lazy var priceLabel: UILabel = {
        
        let priceLabel = UILabel()
        priceLabel.font = YodoConfig.font.bold(size: 16)
        priceLabel.textAlignment = .right
        
        return priceLabel
    }()
}
