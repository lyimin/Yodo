//
//  Account.swift
//  Yodo
//
//  Created by eamon on 2018/3/28.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import Foundation
import SQLite



public struct Account {
    
    /// 账单类型
    ///
    /// - expend: 支出
    /// - income: 收入
    enum AccountType: Int {
        case expend = 0
        case income
    }
    
    // TODO:
    enum CategoryType: String {
        case normal = "一般"
    }
    
    /// 账单id
    var id: String = ""
    
    /// 账单类型
    var type: AccountType = .expend
    
    /// 分类
    var category: String = ""
    
    /// 金额
    var money: Double = 0.00
    
    /// 备注
    var remarks: String = ""
    
    /// 地址
    var address: String = ""

    /// 图片
    var pic: String = ""
    
    /// 创建日期
    var createdAt: String = ""
    
    /// 日期对象
    var date: YodoDate!
    
    init(){}
    
    init(dic: [String: AnyObject]) {
        id = "\(dic["id"] as! Int64)"
        type = AccountType(rawValue: dic["type"] as! Int)!
        category = dic["category"] as! String
        money =  dic["money"] as? Double ?? 0.00
        remarks = dic["remarks"] as? String ?? ""
        pic = dic["pic"] as? String ?? ""
        
        createdAt = dic["createdAt"] as! String
        date = YodoDate(date: createdAt)
    }
}

extension String {
    
    func formatAccountType() -> Account.AccountType {
        switch self {
        case "支出":
            return Account.AccountType.expend
        case "收入":
            return Account.AccountType.income
        default:
            return Account.AccountType.expend
        }
    }
}

// 首页每日的收支 model(首页一个section)
struct AccountDailyModel {
    
    /// 当天账单数组
    var accounts: [Account]!
    
    var isToday: Bool!
    
    /// 星期
    var week: String!
    
    /// 日期
    var date: YodoDate!

    /// 当天收入
    var incomeOfDaily: String!
    
    /// 当天支出
    var expendOfDaily: String!
    
    init(accounts: [Account], incomeOfDaily: String, expendOfDaily: String) {
        
        self.accounts = accounts
        self.incomeOfDaily = incomeOfDaily
        self.expendOfDaily = expendOfDaily
        date = accounts.first!.date
        week = Date.weekWithDateString(dateString: date.date)
        isToday = Date.isToday(dateString: date.date)
    }
}

