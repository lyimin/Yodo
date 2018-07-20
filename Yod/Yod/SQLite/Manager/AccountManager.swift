//
//  AccountManager.swift
//  Yod
//
//  Created by eamon on 2018/3/9.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import Foundation
import SQLite
import CSV
import ObjectMapper

/// AccountManager 直接跟sql打交道的类
public class AccountManager {
    
    public let tableName = "account"
    public let accountT = Table("account")
    
    public let id = Expression<Int64>("id")
    public let category = Expression<String>("categoryId")
    public let type = Expression<Int>("type")
    public let money = Expression<Double>("money")
    public let remarks = Expression<String>("remarks")
    public let longitude = Expression<String?>("longitude")
    public let latitude = Expression<String?>("latitude")
    public let address = Expression<String?>("address")
    public let pictures = Expression<String>("pictures")
    public let createdAt = Expression<String>("createdAt")
    public let updatedAt = Expression<String?>("updatedAt")
    public let deletedAt = Expression<String?>("deletedAt")
    
    private var db: Connection!
  
    convenience init(db: Connection!) {
        self.init()
        self.db = db
    }
}

// MARK: - Query
extension AccountManager {
    
    /// 查询第一条数据
    public func queryFirstData() -> AccountDao? {
        
        let sql = "SELECT * FROM \(tableName) WHERE createdAt = (SELECT MIN(createdAt) FROM \(tableName))"

        var temp: [String: AnyObject] = [:]
        
        let result = find(withSQL: sql)
        if let result = result {
            
            for row in result {
                for i in 0..<result.columnNames.count {
                    temp.updateValue(row[i] as AnyObject, forKey: result.columnNames[i])
                }
            }
        }
        if temp.count != 0 {
            let account = AccountDao(JSON: temp)
            return account
        }
        
        return nil
    }
    
    /// 查询某月的数据
    ///
    /// - Parameter withDate: 日期对象
    
    func findMonthAccounds(withDate date: YodDate, withType type: Int? = nil) -> [AccountDao] {
        
        var sql = "SELECT * FROM \(tableName) WHERE createdAt LIKE '\(date.year)-\(date.month)-%'"
        if let type = type {
            sql = sql + " AND type = \(type)"
        }
        sql = sql + " ORDER BY createdAt DESC"
        
        var out: [AccountDao] = []
        
        let result = find(withSQL: sql)
        if let result = result {
            
            var temp: [[String: AnyObject]] = []
            for row in result {
                var obj: [String: AnyObject] = [:]
                for i in 0..<result.columnNames.count {
                    obj.updateValue(row[i] as AnyObject, forKey: result.columnNames[i])
                }
                temp.append(obj)
            }
            
            // dic -> Account
            out = Mapper<AccountDao>().mapArray(JSONArray: temp)
        }
        
        return out
    }
    
    /// 执行查询语句
    private func find(withSQL sql: String) -> Statement? {
        
        do {
            return try db.prepare(sql)
        } catch {
            YodError("execute sql statement error: \(sql)")
        }
        
        return nil
    }
}


// MARK: - Insert
extension AccountManager {
    
    /// 导入csv文件
    public func loadCSV() {
        let path = Bundle.main.path(forResource: "20180509_account.csv", ofType: nil)
        
        do {
            let csv = try CSVReader(stream: InputStream(fileAtPath: path!)!, hasHeaderRow: true)
            while let row = csv.next() {
                writeToDB(items: row)
            }
        } catch {
            assertionFailure("fail to open csv file")
        }
    }
    
    private func writeToDB(items: [String]) {

        // 创建model
        var dict: [String: Any] = [:]
        for i in 0..<items.count {
            
            let item = items[i]
            if i == 1 {
                dict["type"] = Int(item)
            }
                
            else if i == 2 {
                dict["categoryId"] = item
            }
                
            else if i == 3 {
                dict["money"] = Double(item)!
            }
            else if i == 4 {
                dict["createdAt"] = item
            }
                
            else if i == 5 {
                dict["remarks"] = item
            } else {
                continue
            }
        }
        insertAccount(model: AccountDao(JSON: dict)!)
    }
    
    /// 插入数据
    ///
    /// - Parameter model: 账单model
    public func insertAccount(model: AccountDao) {
        let sql = "INSERT INTO \(tableName) (categoryId, type, money, remarks, pictures, createdAt) VALUES " +
        "('\(model.categoryId!)', '\(model.type!)', '\(model.money!)', '\(model.remarks!)', '\(model.pictures)', '\(model.createdAt!)')"
        do {
            try db.execute(sql)
            debugPrint("插入成功)")
        } catch {
            assertionFailure("[EMSQLite] undefine \(tableName) propreties")
        }
    }
}

// MARK: - delete
extension AccountManager {
    
    /// 删除数据
    public func deleteAccount(accountId: Int64) {
        let account = accountT.filter(id == accountId)
        do {
            try db.run(account.delete())
        } catch {
            assertionFailure("[EMSQLite] unable to delete account where id = \(accountId)")
        }
    }
    
    func deleteTable() {
        do {
            try db.run(accountT.drop(ifExists: true))
        } catch {
            assertionFailure("[EMSQLite] undefine \(tableName) propreties")
        }
    }
}


// MARK: - Created
extension AccountManager {
    
    /// 创建表
    public func createdAccountTable() {
        
        do {
            try db.run(accountT.create(ifNotExists: true){ t in
                t.column(id, primaryKey: .autoincrement)
                t.column(category)
                t.column(type)
                t.column(money)
                t.column(remarks)
                t.column(longitude)
                t.column(latitude)
                t.column(address)
                t.column(pictures)
                t.column(createdAt)
                t.column(updatedAt)
                t.column(deletedAt)
            })
        } catch {
            assertionFailure("[EMSQLite] fail to create table")
        }
    }
}


