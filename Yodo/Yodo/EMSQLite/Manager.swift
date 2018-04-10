//
//  Manager.swift
//  Yodo
//
//  Created by 梁亦明 on 2018/3/9.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import Foundation
import SQLite

public class Manager {
    
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
    public let createdAt = Expression<Date>("createdAt")
    public let updatedAt = Expression<Date?>("updatedAt")
    public let deletedAt = Expression<Date?>("deletedAt")
    
    private let docName = "com.eamon.EMSQLite"
    private let dbName = "Yodo.sqlite3"
    
    // 单例对象
    public static let `default`: Manager = {
       
        return Manager()
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
    
    /// 创建数据库
    /// - withName 数据库名称
    public func createdDB(withName name: String?) -> Self {
        
        let dbName = name ?? self.dbName
        let fileName = (path as NSString).appendingPathComponent(dbName)
        
        debugPrint("[EMSQLite] connection db. path: \(fileName)")
    
        do {
            Manager.default.db = try Connection(fileName)
        } catch {
            assertionFailure("[EMSQLite] fail to create db \(dbName)")
        }
    
        return self
    }
    
    
    /// 插入数据
    ///
    /// - Parameter model: 账单model
    func insertAccount(model: Account) {
        let sql = "INSERT INTO \(Account.tableName) (type, category, money, remarks, address, pic, createdAt) VALUES " +
        "(\(model.type.rawValue), '\(model.category)', \(model.money), '\(model.remarks)', '\(model.address)', '\(model.pic)', '\(model.createdAt)')"
        do {
            try db.execute(sql)
            debugPrint("插入成功)")
        } catch {
            assertionFailure("[EMSQLite] undefine \(Account.tableName) propreties")
        }
    }
    
    /// 查询第一条数据
    func queryFirstData() -> Account {
        var temp: [String: AnyObject] = [:]
        let sql = "SELECT * FROM \(Account.tableName) WHERE createdAt = (SELECT MIN(createdAt) FROM \(Account.tableName))"
        
        do {
            let result = try db.prepare(sql)
            let size = result.columnNames.count
            YodoDebug(debug: "\(size)");
            
            for row in result {
                for i in 0..<result.columnNames.count {
                    temp.updateValue(row[i] as AnyObject, forKey: result.columnNames[i])
                }
            }
        } catch {
            YodoError(err: "fail to queryFirstData")
        }
        return Account(dic: temp);
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
