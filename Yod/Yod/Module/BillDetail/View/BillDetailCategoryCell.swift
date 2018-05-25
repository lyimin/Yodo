//
//  BillDetailCategoryCell.swift
//  Yod
//
//  Created by eamon on 2018/5/25.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

class BillDetailCategoryCell: UICollectionViewCell, Reusable {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(iconBackground)
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setupLayout() {
        
        iconBackground.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.left.top.equalTo(self.contentView)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.contentView)
            make.top.equalTo(iconBackground.snp.bottom).offset(5)
            make.height.equalTo(20)
        }
    }
    
    //MARK: - Getter | Setter
    
    var category: Category! {
        didSet {
            iconView.image = UIImage(named: category.icon)
            iconBackground.backgroundColor = UIColor(hexString: category.color)
            titleLabel.text = category.name
            
            iconView.snp.makeConstraints { (make) in
                make.size.equalTo(iconView.image!.size)
                make.center.equalTo(iconBackground)
            }
        }
    }
    
    private lazy var iconView: UIImageView = {
        
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        return iconView
    }()
    
    private lazy var iconBackground: UIView = {
        
        let iconBackground = UIView()
        return iconBackground
    }()
    
    private lazy var titleLabel: UILabel = {
        
        let titleLabel = UILabel()
        titleLabel.textColor = YodConfig.color.blackTitle
        titleLabel.font = YodConfig.font.bold(size: 14)
        
        return titleLabel
    }()
}

