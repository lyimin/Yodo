//
//  EMMirrorModel.swift
//  Yodo
//
//  Created by 梁亦明 on 2018/3/28.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import Foundation

struct EMMirrorModel {
    
    /// 主键
    public var primaryKey: String?
    
    /// 属性个数
    public var propretiesNum: Int64
    
    /// 保存属性名称和类型[""]
    public var propreties: [String: Any.Type]?
   
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
        var propreties: [String: Any.Type] = [String: Any.Type]()
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
                propreties[name] = vMirror.subjectType
            }
        }
        out.propreties = propreties
        return out
    }
}
