//
//  SQLManager.swift
//  Yod
//
//  Created by eamon on 2018/5/8.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import Foundation
import SQLite

public class SQLManager {
    
    private let docName = "com.eamon.EMSQLite"
    private let dbName = "Yod.sqlite3"
    
    
    // 数据库保存地址
    public var path: String!
    
    // 数据库对象
    public var db: Connection!
    
    public var account: AccountManager!
    
    public var category: CategoryManager!
    
    public init(path: String? = nil) {
        let rootPath = path ?? NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        self.path = (rootPath as NSString).appendingPathComponent(docName)
        
        do {
            try FileManager.default.createDirectory(atPath: self.path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            assertionFailure("[EMSQLite] fail to create directory \(self.path)")
        }
    }
    
    /// 单例对象
    public static let `default`: SQLManager = {
        let manager = SQLManager()
        return manager
    }()
    
    /// 创建数据库
    /// - withName 数据库名称
    public func createdDB(withName name: String?) -> Self {
        
        let dbName = name ?? self.dbName
        let fileName = (path as NSString).appendingPathComponent(dbName)
        
        debugPrint("[EMSQLite] connection db. path: \(fileName)")
        
        do {
            db = try Connection(fileName)
            SQLManager.default.account = AccountManager(db: db)
            SQLManager.default.category = CategoryManager(db: db)
        } catch {
            assertionFailure("[EMSQLite] fail to create db \(dbName)")
        }
        
        return self
    }
   
}
