//
//  EMSQLite.swift
//  Yodo
//
//  Created by 梁亦明 on 2018/3/9.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import Foundation
import SQLite


public func createdDB(databaseName name: String?) -> Manager {
    
    return Manager.default.createdDB(withName: name)
}

