//
//  Account.swift
//  Yodo
//
//  Created by 梁亦明 on 2018/3/28.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import Foundation
import SQLite



/// 账单类型
///
/// - expend: 支出
/// - income: 收入
enum AccountType: Int {
    case expend = 0
    case income
}

public struct Account {
    
    public static let tableName = "account"
    
    /// 账单id
    var id: String = ""
    
    /// 账单类型
    var type: AccountType = .expend
    
    /// 分类
    var category: String = ""
    
    /// 金额
    var money: Double = 0.00
    
    /// 备注
    var remarks: String = ""
    
    /// 地址
    var address: String = ""

    /// 图片
    var pic: String = ""
    
    /// 创建日期
    var createdAt: String = ""
    
    init(){}
    
    init(dic: [String: AnyObject]) {
        self.id = "\(dic["id"] as! Int64)"
        self.type = AccountType(rawValue: dic["type"] as! Int)!
        self.category = dic["category"] as! String
        self.money =  dic["money"] as? Double ?? 0.00
        self.remarks = dic["remarks"] as? String ?? ""
        self.pic = dic["pic"] as? String ?? ""
        
        self.createdAt = dic["createdAt"] as! String
    }
}

// yyyy-MM-dd

precedencegroup DatePrecedence {
    associativity: none
    higherThan: MultiplicationPrecedence
}

infix operator <=>: DatePrecedence

/// 日期对象
struct YodoDate {
    var date: String
    var year: String
    var month: String
    var day: String
    
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
    func MonthGapCount(toDate to: YodoDate) -> Int {
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
    
        
        /* 这种方法行不通，计算得不准确
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
    func getYodoDate(withIndex i: Int) -> YodoDate {
        let date = self.date.toDate()!
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        var comp = DateComponents()
        comp.month = i
        let newDate = calendar.date(byAdding: comp, to: date)
        let dateString = newDate!.toString()
        return YodoDate(date: dateString)
    }
}



extension YodoDate: Equatable {
    
    /// 判断年月日是否相等
    static func ==(lhs: YodoDate, rhs: YodoDate) -> Bool {
        return (lhs.yearInt() == rhs.yearInt()) && (lhs.monthInt() == rhs.monthInt()) && (lhs.dayInt() == rhs.dayInt())
    }
    
    /// 判断年月是否相等
    static func <=> (lhs: YodoDate, rhs: YodoDate) -> Bool {
        return (lhs.yearInt() == rhs.yearInt()) && (lhs.monthInt() == rhs.monthInt())
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


extension String {
    
    func formatAccountType() -> AccountType {
        switch self {
        case "支出":
            return AccountType.expend
        case "收入":
            return AccountType.income
        default:
            return AccountType.expend
        }
    }
}


