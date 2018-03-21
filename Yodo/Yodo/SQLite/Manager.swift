//
//  Manager.swift
//  Yodo
//
//  Created by 梁亦明 on 2018/3/9.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import Foundation
import SQLite

public let docName = "com.eamon.EMSQLite"

public class Manager {
    
    // 单例对象
    public static let `default`: Manager = {
       
        return Manager()
    }()
    
    // 数据库保存地址
    public var path: String
    
    // 数据库对象
    private var db: Connection?
    
    public init(path: String? = nil) {
        let rootPath = path ?? NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        self.path = (rootPath as NSString).appendingPathComponent(docName)
    }
    
    /// 创建数据库
    /// - withName 数据库名称
    public func createDB(withName name: String) -> Self {
        
        if name.isEmpty {
            assertionFailure("[EMSQLite] name is required")
            return self
        }
        
        Manager.default.db = try? Connection((path as NSString).appendingPathComponent(name))
        return self
    }
    
    /// 创建表
    /// - withName 表名
    public func createTable<T: SQLiteModel>(withName name: String, model: T)  {
        
    }
}
