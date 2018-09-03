//
//  StatisticsEntity.swift
//  Yod
//
//  Created by eamon on 2018/9/3.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import Foundation
import ObjectMapper

public class StatisticsEntity {
    
    /// 所有支出类别
    public var expendEntities: [StatisticsCategoryEntity] = []
    /// 所有收入类别
    public var incomeEntities: [StatisticsCategoryEntity] = []
    /// 支出总金额
    public var expendMoney: Double = 0.0
    /// 收入总金额
    public var incomeMoney: Double = 0.0
}

public class StatisticsCategoryEntity: Mappable {
    
    /// 分类
    public var category: CategoryEntity!
    
    /// 该分类的总价格
    public var total: Double!
    
    /// 该分类的记账数量
    public var count: Int!
    
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        
        category = CategoryEntity(map: map) 
        
        total <- map["total"]
        count <- map["count"]
    }
    
    
}
