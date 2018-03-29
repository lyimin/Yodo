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
    
    /// 创建表
    /// - withName 表名
    public func createTable<T: SQLiteModel>(withName name: String, model: T)  {
        
        let m = EMMirrorModel.reflecting(model: model)

    }
    
    // 插入表格
    public func insert<T: SQLiteModel>(withTable table: Table, model: T) {
        
        let m = EMMirrorModel.reflecting(model: model)
        
        guard m != nil else {
            assertionFailure("[EMSQLite] undefine \(model.tableName) propreties")
            return
        }
        
        var setters: [SQLite.Setter] = [SQLite.Setter]()
        var primaryKeyM: EMMirrorProprety?
        for proprety in m!.propreties {
            if proprety.isPrimaryKey {
                primaryKeyM = proprety
                continue
            }
            if let setter = proprety.setter {
                setters.append(setter)
            } 
        }
        
        do {
            if let pm = primaryKeyM, pm.value != nil {
                let filter = table.filter(pm.filter())
                if let _ = try db.pluck(filter) {
                    try db.run(table.update(setters))
                } else {
                    try db.run(table.insert(setters))
                }
            } else {
                try db.run(table.insert(setters))
            }
        } catch {
            assertionFailure("[EMSQLite]: fail to insert row. error: \(error.localizedDescription)")
        }
    }
    
    public func createdAccountTable() {
        
        do {
            try db.run(account.create(ifNotExists: true){ t in
                t.column(id, primaryKey: .autoincrement)
                t.column(type, unique: true)
                t.column(category, unique: true)
                t.column(money, unique: true)
                t.column(remarks)
                t.column(longitude)
                t.column(latitude)
                t.column(address)
                t.column(pic)
                t.column(createdAt, unique: true)
                t.column(updatedAt)
                t.column(deletedAt)
            })
        } catch {
            assertionFailure("[EMSQLite] fail to create table")
        }
    }
    
    
}
