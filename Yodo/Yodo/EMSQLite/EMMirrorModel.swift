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
    
    public var express: Expressible?
    
    /// sqlite.swift的setter对象
    public var setter: SQLite.Setter?
    
    public init(name: String, isPrimaryKey: Bool = defaultIsPrimaryKey, value: Any? = nil, type: Any.Type) {
        self.name = name
        self.isPrimaryKey = isPrimaryKey
        self.value = value
        self.type = type
        self.express = getExpress(withType: type, key: name)
        self.setter = getSQLiteSetter()
    }
    
    private func getExpress(withType: Any.Type, key: String) -> Expressible {
 
        if type is Int.Type   || type is Int8.Type  ||
            type is Int16.Type || type is Int32.Type ||
            type is Int64.Type {
            return Expression<Int64>(key)
        } else if type is Float.Type || type is Float?.Type ||
            type is Double.Type || type is Double?.Type {
            return Expression<Double>(key)
        } else if type is Bool.Type {
            return Expression<Bool>(key)
        } else {
            return Expression<String>(key)
        }
        
    }
    
    private func getSQLiteSetter() -> SQLite.Setter? {
        
        guard value != nil else {
            return nil
        }
        
        if type is Int.Type   || type is Int8.Type  ||
           type is Int16.Type || type is Int32.Type ||
           type is Int64.Type {
            return express as! Expression<Int64> <- value as! Int64
        } else if type is Float.Type || type is Float?.Type ||
            type is Double.Type || type is Double?.Type {
            return express as! Expression<Double> <- value as! Double
        } else if type is Bool.Type {
            return express as! Expression<Bool> <- value as! Bool
        } else {
            return express as! Expression<String> <- value as! String
        }
    }
    
    func filter() -> Expression<Bool> {
        if type is Int.Type   || type is Int8.Type  ||
            type is Int16.Type || type is Int32.Type ||
            type is Int64.Type {
            return express as! Expression<Int64> == value as! Int64
        } else if type is Float.Type || type is Float?.Type ||
            type is Double.Type || type is Double?.Type {
            return express as! Expression<Double> == value as! Double
        } else if type is Bool.Type {
            return express as! Expression<Bool> == value as! Bool
        } else {
            return express as! Expression<String> == value as! String
        }
    }
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
