//
//  AccountHelper.swift
//  Yodo
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
    func getDates() -> [YodoDate] {
        
        let firstDate = manager.queryFirstData()?.createdAt;
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
            
            // 数据库没有数据 (返回当前月份的数据)
            let now = YodoDate(date: nowDate)
            return [now]
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

