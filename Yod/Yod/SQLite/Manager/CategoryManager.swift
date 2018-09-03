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
            let dao = CategoryEntity(JSON: category)!
            dao.createdAt = Date.now()
            insertCategory(model: dao)
        }
    }
    
    /// 添加分类
    public func insertCategory(model: CategoryEntity) {
        
        let insert = categoryT.insert(name <- model.name!, icon <- model.icon!, color <- model.color!, type <- model.type!, createdAt <- model.createdAt!)
        
        do {
            try db.run(insert)
        } catch {
            assertionFailure("[EMSQLite] undefine \(tableName) propreties")
        }
    }
}

extension CategoryManager {
    
    /// 根据id获取分类
    public func findCategory(byID categoryId: Int64) -> CategoryEntity? {
        
        do {
            
            for category in try db.prepare(categoryT.filter(id == categoryId)) {
                
                let entity = CategoryEntity()
                entity.id = try category.get(id)
                entity.color = try category.get(color)
                entity.name = try category.get(name)
                entity.icon = try category.get(icon)
                entity.type = try category.get(type)
                entity.createdAt = try category.get(createdAt)
                entity.updatedAt = try category.get(updatedAt)
                entity.deletedAt = try category.get(deletedAt)
                
                return entity
            }
            
        } catch {
            assertionFailure("[EMSQLite] Fail to find \(tableName) categoryId: \(categoryId)")
        }
        
        return nil
    }
    
    
    /// 获取所有分类 // TODO:
    public func findCategories(withType type: Int? = nil) -> [CategoryEntity] {

        var sql = "SELECT * FROM \(tableName)"
        if let type = type {
            sql += " WHERE type = \(type)"
        }
        
        var out: [CategoryEntity] = []
        
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
            
            // dic -> Category
            out = Mapper<CategoryEntity>().mapArray(JSONArray: temp)
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
