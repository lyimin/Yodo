//
//  StatisticsModel.swift
//  Yod
//
//  Created by eamon on 2018/8/30.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

struct StatisticsModel {
    
    /// 当前月份
    var month: StatisticsDateModel!
    
    /// 支出的所有分类
    var expendModels: [StatisticsCategoryModel] = []
    
    /// 收入的所有model
    var incomeModels: [StatisticsCategoryModel] = []
    
    /// 支出的总金额
    var expendMoney = 0.0
    
    /// 收入的总金额
    var incomeMoney = 0.0
    
    init(month: StatisticsDateModel, entity: StatisticsEntity) {
        
        self.month = month
        expendMoney = entity.expendMoney
        incomeMoney = entity.incomeMoney
        
        expendModels = entity.expendEntities.map {
            var model = StatisticsCategoryModel(entity: $0)
            if expendMoney != 0.0 {
                model.percent = "\(Int($0.total / expendMoney * 100))"
            }
            return model
        }
        
        incomeModels = entity.incomeEntities.map {
            var model = StatisticsCategoryModel(entity: $0)
            if incomeMoney != 0.0 {
                model.percent = "\(Int($0.total / incomeMoney * 100))"
            }
            return model
        }
        
    }
    
    
}

// 统计的一个分类model
struct StatisticsCategoryModel {
    
    // 分类
    var category: Category!
    
    // 此分类记账数量
    var count: Int = 0
    
    // 总金额
    var total: String!
    
    // 占该分类的百分比
    var percent: String!
    
    init(entity: StatisticsCategoryEntity) {
        
        category = Category(entity: entity.category)
        count = entity.count
        total = entity.total.format()
    }
}
