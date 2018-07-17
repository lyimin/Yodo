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
    func typeBtnDidClick(headerView: BillDetailHeaderView, currentType: CategoryType)
    
    /// 金额改变
    func priceDidChange(headerView: BillDetailHeaderView, price: String)
    
    /// 某个分类
    func categoryItemDidClick(cardView: BillDetailCardView, category: Category)
    
    /// 点击某个日历
    func calendarItemDidClick(item: BillDetailItem, date: YodDate)
    
    /// 点击备注
    func noteItemDidClick(item: BillDetailItem, content: String)
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
    
    var account: Account! {
        didSet {
            headerView.account = account
            cardView.date = account.date
            cardView.note = account.remarks
        }
    }
}


