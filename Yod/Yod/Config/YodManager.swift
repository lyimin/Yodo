//
//  YodManager.swift
//  Yod
//
//  Created by eamon on 2018/5/8.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

public class YodManager {
    
    public init() {}
    
    /// 单例对象
    public static let `default`: YodManager = {
        let manager = YodManager()
        return manager
    }()
    
    /// app是否第一次启动
    public func isFirstLoad() -> Bool {
        
        let info = Bundle.main.infoDictionary as [String: AnyObject]?
        if let info = info {
            let currentVersion = info["CFBundleShortVersionString"] as! String
            
            let lastVersion = UserDefaults.standard.object(forKey: LAST_RUN_VERSION_KEY) as! String?
            if lastVersion == nil || lastVersion! != currentVersion {
                UserDefaults.standard.set(lastVersion, forKey: LAST_RUN_VERSION_KEY)
                return true
            }
        }
        
        return false
    }
    
    private let LAST_RUN_VERSION_KEY = "LAST_RUN_VERSION_KEY"
}
