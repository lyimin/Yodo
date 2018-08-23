//
//  HomeDetailContentView.swift
//  Yod
//
//  Created by eamon on 2018/5/7.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

protocol HomeDetailContentViewDelegate: NSObjectProtocol {
    
    /// 点击返回按钮
    func backBtnDidClick()
    
    /// 点击收入支出
    func typeBtnDidClick(headerView: HomeDetailHeaderView, currentType: CategoryType)
    
    /// 金额改变
    func priceDidChange(headerView: HomeDetailHeaderView, price: String)
    
    /// 某个分类
    func categoryItemDidClick(cardView: HomeDetailCardView, category: Category)
    
    /// 点击某个日历
    func calendarItemDidClick(item: HomeDetailItem, date: YodDate)
    
    /// 点击备注
    func noteItemDidClick(item: HomeDetailItem, content: String)
}

class HomeDetailContentView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(headerView)
        addSubview(cardView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    weak var delegate: HomeDetailContentViewDelegate?
    
    //MARK: - Getter | Setter
    
    private(set) lazy var headerView: HomeDetailHeaderView = {
        
        var headerView = HomeDetailHeaderView(frame: CGRect(x: 0, y: 0, width: width, height: 200), contentView: self);
        return headerView
    }()
    
    
    /// 内容区域
    private(set) lazy var cardView: HomeDetailCardView = {
        
        var cardView = HomeDetailCardView(frame: CGRect(x: 0, y: 160, width: width, height: height-160), contentView: self)
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


