//
//  AccountViewModel.swift
//  Yodo
//
//  Created by eamon on 2018/4/11.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

class AccountViewModel: NSObject {
    
    var accounts: [Account] = []
    
    /// 获取某月的数据 转化成 HomeMonthModel对象
    ///
    /// - Parameter date: 日期对象
    /// - Returns: 返回当前日期对象对应的数据
    func getMonthData(withYodoDate date: YodoDate) -> HomeMonthModel {
        
        let accounts = AccountHelper.default.manager.findMonthAccounds(withDate: date)
        self.accounts = accounts
        
        var monthModel = HomeMonthModel(date: date, dailyModels: [])
        
        var temp: [Account] = []
        for account in accounts {
            
            if temp.count != 0 {
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
            } else {
                temp.append(account)
            }
        }
        
        return monthModel
    }
}

extension AccountViewModel {
    
    // TODO
    /// 获取首页的数据
    func getHomeData() {
        
        /// 先获取日期
        DispatchQueue.global().async {
            
            // 查询数据库日期
            let dates = AccountHelper.default.getDates()
            
            // 分两种情况。日期数组<3 和 日期数组>=3(获取3组)
            var dataSource: [HomeMonthModel] = []
            
            if dates.count < 3 {
                // 获取全部日期
                for date in dates {
//                    let ds = self.getListData(withYodoDate: date)
                }
            }

        }
    }
}
