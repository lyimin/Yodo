//
//  AccountViewModel.swift
//  Yod
//
//  Created by eamon on 2018/4/11.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

class AccountViewModel: NSObject {
    
    
    /// 获取首页数据回调    
    
}

extension AccountViewModel {
    
    // TODO
    /*
    /// 根据当前日期返回相邻两个月的账单数据
    
    
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
                    dataSource.append(self.getMonthData(withYodDate: date))
                }
            } else {
                // 获取最后3条数据
                let lastDate = dates.last!
                dataSource.append(self.getMonthData(withYodDate: lastDate.getYodDate(withIndex: -2)))
                dataSource.append(self.getMonthData(withYodDate: lastDate.getYodDate(withIndex: -1)))
                dataSource.append(self.getMonthData(withYodDate: lastDate))
            }
            
            DispatchQueue.main.async {
                if let cb = callback {
                    cb(HomeModel(dates: dates, monthModels: dataSource))
                }
            }
        }
    }
    
    */
}
