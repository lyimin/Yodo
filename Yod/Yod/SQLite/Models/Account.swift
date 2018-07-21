//
//  Account.swift
//  Yod
//
//  Created by eamon on 2018/3/28.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import Foundation
import SQLite



public struct Account {
    /// 账单id
    var id: String = ""
    
    /// 账单类型
    var type: Category.AccountType = .expend
    
    /// 分类
    var category: Category!
    
    /// 金额
    var money: Double = 0.00
    
    /// 备注
    var remarks: String = ""
    
    /// 图片
    var pictures: String = ""
    
    /// 创建日期
    var createdAt: String = Date.now()
    
    /// 更新时间
    var updateAt: String?
    
    /// 删除时间
    var deleteAt: String?
    
    /// 日期对象
    var date: YodDate! = YodDate(date: Date.now())
    
    init(){}
    
    init(dic: [String: AnyObject]) {
        id = "\(dic["id"] as! Int64)"
        let categoryId = dic["categoryId"] as! String
        category = Category(id: categoryId)
        money =  dic["money"] as? Double ?? 0.00
        remarks = dic["remarks"] as? String ?? ""
        pictures = dic["pictures"] as? String ?? ""
        
        createdAt = dic["createdAt"] as! String
        date = YodDate(date: createdAt)
    }
    
    init(dao: AccountDao) {
        id = "\(dao.id!)"
        type = Category.AccountType(rawValue: dao.type)!
        money = dao.money
        remarks = dao.remarks ?? ""
        pictures = dao.pictures ?? ""
        createdAt = dao.createdAt
        updateAt = dao.updateAt
        deleteAt = dao.deleteAt
        date = YodDate(date: dao.createdAt)
    }
    
    func toDao() -> AccountDao {
        
        
        let json: [String: Any] = [
            "id": Int64(id) ?? "",
            "categoryId": category!.id,
            "type": type.rawValue,
            "money": money,
            "remarks": remarks,
            "pictures": pictures,
            "createdAt": createdAt,
            "updateAt": updateAt ?? "",
            "deleteAt": deleteAt ?? "",
        ]
        
        
        return AccountDao(JSON: json)!
    }
}



