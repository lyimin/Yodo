//
//  Category.swift
//  Yod
//
//  Created by eamon on 2018/5/8.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

struct Category {
    
    /// 账单类型
    ///
    /// - expend: 支出
    /// - income: 收入
    enum AccountType: Int {
        case expend = 1
        case income
    }
    
    /// id
    var id: String = ""
    
    /// 名称
    var name: String!
    
    /// 图标
    var icon: String!
    
    /// 背景色
    var color: String!
    
    /// 类型（支出，收入）
    var type: AccountType! = .expend
    
    /// 删除时间
    var deletedAt: String?
    
    init(id: String) {
        self.id = id
    }
    
    init(dict: [String: Any]) {
        id = "\(dict["id"] as! Int64)"
        name = dict["name"] as? String ?? ""
        icon = dict["icon"] as? String ?? ""
        color = dict["color"] as? String ?? ""
        type = AccountType(rawValue: dict["type"] as! Int)
        deletedAt = dict["deletedAt"] as? String
    }
    
    init(dao: CategoryDao?) {
        
        if let dao = dao {
        
            id = "\(dao.id)"
            name = dao.name
            icon = dao.icon
            color = dao.color
            type = AccountType(rawValue: dao.type)
            deletedAt = dao.deletedAt
        }
    }
}

extension String {
    
    func formatAccountType() -> Category.AccountType {
        switch self {
        case "支出":
            return Category.AccountType.expend
        case "收入":
            return Category.AccountType.income
        default:
            return Category.AccountType.expend
        }
    }
}
