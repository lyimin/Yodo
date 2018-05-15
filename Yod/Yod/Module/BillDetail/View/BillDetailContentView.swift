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
        addSubview(iconView)
        
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
    private lazy var typeControl: UISegmentedControl = {
        var typeControl = UISegmentedControl(items: ["支出", "收入"])
        return typeControl
    }()
    
    private lazy var iconView : UIImageView = {
        var iconView = UIImageView()
        iconView.image = #imageLiteral(resourceName: "ic_category_normal")
        return iconView
    }()
    
    private lazy var moneyLabel: UILabel = {
        let moneyLabel = UILabel()
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
        
        iconView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: <#T##CGFloat#>, height: <#T##CGFloat#>))
        }
    }
}
