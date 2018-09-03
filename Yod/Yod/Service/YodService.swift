//
//  YodService.swift
//  Yod
//
//  Created by eamon on 2018/5/10.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit


// 通用部分
class YodService {
    
    
    
    /// 根据YodDate获取某月记账条目
    ///
    /// - Parameter date: 日期对象
    /// - Returns: 返回记账条目数组
    class func getAccounts(withDate date: YodDate) -> [Account] {
        
        let accountManager: AccountManager! = SQLManager.default.account
        let categoryManager: CategoryManager! = SQLManager.default.category
        
        // 获取AccountEntitys
        let accountEntities = accountManager.findMonthAccounds(withDate: date)
        
        // 获取category
        var accounts: [Account] = []
        for entity in accountEntities {
            
            var account = Account(entity: entity)
            
            // 分类
            let cEntity: CategoryEntity?
            if let categoryId = Int64(entity.categoryId) {
                cEntity = categoryManager.findCategory(byID: categoryId)
            } else {
                cEntity = categoryManager.findCategory(byID: 1)
            }
            
            if let cEntity = cEntity {
                account.category = Category(entity: cEntity)
            } else {
                YodDebug("unable to find category id:\(entity.categoryId)")
            }
            
            accounts.append(account)
        }
        
        return accounts
    }
}
