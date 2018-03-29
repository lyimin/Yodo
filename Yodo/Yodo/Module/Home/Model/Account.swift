//
//  Account.swift
//  Yodo
//
//  Created by 梁亦明 on 2018/3/28.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import Foundation

struct Account {
    
    
    /// 数据库名称
    static let accountTableName = "account"
    
    /// 账单类型
    ///
    /// - expend: 支出
    /// - income: 收入
    enum AccountType {
        case expend
        case income
    }
    
    /// 账单id
    var id: String = ""
    
    /// 账单类型
    var type: AccountType = .expend
    
    /// 分类
    var category: String = ""
    
    /// 金额
    var money: Double = 0.0
    
    /// 备注
    var remarks: String?
    
    /// 创建日期
    var data: Date = Date()
}

extension Account: SQLiteModel {
    func primaryKey() -> String? {
        return "id"
    }
    
    func ignoreKeys() -> [String]? {
        return nil
    }
}
