//
//  BillDetailCardView.swift
//  Yod
//
//  Created by eamon on 2018/5/18.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

class BillDetailCardView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 添加背景色
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.fillColor = UIColor.white.cgColor
        backgroundLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 15, height: 15)).cgPath
        layer.insertSublayer(backgroundLayer, at: 0)
        
        addSubview(categoryTitleLabel)
        
        setupLayout()
    }
    
    convenience init(frame: CGRect, contentView: BillDetailContentView) {
        self.init(frame: frame)
        self.contentView = contentView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Getter | Setter
    
    weak var contentView: BillDetailContentView!
    
    /// 标题
    private lazy var categoryTitleLabel: UILabel = {
        
        let categoryTitleLabel = UILabel()
        categoryTitleLabel.text = "选择分类"
        categoryTitleLabel.font = YodConfig.font.bold(size: 16)
        categoryTitleLabel.textColor = YodConfig.color.blackTitle
        return categoryTitleLabel
    }()
    
    
}

// MARK: - Private Methods
extension BillDetailCardView {
    
    private func setupLayout() {
        
        categoryTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(30)
            make.top.equalTo(self).offset(25)
            make.size.right.equalTo(self).offset(-30)
            make.height.equalTo(25)
        }
    }
    
}
