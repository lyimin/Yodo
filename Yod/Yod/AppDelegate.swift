//
//  AppDelegate.swift
//  Yod
//
//  Created by eamon on 2018/1/15.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit
import CSV
import GDPerformanceView_Swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        initDB()
        
//        getCSV()
        
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
        
        let manager = AccountHelper.default.manager.createdDB(withName: nil)
        manager.db.busyTimeout = 5
        manager.db.busyHandler { (tries) -> Bool in
            return tries >= 3 ?false :true
        }
        
        manager.createdAccountTable()
    }
    
    private func getCSV() {
        let path = Bundle.main.path(forResource: "20180329_account.csv", ofType: nil)
        
        do {
            let csv = try CSVReader(stream: InputStream(fileAtPath: path!)!, hasHeaderRow: true)
            while let row = csv.next() {
                writeToDB(items: row)
                
            }
        } catch {
            assertionFailure("fail to open csv file")
        }
    }
    
    private func writeToDB(items: [String]) {
        // 创建model
        var model = Account()
        for i in 0..<items.count {
            
            let item = items[i]
            if i == 1 {
                model.type = item.formatAccountType()
            }
            
            else if i == 2 {
                model.category = item
            }
            
            else if i == 3 {
                model.money = Double(item)!
            }
            else if i == 4 {
                model.createdAt = item
            }
            
            else if i == 5 {
                model.remarks = item
            } else {
                continue
            }
        }
        AccountHelper.default.manager.insertAccount(model: model)
    }
}
