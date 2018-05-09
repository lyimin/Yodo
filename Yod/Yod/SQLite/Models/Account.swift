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
    
    /// 地址
    var address: String = ""

    /// 图片
    var pic: String = ""
    
    /// 创建日期
    var createdAt: String = ""
    
    /// 更新时间
    var updateAt: String?
    
    /// 删除时间
    var deleteAt: String?
    
    /// 日期对象
    var date: YodDate!
    
    init(){}
    
    init(dic: [String: AnyObject]) {
        id = "\(dic["id"] as! Int64)"
        let categoryId = dic["categoryId"] as! String
        category = Category(id: categoryId)
        money =  dic["money"] as? Double ?? 0.00
        remarks = dic["remarks"] as? String ?? ""
        pic = dic["pic"] as? String ?? ""
        
        createdAt = dic["createdAt"] as! String
        date = YodDate(date: createdAt)
    }
}



