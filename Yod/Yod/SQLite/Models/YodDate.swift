//
//  YodDate.swift
//  Yod
//
//  Created by eamon on 2018/4/11.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

/// 日期对象
struct YodDate {
    
    /// 日期
    var date: String
    
    /// 年份
    var year: String
    
    /// 月份
    var month: String
    
    /// 日期
    var day: String
    
    /// 是否是最初一个月的
    var isFirstMonth: Bool = false
    
    /// 是否是这个月
    var isThisMonth: Bool = false
    
    /// 是否选中
    var isSelected: Bool = false
    
    var isToday: Bool! {
        get {
            let now = Date().format()
            return now == self.description
        }
    }
    
    init(date: String) {
        self.date = date.format()
        
        let date = date.toDate()!;
        let yearMonthDay = date.getYearMonthDay()
        self.year = yearMonthDay.0
        self.month = yearMonthDay.1
        self.day = yearMonthDay.2
    }
    
    init(year: String, month: String) {
        self.year = year
        self.month = month
        self.day = "\(01)"
        self.date = "\(year)-\(month)-\(day)"
    }
    
    /// 计算两个日期之间相差的月份数
    ///
    /// - Returns: 月份个数
    func MonthGapCount(toDate to: YodDate) -> Int {
        guard (self <=> to) == false else {
            return 0
        }
        
        let first = dateInt() > to.dateInt() ?to :self
        let last = dateInt() > to.dateInt() ?self :to
        
        if last.monthInt() >= first.monthInt() {
            // +1 是包括当前月份，比如2017-04 | 2018-04 = 13
            return (last.yearInt() - first.yearInt())*12 + (last.monthInt() - first.monthInt()) + 1
        } else {
            return (last.yearInt() - first.yearInt() - 1)*12 + (12-first.monthInt()+1) + last.monthInt()
        }
        
        
        /* 这种方法行不通，计算的结果不是自己想要的
         let calendar = Calendar.current
         let com = calendar.dateComponents([.month], from: self.date.toDate(), to: to.date.toDate())
         return com.month ?? 0
         */
    }
    
    /// 获取时间对象
    ///
    /// - Parameter i: 时间间隙 如1是指获取当前对象的下个月
    ///                        -1是指获取上个月
    /// - Returns: 返回新的时间对象
    func getYodDate(withIndex i: Int) -> YodDate {
        let date = self.date.toDate()!
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        var comp = DateComponents()
        comp.month = i
        let newDate = calendar.date(byAdding: comp, to: date)
        let dateString = newDate!.toString()
        return YodDate(date: dateString)
    }
    
    static func now() -> YodDate {
        let nowDate = Date().toString()
        return YodDate(date: nowDate)
    }
}

precedencegroup DatePrecedence {
    associativity: none
    higherThan: MultiplicationPrecedence
}

infix operator <=>: DatePrecedence
infix operator =>: DatePrecedence

extension YodDate: Equatable {
    
    /// 判断年月日是否相等
    static func ==(lhs: YodDate, rhs: YodDate) -> Bool {
        return (lhs.yearInt() == rhs.yearInt()) && (lhs.monthInt() == rhs.monthInt()) && (lhs.dayInt() == rhs.dayInt())
    }
    
    /// 判断年月是否相等
    static func <=> (lhs: YodDate, rhs: YodDate) -> Bool {
        return (lhs.yearInt() == rhs.yearInt()) && (lhs.monthInt() == rhs.monthInt())
    }
    
    static func => (lhs: YodDate, rhs: YodDate) -> Bool {
        
        if lhs.yearInt() < rhs.yearInt() || (lhs.yearInt() == rhs.yearInt() && lhs.monthInt() < rhs.monthInt()) {
            return true
        }
        
        return false
    }
    
    func dateInt() -> Int {
        return Int("\(year)\(month)\(day)")!
    }
    
    func yearInt() -> Int {
        return Int(year)!
    }
    
    func monthInt() -> Int {
        return Int(month)!
    }
    
    func dayInt() -> Int {
        return Int(day)!
    }
}

extension YodDate {
    var description: String {
        return String(format: "%@-%@-%@", year, month, day)
    }
    
    var gobalDesc: String {
        if isToday {
            return "今天"
        } else {
            return description
        }
    }
}
