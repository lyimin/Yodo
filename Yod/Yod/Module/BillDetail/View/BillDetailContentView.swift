//
//  BillDetailContentView.swift
//  Yod
//
//  Created by eamon on 2018/5/7.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

protocol BillDetailContentViewDelegate: NSObjectProtocol {
    
    /// 点击返回按钮
    func backBtnDidClick()
    
    /// 点击收入支出
    func typeBtnDidClick(currentType: CategoryType)
    
    /// 某个分类
    func categoryItemDidClick(category: Category)
    
    /// 点击某个日历
    func calendarItemDidClick(date: YodDate)
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
    
    private(set) lazy var headerView: BillDetailHeaderView = {
        
        var headerView = BillDetailHeaderView(frame: CGRect(x: 0, y: 0, width: width, height: 200), contentView: self);
        return headerView
    }()
    
    
    /// 内容区域
    private(set) lazy var cardView: BillDetailCardView = {
        
        var cardView = BillDetailCardView(frame: CGRect(x: 0, y: 160, width: width, height: height-160), contentView: self)
        return cardView
    }()
    
    /// 全部分类
    var categories: [Category]! {
        didSet {
            cardView.categories = categories
        }
    }
    
    /// 当前选中的分类
    var currentCategory: Category! {
        didSet {
            if oldValue == nil {
                headerView.category = currentCategory
            } else if oldValue.id != currentCategory.id {
                shake(action: .selection)
                headerView.category = currentCategory
            }
        }
    }
}


