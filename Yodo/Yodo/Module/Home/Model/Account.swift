//
//  Account.swift
//  Yodo
//
//  Created by 梁亦明 on 2018/3/28.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import Foundation
import SQLite



/// 账单类型
///
/// - expend: 支出
/// - income: 收入
enum AccountType: Int {
    case expend = 0
    case income
}

public struct Account {
    
    public static let tableName = "account"
    
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
    var createdAt: Date = Date()
    
    init(){}
    
    init(dic: [String: AnyObject]) {
        self.id = "\(dic["id"] as! Int64)"
        self.type = AccountType(rawValue: dic["type"] as! Int)!
        self.category = dic["category"] as! String
        self.money =  dic["money"] as? Double ?? 0.00
        self.remarks = dic["remarks"] as? String ?? ""
        self.pic = dic["pic"] as? String ?? ""
        
//        let date = dic["createdAt"] as! String
        
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
