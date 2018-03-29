//
//  AppDelegate.swift
//  Yodo
//
//  Created by 梁亦明 on 2018/1/15.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit
import CSV

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        initDB()
        
        getCSV()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = HomeViewController()
        
        return true
    }
}

extension AppDelegate {
    
    /// 初始化db
    private func initDB() {
        
        let manager = createdDB(databaseName: nil)
        manager.db.busyTimeout = 5
        manager.db.busyHandler { (tries) -> Bool in
            return tries >= 3 ?false :true
        }
        
//        manager.createdAccountTable()
        manager.createTable(withName: "abc", model: Account())
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
                model.createdAt = item.formatAccountDate()
            }
            
            else if i == 5 {
                model.remarks = item
            } else {
                continue
            }
        }
        Manager.default.insert(withTable: account, model: model)
    }
}
