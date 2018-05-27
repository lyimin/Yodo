//
//  BillDetailHeaderView.swift
//  Yod
//
//  Created by eamon on 2018/5/18.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit


typealias CategoryType = Category.AccountType

class BillDetailHeaderView: UIView {
    
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
    
    convenience init(frame: CGRect, contentView: BillDetailContentView) {
        self.init(frame: frame)
        self.contentView = contentView
    }
    
    weak var contentView: BillDetailContentView!
    
    /// 当前选中的类型（支出，收入）
    private weak var selectedBtn: UIButton!
    
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
        // 默认选中支出
        selectedBtn = typeControl.expendBtn;
        typeControl.incomeBtn.addTarget(self, action: #selector(typeBtnDidClick(btn:)), for: .touchUpInside)
        typeControl.expendBtn.addTarget(self, action: #selector(typeBtnDidClick(btn:)), for: .touchUpInside)
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

extension BillDetailHeaderView {
    
    @objc func backBtnDidClick() {
        if let delegate = contentView.delegate {
            delegate.backBtnDidClick()
        }
    }
    
    
    @objc func typeBtnDidClick(btn: UIButton) {
        
        guard btn != selectedBtn else {
            return
        }
        
        selectedBtn.isSelected = false
        btn.isSelected = true
        selectedBtn = btn
        
        UIView.animate(withDuration: 0.2) {
            self.typeControl.indexView.center = btn.center
        }
        
        // 回调给控制器
        if let delegate = contentView.delegate {
            delegate.typeBtnDidClick(currentType: btn.titleLabel!.text!.formatAccountType())
        }
    }
}

// MARK: - Private Methods
extension BillDetailHeaderView {
    
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

//MARK: --------------------------- BillDetailTypeControl --------------------------

class BillDetailTypeControl: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(backgroundView)
        addSubview(indexView)
        addSubview(expendBtn)
        addSubview(incomeBtn)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Getter | Setter
    
    
    /// 黑色背景色
    private(set) lazy var backgroundView: UIView = {
        
        var backgroundView = UIView()
        backgroundView.layer.cornerRadius = 17.5
        backgroundView.backgroundColor = YodConfig.color.rgb(red: 60, green: 66, blue: 90, alpha: 0.2)
        return backgroundView
    }()
    
    private(set) lazy var indexView: UIView = {
        
        var indexView = UIView()
        indexView.layer.cornerRadius = 17.5
        indexView.backgroundColor = UIColor.white
        indexView.isUserInteractionEnabled = false
        return indexView
    }()
    
    /// 支出
    private(set) lazy var expendBtn: UIButton = {
        
        var expendBtn = UIButton()
        expendBtn.isSelected = true
        expendBtn.setTitle("支出", for: .normal)
        expendBtn.titleLabel?.font = YodConfig.font.bold(size: 16)
        expendBtn.setTitleColor(.white, for: .normal)
        expendBtn.setTitleColor(YodConfig.color.blackTitle, for: [.highlighted, .selected])
        expendBtn.setTitleColor(YodConfig.color.blackTitle, for: .selected)
        return expendBtn
    }()
    
    /// 收入
    private(set) lazy var incomeBtn: UIButton = {
        
        var incomeBtn = UIButton()
        incomeBtn.setTitle("收入", for: .normal)
        incomeBtn.titleLabel?.font = YodConfig.font.bold(size: 16)
        incomeBtn.setTitleColor(.white, for: .normal)
        incomeBtn.setTitleColor(YodConfig.color.blackTitle, for: [.highlighted, .selected])
        incomeBtn.setTitleColor(YodConfig.color.blackTitle, for: .selected)
        return incomeBtn
    }()
}

// MARK: - Private Methods
extension BillDetailTypeControl {
    
    
    private func setupLayout() {
        
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        expendBtn.snp.makeConstraints { (make) in
            make.left.bottom.top.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.5)
        }
        
        incomeBtn.snp.makeConstraints { (make) in
            make.right.bottom.top.equalTo(self)
            make.width.equalTo(expendBtn)
        }
        
        indexView.snp.makeConstraints { (make) in
            make.edges.equalTo(expendBtn);
        }
    }
}


