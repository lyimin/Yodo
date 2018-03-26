//
//  AppDelegate.swift
//  Yodo
//
//  Created by 梁亦明 on 2018/1/15.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        initDB()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = HomeViewController()
        
        return true
    }
}

extension AppDelegate {
    
    /// 初始化db
    private func initDB() {
        

        
        let dbManager = createdDB(databaseName: nil)
        dbManager.db.busyTimeout = 5
        dbManager.db.busyHandler { (tries) -> Bool in
            return tries >= 3 ?false :true
        }
    }
}
