//
//  String+Yod.swift
//  Yod
//
//  Created by eamon on 2018/4/11.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import Foundation


// String -> Date
extension String {
    
    var length: Int {
        return count
    }
    
    /// 转化为date对象
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = formatter.date(from: self) {
            return date
        } else {
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.date(from: self)
        }
    }
    
    /// 根据对应的格式转化
    func format(withDateFormat f: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = f
        
        
        return formatter.string(from: self.toDate()!)
    }
    
    /// 转化为yyyy-MM-dd格式
    func format() -> String {
        return format(withDateFormat: "yyyy-MM-dd")
    }
    
    /// 获取年份
    func getYear() -> String {
        return format(withDateFormat: "yyyy")
    }
    
    /// 获取月份
    func getMonth() -> String {
        return format(withDateFormat: "MM")
    }
    
    /// 获取日
    func getDay() -> String {
        return format(withDateFormat: "MM")
    }
}
