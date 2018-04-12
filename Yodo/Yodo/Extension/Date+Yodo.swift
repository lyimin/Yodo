//
//  Date+Yodo.swift
//  Yodo
//
//  Created by eamon on 2018/4/11.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

extension Date {
    
    func format(withDateFormat f: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = f
        return formatter.string(from: self)
    }
    
    func format() -> String {
        return format(withDateFormat: "yyyy-MM-dd")
    }
    
    /// 转化为String格式
    func toString() -> String {
        return format(withDateFormat: "yyyy-MM-dd HH:mm:ss")
    }
    
    
    /// 获取年月日
    func getYearMonthDay() -> (String, String, String) {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: self)
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        
        return ("\(year)", String(format: "%02d", month), String(format: "%02d", day))
    }
}
