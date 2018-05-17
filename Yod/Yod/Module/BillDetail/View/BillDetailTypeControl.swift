//
//  BillDetailTypeControl.swift
//  Yod
//
//  Created by eamon on 2018/5/11.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

// TODO:
class BillDetailTypeControl: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(backgroundView)
        addSubview(indexView)
        addSubview(expendBtn)
        addSubview(incomeBtn)
        
        setupLayout()
        
        // 默认选中支出
        selectedBtn = expendBtn;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func typeBtnDidClick(btn: UIButton) {
        
        guard btn != selectedBtn else {
            return
        }
        
        selectedBtn.isSelected = false
        btn.isSelected = true
        selectedBtn = btn
        
        UIView.animate(withDuration: 0.2) {
            self.indexView.center = btn.center
        }
    }
    
    
    //MARK: - Getter | Setter
    private weak var selectedBtn: UIButton!
    
    /// 黑色背景色
    private(set) lazy var backgroundView: UIView = {
        
        var backgroundView = UIView()
        backgroundView.layer.cornerRadius = 17.5
        backgroundView.backgroundColor = YodConfig.color.rgb(red: 60, green: 66, blue: 90, alpha: 0.2)
        return backgroundView
    }()
    
    private lazy var indexView: UIView = {
        
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
        expendBtn.addTarget(self, action: #selector(BillDetailTypeControl.typeBtnDidClick(btn:)), for: .touchUpInside)
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
        incomeBtn.addTarget(self, action: #selector(BillDetailTypeControl.typeBtnDidClick(btn:)), for: .touchUpInside)
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
