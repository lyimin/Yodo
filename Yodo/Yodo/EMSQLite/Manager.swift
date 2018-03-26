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
    public var db: Connection!
    
    public init(path: String? = nil) {
        let rootPath = path ?? NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        self.path = (rootPath as NSString).appendingPathComponent(docName)
    }
    
    /// 创建数据库
    /// - withName 数据库名称
    public func createdDB(withName name: String? = "Yodo.db") -> Self {
        
        do {
            Manager.default.db = try Connection((path as NSString).appendingPathComponent(name!))
        } catch {
            assertionFailure("[EMSQLite] fail to create db \(name!)")
        }
    
        return self
    }
    
    /// 创建表
    /// - withName 表名
    public func createTable<T: SQLiteModel>(withName name: String, model: T)  {
        
    }
}
