//
//  YodService.swift
//  Yod
//
//  Created by eamon on 2018/5/10.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit


// Select
class YodService {
    
    /// 获取日期数据
    class func getDates(callback: @escaping ([YodDate]) -> Void) {
        
        DispatchQueue.global().async {
            
            let accountManager: AccountManager! = SQLManager.default.account
            let firstDate = accountManager.queryFirstData()?.createdAt;
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
                    }
                    outs.append(newDate);
                }
            }
            
            if outs.count == 0 {
                // 数据库没有数据 (返回当前月份的数据)
                let now = YodDate(date: nowDate)
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
    class func getMonthData(withYodDate date: YodDate, callback: @escaping (HomeMonthModel) -> Void) {
        
        DispatchQueue.global().async {
            
            let accountManager: AccountManager! = SQLManager.default.account
            let categoryManager: CategoryManager! = SQLManager.default.category
            
            // 获取accountDaos
            let accountDaos = accountManager.findMonthAccounds(withDate: date)
            
            // 获取category
            var accounts: [Account] = []
            for dao in accountDaos {
                
                var account = Account(dao: dao)
                
                // 分类
                let cDao: CategoryDao?
                if let categoryId = Int64(dao.categoryId) {
                    cDao = categoryManager.findCategory(byID: categoryId)
                } else {
                    cDao = categoryManager.findCategory(byID: 1)
                }
                
                if let cDao = cDao {
                    account.category = Category(dao: cDao)
                } else {
                    YodDebug("unable to find category id:\(dao.categoryId)")
                }
                
                accounts.append(account)
            }
            
            
            let total = calculatePrice(withAccounts: accounts)
            
            var monthModel = HomeMonthModel(date: date, dailyModels: [], income:total.income, expend: total.expend)
            
            guard accounts.count != 0 else {
                DispatchQueue.main.async {
                    callback(monthModel)
                }
                return
            }
            // 排序，再倒序
            let dates = Set(accounts.map { $0.date.description }).sorted().reversed()
            var resArray = [HomeDailyModel]()
            
            dates.forEach { date in
                let accountGroup = accounts.filter { $0.date.description == date }
                
                let daily = self.calculatePrice(withAccounts: accountGroup)
                let dailyModel = HomeDailyModel(accounts: accountGroup, incomeOfDaily: daily.income, expendOfDaily: daily.expend)
                resArray.append(dailyModel)
            }
            monthModel.dailyModels = resArray
            
            DispatchQueue.main.async {
                callback(monthModel)
            }
        }
    }
    
    /// 计算总价格
    ///
    /// - Parameter accounts: 账单数组
    class func calculatePrice(withAccounts accounts: [Account]) -> (expend: String, income: String) {
        
        var expTotal: Double = 0
        var incomeTotal: Double = 0
        
        for account in accounts {
            
            if account.type == Category.AccountType.expend {
                expTotal += account.money
            } else if account.type == Category.AccountType.income {
                incomeTotal += account.money
            }
        }
        return (expTotal.format(), incomeTotal.format())
    }
    
    /// 获取所有分类
    class func getCategories(callback: @escaping (_ expends: [Category], _ incomes: [Category]) -> Void) {
        
        DispatchQueue.global().async {
            
            let categoryDaos = SQLManager.default.category.findCategories()
            
            var expends: [Category] = []
            var incomes: [Category] = []
            for dao in categoryDaos {
                if Category.AccountType(rawValue: dao.type) == Category.AccountType.expend {
                    expends.append(Category(dao: dao))
                } else {
                    incomes.append(Category(dao: dao))
                }
            }
            
            DispatchQueue.main.async {
                callback(expends, incomes)
            }
        }
    }
}

// Insert
extension YodService {
    
    // 添加账单
    class func insertAccount(_ account: Account, callBack: @escaping () -> Void) {
        
        DispatchQueue.global().async {
            let dao = account.toDao()
            let aManager = SQLManager.default.account!
            aManager.insertAccount(model: dao)
            
            DispatchQueue.main.async {
                callBack()
            }
        }
        
    }
}

// Delete
extension YodService {
    
    // 删除账单
    class func deleteAccount(_ account: Account, callBack: @escaping () -> Void) {
        
        guard let id = Int64(account.id) else { return }
        
        DispatchQueue.global().async {
            
            let aManager = SQLManager.default.account!
            aManager.deleteAccount(accountId: id)
            
            DispatchQueue.main.async {
                callBack()
            }
        }
    }
}
