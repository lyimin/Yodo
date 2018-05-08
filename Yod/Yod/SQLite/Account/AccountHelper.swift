//
//  AccountHelper.swift
//  Yod
//
//  Created by eamon on 2018/4/25.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit


/// 基于AccountManger 获取账单api接口类
public class AccountHelper: NSObject {

    public override init() {}
    
    /// manager
    public var manager: AccountManager!

    /// 单例对象
    public static let `default`: AccountHelper = {
        let helper = AccountHelper()
        helper.manager = AccountManager()
        return helper
    }()
}

extension AccountHelper {
    
    /// 获取日期数据
    func getDates(callback: @escaping ([YodDate]) -> Void) {
        
        DispatchQueue.global().async {
            let firstDate = self.manager.queryFirstData()?.createdAt;
            let nowDate = Date().toString()
            
            var outs: [YodDate] = []
            if let firstDate = firstDate {
                
                // 数据库有数据
                let first = YodDate(date: firstDate)
                let now = YodDate(date: nowDate)
                
                // 获取两个日期计算日期差
                let total = first.MonthGapCount(toDate: now)
                
                
                for i in 0..<total {
                    var newDate = first.getYodDate(withIndex: i)
                    
                    newDate.isFirstMonth = i == 0
                    
                    if i == total-1 {
                        newDate.isThisMonth = true
                        newDate.isSelected = true
                    }
                    outs.append(newDate);
                }
                
            } else {
                
                // 数据库没有数据 (返回当前月份的数据)
                var now = YodDate(date: nowDate)
                now.isSelected = true
                outs.append(now)
            }
            
            DispatchQueue.main.async {
                callback(outs)
            }
        }
    }
    
    /// 获取某月的数据 转化成 HomeMonthModel对象
    ///
    /// - Parameter date: 日期对象
    /// - Returns: 返回当前日期对象对应的数据
    func getMonthData(withYodDate date: YodDate, callback: @escaping (HomeMonthModel) -> Void) {
        
        DispatchQueue.global().async {
            
            let accounts = self.manager.findMonthAccounds(withDate: date)
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
            
            DispatchQueue.main.async {
                callback(monthModel)
            }
        }
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

