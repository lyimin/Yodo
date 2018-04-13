//
//  AccountManager.swift
//  Yodo
//
//  Created by eamon on 2018/3/9.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import Foundation
import SQLite

public class AccountManager {
    
    public let tableName = "account"
    public let accountT = Table("account")
    
    public let id = Expression<Int64>("id")
    public let type = Expression<Int>("type")
    public let category = Expression<String>("category")
    public let money = Expression<Double>("money")
    public let remarks = Expression<String?>("remarks")
    public let longitude = Expression<String?>("longitude")
    public let latitude = Expression<String?>("latitude")
    public let address = Expression<String?>("address")
    public let pic = Expression<String?>("pic")
    public let createdAt = Expression<String>("createdAt")
    public let updatedAt = Expression<String?>("updatedAt")
    public let deletedAt = Expression<String?>("deletedAt")
    
    private let docName = "com.eamon.EMSQLite"
    private let dbName = "Yodo.sqlite3"
    
    // 单例对象
    public static let `default`: AccountManager = {
       
        return AccountManager()
    }()
    
    // 数据库保存地址
    public var path: String
    
    // 数据库对象
    public var db: Connection!
    
    public init(path: String? = nil) {
        let rootPath = path ?? NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        self.path = (rootPath as NSString).appendingPathComponent(docName)
        
        do {
            try FileManager.default.createDirectory(atPath: self.path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            assertionFailure("[EMSQLite] fail to create directory \(self.path)")
        }
    }
}

// MARK: - Query
extension AccountManager {
    
    /// 查询第一条数据
    func queryFirstData() -> Account? {
        
        let sql = "SELECT * FROM \(tableName) WHERE createdAt = (SELECT MIN(createdAt) FROM \(tableName))"
        
        var temp: [String: AnyObject] = [:]
        do {
            let result = try db.prepare(sql)
            
            for row in result {
                for i in 0..<result.columnNames.count {
                    temp.updateValue(row[i] as AnyObject, forKey: result.columnNames[i])
                }
            }
        } catch {
            YodoError(err: "fail to queryFirstData")
        }
        
        if temp.count != 0 {
            return Account(dic: temp);
        }
        
        return nil
    }
    
    /// 查询某月的数据
    ///
    /// - Parameter withDate: 日期对象
    func findMonthAccounds(withDate date: YodoDate, withType type: Account.AccountType?) -> [Account] {
        
        var sql = "SELECT * FROM \(tableName) WHERE createdAt LIKE '\(date.year)-\(date.month)-%'"
        if let type = type {
            sql = sql + " AND type = \(type.rawValue)"
        }
        
        // TODO:
        var temp: [Account] = []
        do {
            let result = try db.prepare(sql)
        } catch {
            
        }
    }
    
    /// 执行查询语句
    private func find(withSQL sql: String) -> Statement? {
        
    }
}


// MARK: - Insert
extension AccountManager {
    
    /// 插入数据
    ///
    /// - Parameter model: 账单model
    func insertAccount(model: Account) {
        let sql = "INSERT INTO \(tableName) (type, category, money, remarks, address, pic, createdAt) VALUES " +
        "(\(model.type.rawValue), '\(model.category)', \(model.money), '\(model.remarks)', '\(model.address)', '\(model.pic)', '\(model.createdAt)')"
        do {
            try db.execute(sql)
            debugPrint("插入成功)")
        } catch {
            assertionFailure("[EMSQLite] undefine \(tableName) propreties")
        }
    }
}


// MARK: - Created
extension AccountManager {
    
    /// 创建数据库
    /// - withName 数据库名称
    public func createdDB(withName name: String?) -> Self {
        
        let dbName = name ?? self.dbName
        let fileName = (path as NSString).appendingPathComponent(dbName)
        
        debugPrint("[EMSQLite] connection db. path: \(fileName)")
        
        do {
            AccountManager.default.db = try Connection(fileName)
        } catch {
            assertionFailure("[EMSQLite] fail to create db \(dbName)")
        }
        
        return self
    }
    
    /// 创建表
    public func createdAccountTable() {
        
        do {
            try db.run(accountT.create(ifNotExists: true){ t in
                t.column(id, primaryKey: .autoincrement)
                t.column(type)
                t.column(category)
                t.column(money)
                t.column(remarks)
                t.column(longitude)
                t.column(latitude)
                t.column(address)
                t.column(pic)
                t.column(createdAt)
                t.column(updatedAt)
                t.column(deletedAt)
            })
        } catch {
            assertionFailure("[EMSQLite] fail to create table")
        }
    }
}
