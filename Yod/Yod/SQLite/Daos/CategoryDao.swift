//
//  CategoryDao.swift
//  Yod
//
//  Created by eamon on 2018/5/9.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit
import ObjectMapper

public class CategoryDao: Mappable {

    var id: Int64!
    var name: String!
    var icon: String!
    var color: String!
    var type: Int!
    var createdAt: String!
    var updatedAt: String?
    var deletedAt: String?
    
    public required init?(map: Map) {
    }
    
    public init() {
    }
    
    public func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        icon <- map["icon"]
        color <- map["color"]
        type <- map["type"]
        createdAt <- map["createdAt"]
        updatedAt <- map["updatedAt"]
        deletedAt <- map["deletedAt"]
    }
}


