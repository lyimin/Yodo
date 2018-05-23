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
        
        addSubview(headerView)
        addSubview(cardView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    weak var delegate: BillDetailContentViewDelegate?
    
    //MARK: - Getter | Setter
    
    private lazy var headerView: BillDetailHeaderView = {
        
        var headerView = BillDetailHeaderView(frame: CGRect(x: 0, y: 0, width: width, height: 200), contentView: self);
        return headerView
    }()
    
    
    /// 内容区域
    private lazy var cardView: BillDetailCardView = {
        
        var cardView = BillDetailCardView(frame: CGRect(x: 0, y: 160, width: width, height: height-160), contentView: self)
        return cardView
    }()
    
    var categories: (expends: [Category], incomes: [Category])! {
        didSet {
            
        }
    }
}


