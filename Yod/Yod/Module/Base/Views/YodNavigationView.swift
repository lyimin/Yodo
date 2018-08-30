//
//  YodNavigationView.swift
//  Yod
//
//  Created by eamon on 2018/7/27.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

class YodNavigationView: UIView {

    
    typealias BackBtnDidClickCallBack = () -> Void
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(backBtn)
        addSubview(titleLabel)
        addSubview(lineView)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Getter | Setter
    
    var backBtnDidClickCallBack: BackBtnDidClickCallBack?
    
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
        titleLabel.alpha = 0
        titleLabel.textColor = YodConfig.color.blackTitle
        titleLabel.textAlignment = .center
        titleLabel.font = YodConfig.font.bold(size: 18)
        return titleLabel
    }()

    
    /// 分割线
    private(set) lazy var lineView: UIView = {
        
        var lineView = UIView()
        lineView.alpha = 0
        lineView.backgroundColor = YodConfig.color.sepLine
        return lineView
    }()
}

extension YodNavigationView {
    
    @objc private func backBtnDidClick() {
        if let callback = backBtnDidClickCallBack {
            callback()
        }
    }
}

// MARK: - Private Methods
extension YodNavigationView {

    private func setupLayout() {

        backBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(25)
            make.top.equalTo(self).offset(YodConfig.frame.nvIconMarginTop + YodConfig.frame.safeTopHeight)
            make.size.equalTo(CGSize(width: 23, height: 23))
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(backBtn.snp.right).offset(20)
            make.right.equalTo(self).offset(-80)
            make.centerY.equalTo(backBtn)
            make.height.equalTo(20)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(0.5)
        }
    }

}
