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
        return backgroundView
    }()
    
    /// 当前选中
    private(set) lazy var indexView: UIView = {
        
        var indexView = UIView()
        return indexView
    }()
}
