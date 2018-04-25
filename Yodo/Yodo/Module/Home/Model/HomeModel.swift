//
//  HomeModel.swift
//  Yodo
//
//  Created by eamon on 2018/4/25.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

struct HomeModel {
    
    var dates: [YodoDate] = []
    
}

/// 首页每日的收支 model(首页一个section)
struct HomeDailyModel {
    
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

/// 首页一个月的数据
struct HomeMonthModel {
    
    /// 日期
    var date: YodoDate!
    
    /// 当月每日的数据
    var dailyModels: [HomeDailyModel] = []
    
    init(date: YodoDate, dailyModels: [HomeDailyModel]) {
        self.date = date
        self.dailyModels = dailyModels
    }
}
