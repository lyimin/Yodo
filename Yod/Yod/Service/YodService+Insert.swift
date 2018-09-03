//
//  YodService+Insert.swift
//  Yod
//
//  Created by eamon on 2018/8/30.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import Foundation

// MARK: - Insert
extension YodService {
    
    // 添加账单
    class func insertAccount(_ account: Account, callBack: @escaping () -> Void) {
        
        DispatchQueue.global().async {
            let dao = account.toDao()
            let aManager = SQLManager.default.account!
            aManager.insertAccount(model: dao)
            
            DispatchQueue.main.async {
                callBack()
            }
        }
    }
}
