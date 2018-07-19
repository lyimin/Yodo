//
//  HomeItemCell.swift
//  Yod
//
//  Created by eamon on 2018/4/11.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit
import SwipeCellKit

/// 列表条目
class HomeItemCell: SwipeTableViewCell, Reusable {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(content)
        content.addSubview(iconBackground)
        content.addSubview(iconView)
        content.addSubview(categoryLabel)
        content.addSubview(descLabel)
        content.addSubview(priceLabel)
        
        setupLayout()
    }
    
    public class func cell(withTableView tableView: UITableView, indexPath: IndexPath) -> HomeItemCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeItemCell.reuseIdentifier, for: indexPath) as! HomeItemCell
        return cell
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        content.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-20)
            make.top.bottom.equalTo(contentView)
        }
        
        iconBackground.snp.makeConstraints { (make) in
            make.left.equalTo(content).offset(10)
            make.centerY.equalTo(content)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        categoryLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconBackground.snp.right).offset(15)
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
    
    private func resetLayout(remarkIsEmpty: Bool) {
        
        descLabel.isHidden = remarkIsEmpty
        if remarkIsEmpty {
            categoryLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(iconBackground.snp.right).offset(15)
                make.centerY.equalTo(iconBackground)
                make.height.equalTo(20)
                make.width.lessThanOrEqualTo(150)
            }
        } else {
            categoryLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(iconBackground.snp.right).offset(15)
                make.centerY.equalTo(iconView).offset(-10)
                make.height.equalTo(20)
                make.width.lessThanOrEqualTo(150)
            }
            
            descLabel.snp.remakeConstraints { (make) in
                make.left.width.height.equalTo(categoryLabel)
                make.centerY.equalTo(iconBackground).offset(10)
            }
        }
        
        iconView.snp.remakeConstraints { (make) in
            make.size.equalTo(iconView.image!.size)
            make.center.equalTo(iconBackground)
        }
    }
    
    //MARK: - Getter | Setter
    
    var account: Account! {
        didSet {
            
            iconView.image = UIImage(named: account.category.icon)
            iconBackground.backgroundColor = UIColor(hexString: account.category.color)
            priceLabel.text = String(format: "￥%.2f", account.money)
            categoryLabel.text = account.category.name
            
            if account.type == .expend {
                priceLabel.textColor = YodConfig.color.expend
            } else if account.type == .income {
                priceLabel.textColor = YodConfig.color.income
            }
            
            descLabel.text = account.remarks
            
            resetLayout(remarkIsEmpty: account.remarks == "")
        }
    }
    
    /// 内容区域
    var content: UIView = {
       
        let content = UIView()
        
        return content
    }()
    
    private lazy var iconBackground: UIView = {
        let iconBackground = UIView()
        iconBackground.layer.cornerRadius = 20
        return iconBackground
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
        categoryLabel.textColor = YodConfig.color.blackTitle
        categoryLabel.font = YodConfig.font.bold(size: 16)
        
        return categoryLabel
    }()
    
    /// 描述
    private lazy var descLabel: UILabel = {
        
        let descLabel = UILabel()
        descLabel.textColor = YodConfig.color.darkGraySubTitle
        descLabel.font = YodConfig.font.bold(size: 11)
    
        return descLabel
    }()
    
    /// 价格
    private lazy var priceLabel: UILabel = {
        
        let priceLabel = UILabel()
        priceLabel.font = YodConfig.font.bold(size: 16)
        priceLabel.textAlignment = .right
        
        return priceLabel
    }()
}
