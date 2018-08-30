//
//  StatisticsDateModel.swift
//  Yod
//
//  Created by eamon on 2018/8/29.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import Foundation

class StatisticsDateModel {
    
    // 全部
    var text: String?
    // 日期
    var date: YodDate?
    // 是否选中
    var isSelect: Bool = false
    
    init(date: YodDate) {
        self.date = date
    }
    
    convenience init(date: YodDate, isSelect: Bool) {
        self.init(date: date)
        self.isSelect = isSelect
    }
    
    init(text: String) {
        self.text = text
    }
    
    var monthFormat: String {
        if let date = date {
            return "\(date.month)月"
        }
        return "全部"
    }
}
