//
//  StatisticsNavigationView.swift
//  Yod
//
//  Created by eamon on 2018/7/27.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

protocol StatisticsNavigationViewDelegate: class {
    
    /// 点击返回按钮
    func backBtnDidClick()
}

class StatisticsNavigationView: UIView {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(backBtn)
        addSubview(titleLabel)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Getter | Setter
    
    weak var delegate: StatisticsNavigationViewDelegate?
    
    /// 返回按钮
    private(set) lazy var backBtn: UIButton = {
        
        var backBtn = UIButton()
        backBtn.setImage(#imageLiteral(resourceName: "ic_blue_back"), for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnDidClick), for: .touchUpInside)
        return backBtn
    }()

    /// 标题
    private(set) lazy var titleLabel: UILabel = {

        var titleLabel = UILabel()
        titleLabel.text = "统计"
        titleLabel.textColor = YodConfig.color.blackTitle
        titleLabel.font = YodConfig.font.bold(size: 25)
        return titleLabel
    }()
    
    /// 分割线
    private lazy var lineView: UIView = {
        
        var lineView = UIView()
        lineView.backgroundColor = YodConfig.color.sepLine
        return lineView
    }()
}

extension StatisticsNavigationView {
    
    @objc private func backBtnDidClick() {
        if let delegate = delegate {
            delegate.backBtnDidClick()
        }
    }
}

// MARK: - Private Methods
extension StatisticsNavigationView {

    private func setupLayout() {

        backBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(25)
            make.top.equalTo(self).offset(YodConfig.frame.nvIconMarginTop + YodConfig.frame.safeTopHeight)
            make.size.equalTo(CGSize(width: 23, height: 23))
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(25)
            make.size.equalTo(CGSize(width: 100, height: 40))
            make.top.equalTo(backBtn.snp.bottom).offset(15)
        }
        
//        lineView.snp.makeConstraints { (make) in
//            make.left.right.bottom.equalTo(self)
//            make.height.equalTo(0.5)
//        }
    }

}
