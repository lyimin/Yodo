//
//  AppDelegate.swift
//  Yod
//
//  Created by eamon on 2018/1/15.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit
import GDPerformanceView_Swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        initDB()
        sleep(1)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = HomeViewController()
        
        GDPerformanceMonitor.sharedInstance.startMonitoring()
        GDPerformanceMonitor.sharedInstance.appVersionHidden = true
        GDPerformanceMonitor.sharedInstance.deviceVersionHidden = true
        
        return true
    }
}

extension AppDelegate {
    
    /// 初始化db
    private func initDB() {
        
        if YodManager.default.isFirstLoad() {
            
            let manager = SQLManager.default.createdDB(withName: nil)
            
            manager.db.busyTimeout = 5
            manager.db.busyHandler { (tries) -> Bool in
                return tries >= 3 ?false :true
            }
            
            // 删除table重新创建
            manager.account.deleteTable()
            manager.category.deleteTable()
            
            manager.account.createdAccountTable()
            manager.category.createdCategoryTable()
            
            // 添加分类
            manager.category.loadCategories()
            
            // 添加账单
            manager.account.loadCSV()
        }
    }
}
