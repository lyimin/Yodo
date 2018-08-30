//
//  File.swift
//  Yod
//
//  Created by eamon on 2018/8/29.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

class StatisticsMenuItem: UICollectionViewCell, Reusable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // model
    var model: StatisticsDateModel! {
        didSet {
            titleLabel.text = model.monthFormat
            titleLabel.textColor = model.isSelect ? YodConfig.color.theme : YodConfig.color.blackTitle
        }
    }
    
    //MARK: - Getter | Setter
    
    /// 标题
    private lazy var titleLabel: UILabel = {
        
        var titleLabel = UILabel()
        titleLabel.font = YodConfig.font.bold(size: 16)
        titleLabel.textAlignment = .center
        titleLabel.textColor = YodConfig.color.blackTitle
        return titleLabel
    }()
}

// MARK: - PrivateMethods
extension StatisticsMenuItem {
    
    private func initView() {
        contentView.addSubview(titleLabel)
        setupLayout()
    }
    
    private func setupLayout() {
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
}
