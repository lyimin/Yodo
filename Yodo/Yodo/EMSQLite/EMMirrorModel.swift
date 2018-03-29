//
//  EMMirrorModel.swift
//  Yodo
//
//  Created by 梁亦明 on 2018/3/28.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import Foundation
import SQLite

struct EMMirrorProprety {
    
    private static let defaultIsPrimaryKey = false
    
    /// 是否是主键
    public var isPrimaryKey: Bool
    
    /// 属性名称
    public var name: String
    
    /// 属性值
    public var value: Any?
    
    /// 属性类型
    public var type: Any.Type
    
    /// sqlite.swift的setter对象
    public var setter: SQLite.Setter?
    
    
    
    
    public init(name: String, isPrimaryKey: Bool = defaultIsPrimaryKey, value: Any? = nil, type: Any.Type) {
        self.name = name
        self.isPrimaryKey = isPrimaryKey
        self.value = value
        self.type = type
    }
    
//    private func getSQLiteSetter(withType type: Any.Type, withValue value: Any?) -> SQLite.Setter {
//        
//        if type is Int.Type {
//            return Expression<Int64> <- value as? Int64
//        }
//    }
}

struct EMMirrorModel {
    
    /// 主键
    public var primaryKey: String?
    
    /// 属性个数
    public var propretiesNum: Int64 = 0
    
    /// 保存属性名称和类型[""]
    public var propreties: [EMMirrorProprety] = [EMMirrorProprety]()
    
    
    init(primaryKey: String? = nil, propretiesNum: Int64 = 0) {
        self.primaryKey = primaryKey
        self.propretiesNum = propretiesNum
    }
}

extension EMMirrorModel {
    
    public static func reflecting<T: SQLiteModel>(model: T) -> EMMirrorModel? {
        
        let mirror = Mirror(reflecting: model)
        
        guard mirror.children.count > 0 else {
            assertionFailure("[EMSQLite] the numbre of '\(mirror.subjectType)' model propreties is 0")
            return nil
        }
        
        let childCount = mirror.children.count
        var propreties: [EMMirrorProprety] = [EMMirrorProprety]()
        var out = EMMirrorModel(propretiesNum: childCount)
        
        for m in mirror.children {
            
            if let name = m.label {
                let vMirror = Mirror(reflecting: m.value)
                
                if let primaryKey = model.primaryKey(), primaryKey == name {
                    out.primaryKey = primaryKey
                }
                
                if let ignoreKey = model.ignoreKeys(), ignoreKey.count > 0 {
                    if ignoreKey.contains(name) { continue }
                }
                debugPrint("属性:\(name) 类型：\(vMirror.subjectType) t:\(String(describing: vMirror.displayStyle))")
                
                let proprety = EMMirrorProprety(name: name, isPrimaryKey: name == model.primaryKey(), type: vMirror.subjectType)
                propreties.append(proprety)
            }
        }
        out.propreties = propreties
        return out
    }
}
