//
//  AccountViewModel.swift
//  Yodo
//
//  Created by eamon on 2018/4/11.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

class AccountViewModel: NSObject {
    
    
    /// 获取首页数据回调
    typealias HomeDataCallBack = (HomeModel) -> Void
    
    /// 获取某月的数据 转化成 HomeMonthModel对象
    ///
    /// - Parameter date: 日期对象
    /// - Returns: 返回当前日期对象对应的数据
    func getMonthData(withYodoDate date: YodoDate) -> HomeMonthModel {
        
        let accounts = AccountHelper.default.manager.findMonthAccounds(withDate: date)
        let total = AccountHelper.default.calculatePrice(withAccounts: accounts)
        
        var monthModel = HomeMonthModel(date: date, dailyModels: [], income:total.income, expend: total.expend)
        var temp: [Account] = []
        
        for account in accounts {
            
            if temp.count == 0 {
                temp.append(account)
                continue
            }
            
            let first = temp.first!
            if first.date == account.date {
                temp.append(account)
            } else {
                let daily = AccountHelper.default.calculatePrice(withAccounts: temp)
                let dailyModel = HomeDailyModel(accounts: temp, incomeOfDaily: daily.income, expendOfDaily: daily.expend)
                monthModel.dailyModels.append(dailyModel)

                temp.removeAll()
                temp.append(account)
            }
        }
        
        return monthModel
    }
}

extension AccountViewModel {
    
    // TODO
    
    /// 根据当前日期返回相邻两个月的账单数据
    
    /// 一.日期数组>=3的情况下
    /// 1.当前月份是最早的一个月(2017.4)  -> 2017.4, 2017.5, 2017,6 三个月的数据
    /// 2.当前月份是当前月份(2018.4) -> 2018.2, 2018.3, 2018.4 三个月的数据//MARK: - Life Cycle
    /// 二.日期数组小于3的情况下全部返回
    /// - Parameter withCurrentDate: 当前选中的日期
    func getHomeData(callback: HomeDataCallBack?) {
        
        /// 先获取日期
        DispatchQueue.global().async {
            
            // 查询数据库日期
            let dates = AccountHelper.default.getDates()
            
            // 分两种情况。日期数组<=3 和 日期数组>3(获取3组)
            var dataSource: [HomeMonthModel] = []
            
            if dates.count <= 3 {
                // 获取全部日期
                for date in dates {
                    dataSource.append(self.getMonthData(withYodoDate: date))
                }
            } else {
                // 获取最后3条数据
                let lastDate = dates.last!
                dataSource.append(self.getMonthData(withYodoDate: lastDate.getYodoDate(withIndex: -2)))
                dataSource.append(self.getMonthData(withYodoDate: lastDate.getYodoDate(withIndex: -1)))
                dataSource.append(self.getMonthData(withYodoDate: lastDate))
            }
            
            DispatchQueue.main.async {
                if let cb = callback {
                    cb(HomeModel(dates: dates, monthModels: dataSource))
                }
            }
        }
    }
}
