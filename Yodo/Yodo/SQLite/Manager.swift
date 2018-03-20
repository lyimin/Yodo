//
//  Manager.swift
//  Yodo
//
//  Created by 梁亦明 on 2018/3/9.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import Foundation



public let docName = "com.eamon.EMSQLite"

public class Manager {
    
    public static let `default`: Manager = {
       
        return Manager(path: "")
    }()
    
    public var path: String
    
    public typealias pathClosure = (String?, String) -> String
    
    public final class func defaultDBPathClosure(path: String?, name: String) -> String {
        let rootPath = path ?? NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        return (rootPath as NSString).appendingPathComponent(name)
    }
    
    public init(path: String? = nil) {
        
        
        
    }
    
    public func createDB(withName name: String) {
        
    }
    
}
