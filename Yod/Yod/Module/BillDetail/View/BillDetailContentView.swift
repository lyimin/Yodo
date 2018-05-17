//
//  BillDetailContentView.swift
//  Yod
//
//  Created by eamon on 2018/5/7.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

protocol BillDetailContentViewDelegate: NSObjectProtocol {
    func backBtnDidClick()
}

class BillDetailContentView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(backgroundColorView)
        addSubview(backBtn)
        addSubview(moneyLabel)
        addSubview(iconView)
        addSubview(typeControl)
        
        setupLayout()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    weak var delegate: BillDetailContentViewDelegate?
    
    //MARK: - Getter | Setter
    
    /// 返回
    private lazy var backBtn: UIButton = {
        
        let backBtn = UIButton()
        backBtn.addTarget(self, action: #selector(backBtnDidClick), for: .touchUpInside)
        backBtn.setImage(#imageLiteral(resourceName: "ic_white_back"), for: .normal)
        return backBtn
    }()
    
    /// 背景色
    private lazy var backgroundColorView: UIView = {
        var backgroundColorView = UIView()
        backgroundColorView.backgroundColor = UIColor(hexString: "#3294FA")
        return backgroundColorView
    }()
    
    /// 收入支出
    private lazy var typeControl: BillDetailTypeControl = {
        var typeControl = BillDetailTypeControl()
        return typeControl
    }()
    
    /// 当前选中的分类
    private lazy var iconView : UIImageView = {
        var iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        iconView.image = #imageLiteral(resourceName: "ic_category_normal")
        return iconView
    }()
    
    /// 价格
    private lazy var moneyLabel: UILabel = {
        let moneyLabel = UILabel()
        moneyLabel.textColor = .white
        moneyLabel.textAlignment = .right
        moneyLabel.font = UIFont.systemFont(ofSize: 35, weight: UIFont.Weight.ultraLight)
        moneyLabel.text = "- 0.00";
        return moneyLabel
    }()
}

// MARK: - Event | Action
extension BillDetailContentView {
    
    @objc func backBtnDidClick() {
        if let delegate = delegate {
            delegate.backBtnDidClick()
        }
    }
}

// MARK: - Getter | Setter
extension BillDetailContentView {
    
    private func setupLayout() {
        
        backBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(25)
            make.top.equalTo(self).offset(40)
            make.size.equalTo(CGSize(width: 23, height: 23))
        }
        
        backgroundColorView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.height.equalTo(200)
        }
        
        typeControl.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: 160, height: 35))
            make.centerY.equalTo(backBtn)
        }
        
        moneyLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-10)
            make.left.equalTo(iconView).offset(10)
            make.centerY.equalTo(iconView)
            make.height.equalTo(50)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.size.equalTo(iconView.image!.size)
            make.top.equalTo(backBtn.snp.bottom).offset(35)
            make.centerX.equalTo(backBtn).offset(5)
        }
    }
}
