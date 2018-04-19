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
    
    /// 获取日期数据
    func getDateDataSource() -> [YodoDate] {
        
        let firstDate = AccountManager.default.queryFirstData()?.createdAt;
        let nowDate = Date().toString()
        
        if let firstDate = firstDate {
            
            // 数据库有数据
            let first = YodoDate(date: firstDate)
            let now = YodoDate(date: nowDate)
            
            // 获取两个日期计算日期差
            let total = first.MonthGapCount(toDate: now)
            
            var outs: [YodoDate] = []
            for i in 0..<total {
                var newDate = first.getYodoDate(withIndex: i)
                if i == total-1 {
                    newDate.isThisMonth = true
                    newDate.isSelected = true
                }
                outs.append(newDate);
            }
            return outs
        } else {
            
            // 数据库没有数据
        }
        
        return []
    }
    
    
    /// 获取列表数据
    ///
    /// - Parameter date: 日期对象
    /// - Returns: 返回当前日期对象对应的数据
    func getListData(withYodoDate date: YodoDate) -> [AccountDailyModel] {
        
        let accounts = AccountManager.default.findMonthAccounds(withDate: date)
        self.accounts = accounts
        
        var dataSource: [AccountDailyModel] = []
        
        var temp: [Account] = []
        for account in accounts {
            
            if temp.count != 0 {
                let first = temp.first!
                if first.date == account.date {
                    temp.append(account)
                } else {
                    let daily = calculatePrice(withAccounts: temp)
                    let dailyModel = AccountDailyModel(accounts: temp, incomeOfDaily: daily.income, expendOfDaily: daily.expend)
                    dataSource.append(dailyModel)
                    temp.removeAll()
                    temp.append(account)
                }
            } else {
                temp.append(account)
            }
        }
        
        return dataSource
    }
    
    /// 计算总价格
    ///
    /// - Parameter accounts: 账单数组
    func calculatePrice(withAccounts accounts: [Account]) -> (expend: String, income: String) {
        
        var expTotal: Double = 0
        var incomeTotal: Double = 0
        
        for account in accounts {
            
            if account.type == Account.AccountType.expend {
                expTotal += account.money
            } else if account.type == Account.AccountType.income {
                incomeTotal += account.money
            }
        }
        return (String(format: "%.2f", expTotal), String(format: "%.2f", incomeTotal))
    }
}
