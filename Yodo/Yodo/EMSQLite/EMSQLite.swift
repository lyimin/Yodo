//
//  EMSQLite.swift
//  Yodo
//
//  Created by eamon on 2018/3/9.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import Foundation
import SQLite


public func createdDB(databaseName name: String?) -> Manager {
    
    return Manager.default.createdDB(withName: name)
}

