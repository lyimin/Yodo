//
//  Account.swift
//  Yodo
//
//  Created by 梁亦明 on 2018/3/28.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import Foundation
import SQLite

public let account = Table("account")
public let id = Expression<Int64>("id")
public let type = Expression<Int>("type")
public let category = Expression<String>("category")
public let money = Expression<Double>("money")
public let remarks = Expression<String?>("remarks")
public let longitude = Expression<Double>("longitude")
public let latitude = Expression<Double>("latitude")
public let address = Expression<String?>("address")
public let pic = Expression<String?>("pic")
public let createdAt = Expression<Date>("createdAt")
public let updatedAt = Expression<Date?>("updatedAt")
public let deletedAt = Expression<Date?>("deletedAt")

/// 账单类型
///
/// - expend: 支出
/// - income: 收入
enum AccountType {
    case expend
    case income
}

struct Account {
    
    /// 账单id
    var id: String = ""
    
    /// 账单类型
    var type: AccountType = .expend
    
    /// 分类
    var category: String = ""
    
    /// 金额
    var money: Double = 0.0
    
    /// 备注
    var remarks: String = ""
    
    /// 创建日期
    var createdAt: Date = Date()
}

extension Account: SQLiteModel {
    
    /// 表名
    var tableName: String {
        return "account"
    }
    
    func primaryKey() -> String? {
        return "id"
    }
    
    func ignoreKeys() -> [String]? {
        return nil
    }
}

extension String {
    
    func formatAccountType() -> AccountType {
        switch self {
        case "支出":
            return AccountType.expend
        case "收入":
            return AccountType.income
        default:
            return AccountType.expend
        }
    }
    
    func formatAccountDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: self)!
    }
}
