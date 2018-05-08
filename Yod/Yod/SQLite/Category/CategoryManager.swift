//
//  CategoryManager.swift
//  Yod
//
//  Created by eamon on 2018/5/8.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import Foundation
import SQLite


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
