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
    
    public func subString(from index: Int) -> String {
        if length > index && index > 0 {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[startIndex..<self.endIndex]
            return String(subString)
        } else {
            return self
        }
    }
    
    public func contains(_ string: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return range(of: string, options: .caseInsensitive) != nil
        }
        return range(of: string) != nil
    }
    
    public func double(locale: Locale = .current) -> Double? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self)?.doubleValue
    }
    
        
    public func positionOf(sub:String, backwards:Bool = false) -> Int {
        
        var pos = -1
        if let range = range(of:sub, options: backwards ? .backwards : .literal ) {
            if !range.isEmpty {
                pos = self.distance(from:startIndex, to:range.lowerBound)
            }
        }
        return pos
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

extension String {
    
    func addPrefix(prefix: String) -> String {
        return prefix+self
    }
    func formatPriceText() -> String {
        if let d = self.double() {
            return String(format: "%.2f", d)
        }
        return self
    }
}
