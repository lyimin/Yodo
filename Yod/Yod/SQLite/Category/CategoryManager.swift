//
//  CategoryManager.swift
//  Yod
//
//  Created by eamon on 2018/5/8.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import Foundation
import SQLite
import ObjectMapper

public class CategoryManager {

    public let tableName = "category"
    private let categoryT = Table("category")

    private let id = Expression<Int64>("id")
    private let name = Expression<String>("name")
    private let icon = Expression<String>("icon")
    private let color = Expression<String>("color")
    private let type = Expression<Int>("type")
    private let createdAt = Expression<String>("createdAt")
    private let updatedAt = Expression<String?>("updatedAt")
    private let deletedAt = Expression<String?>("deletedAt")
    
    private var db: Connection!
    
    convenience init(db: Connection!) {
        self.init()
        self.db = db
    }
}

extension CategoryManager {
    
    /// 创建表
    public func createdCategoryTable() {
        
        do {
            try db.run(categoryT.create(ifNotExists: true){ t in
                t.column(id, primaryKey: .autoincrement)
                t.column(name)
                t.column(icon)
                t.column(color)
                t.column(type)
                t.column(createdAt)
                t.column(updatedAt)
                t.column(deletedAt)
            })
        } catch {
            assertionFailure("[EMSQLite] fail to create table")
        }
    }
}

infix operator <-: ColumnAssignment

// MARK: - insert
extension CategoryManager {
    // 添加默认分类到数据库
    public func loadCategories() {
        let path = Bundle.main.path(forResource: "categories.plist", ofType: nil)
        
        let categories = NSArray(contentsOfFile: path!) as! Array<Dictionary<String, Any>>

        for category in categories {
            let dao = CategoryDao(JSON: category)!
            dao.createdAt = Date.now()
            insertCategory(model: dao)
        }
    }
    
    /// 添加分类
    public func insertCategory(model: CategoryDao) {
        
        let insert = categoryT.insert(name <- model.name!, icon <- model.icon!, color <- model.color!, type <- model.type!, createdAt <- model.createdAt!)
        
        do {
            try db.run(insert)
        } catch {
            assertionFailure("[EMSQLite] undefine \(tableName) propreties")
        }
    }
}

extension CategoryManager {
    
    public func findCategory(byID categoryId: Int64) {
        
        let query = categoryT.filter(id == categoryId)
        
        
        do {
            for category in try db.prepare(categoryT.filter(id == 1)) {
                category.get(id)
            }
            
        } catch {
            
        }
        
//        query.column
    }
}

// MARK: - delete
extension CategoryManager {
    
    public func deleteTable() {
        do {
            try db.run(categoryT.drop(ifExists: true))
        } catch {
            assertionFailure("[EMSQLite] undefine \(tableName) propreties")
        }
    }
}
