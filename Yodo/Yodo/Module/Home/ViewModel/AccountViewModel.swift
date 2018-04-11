//
//  AccountViewModel.swift
//  Yodo
//
//  Created by 梁亦明 on 2018/4/11.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

class AccountViewModel: NSObject {
    
    /// 获取日期数据
    func getDateDataSource() -> [YodoDate] {
        
        let firstDate = Manager.default.queryFirstData()?.createdAt;
        let nowDate = Date().toString()
        
        if let firstDate = firstDate {
            
            // 数据库有数据
            let first = YodoDate(date: firstDate)
            let now = YodoDate(date: nowDate)
            
            // 获取两个日期计算日期差
            let total = first.MonthGapCount(toDate: now)
            
            var outs: [YodoDate] = []
            for i in 0..<total {
                let newDate = first.getYodoDate(withIndex: i)
                outs.append(newDate);
            }
            return outs
        } else {
            
            // 数据库没有数据
        }
        
        
        
        return []
    }
}
