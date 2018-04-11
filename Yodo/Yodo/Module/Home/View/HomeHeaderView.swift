//
//  HomeHeaderView.swift
//  Yodo
//
//  Created by 梁亦明 on 2018/4/11.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

class HomeHeaderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Getter | Setter
     
    /// 内容区域
    private lazy var contentView: UIView = {
        
        var contentView = UIView()
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 5
        
        return contentView
    }()
    
    /// 收入图标
    private lazy var inIconImageView: UIImageView = {
        
        var inIconImageView = UIImageView()
        inIconImageView.image = UIImage(named: "ic_home_income")
        return inIconImageView
    }()
    
    /// 收入金额
    private lazy var inMoneyLabel: UILabel = {
       
        var inMoneyLabel = UILabel()
        inMoneyLabel.textColor = YodoConfig.color.blackTitle
        inMoneyLabel.font = YodoConfig.font.bold(size: 20)
        
        return inMoneyLabel
    }()
    
    /// 收入标题
    private lazy var inTitleLabel: UILabel = {
        
        var inTitleLabel = UILabel()
        inTitleLabel.textColor = YodoConfig.color.darkGraySubTitle
        inTitleLabel.font = YodoConfig.font.bold(size: 12)
        
        return inTitleLabel
    }()
    // TODO
}
