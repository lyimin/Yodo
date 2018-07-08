//
//  Date+Yod.swift
//  Yod
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
    
    static func now() -> String {
        return Date().toString()
    }
    
    /// 获取今天日期
    static func today() -> String {
        let dataFormatter = DateFormatter()
        dataFormatter.locale = Locale.current
        dataFormatter.dateFormat = "yyyy-MM-dd"
        return dataFormatter.string(from: Date())
    }
    
    /// 判断是否是今天
    static func isToday (dateString: String) -> Bool {
        return dateString == self.today()
    }
    
    static func start() -> Date {
        return Date(timeIntervalSince1970: getTimestamp(dateString: "2016-01-01"))
    }
    
    /// 根据日期获取时间戳
    static func getTimestamp (dateString: String) -> TimeInterval {
        if dateString.count <= 0 {
            return 0
        }
        let newDateStirng = dateString.appending(" 00:00:00")
        
        let formatter : DateFormatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.dateStyle = DateFormatter.Style.short
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "Asia/Beijing")
        
        let dateNow = formatter.date(from: newDateStirng)
        
        return (dateNow?.timeIntervalSince1970)!
    }
    
    /// 获取星期
    static func weekWithDateString (dateString : String) -> String{
        let timestamp = Date.getTimestamp(dateString: dateString)
        let day = Int(timestamp/86400)
        let array : Array = ["星期一","星期二","星期三","星期四","星期五","星期六","星期日"];
        return array[(day-3)%7]
    }
}
