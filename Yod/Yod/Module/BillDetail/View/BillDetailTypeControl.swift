//
//  BillDetailTypeControl.swift
//  Yod
//
//  Created by eamon on 2018/5/11.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

class BillDetailTypeControl: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(backgroundView)
        addSubview(indexView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 背景色
    private(set) lazy var backgroundView: UIView = {
        
        var backgroundView = UIView()
        backgroundView.layer.cornerRadius = 17.5
        backgroundView.backgroundColor = YodConfig.color.rgb(red: 60, green: 66, blue: 90, alpha: 0.2)
        return backgroundView
    }()
    
    /// 当前选中
    private(set) lazy var expendBtn: UIButton = {
        
        var expendBtn = UIButton()
        expendBtn.setTitle("支出", for: .normal)
        expendBtn.setTitleColor(YodConfig.color.blackTitle, for: .selected)
        expendBtn.setTitleColor(.white, for: .normal)
        expendBtn.setBackgroundImage(UIImage(, for: <#T##UIControlState#>)
        return expendBtn
    }()
}
