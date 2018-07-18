//
//  AccountDao.swift
//  Yod
//
//  Created by eamon on 2018/5/9.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit
import ObjectMapper

public class AccountDao: Mappable {
    
    /// id
    var id: Int64!
    
    /// 分类id
    var categoryId: String!
    
    /// 类型 (支出1，收入2)
    var type: Int!
    
    /// 金额
    var money: Double!
    
    /// 备注
    var remarks: String!
    
    /// 图片
    var pictures: String!
    
    /// 创建时间
    var createdAt: String!
    
    /// 更新时间
    var updateAt: String?
    
    /// 删除时间
    var deleteAt: String?
    
    required public init?(map: Map) {
    }

    public func mapping(map: Map) {
        id <- map["id"]
        categoryId <- map["categoryId"]
        type <- map["type"]
        money <- map["money"]
        remarks <- map["remarks"]
        createdAt <- map["createdAt"]
        updateAt <- map["updateAt"]
        deleteAt <- map["deleteAt"]
    }
}
