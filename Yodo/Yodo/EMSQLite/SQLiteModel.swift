//
//  SQLiteModel.swift
//  Yodo
//
//  Created by 梁亦明 on 2018/3/9.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import Foundation

public protocol SQLiteModel {
    
    /// 主键
    func primaryKey() -> String?
    
    
    /// 忽略的key
    func ignoreKeys() -> [String]?
}