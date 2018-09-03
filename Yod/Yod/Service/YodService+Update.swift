//
//  YodService+Update.swift
//  Yod
//
//  Created by eamon on 2018/8/30.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import Foundation

// MARK: - Update
extension YodService {
    
    /// 更新账单
    class func updateAccount(_ account: Account, callBack: @escaping () -> Void) {
        
        DispatchQueue.global().async {
            
            let dao = account.toDao()
            let aManager = SQLManager.default.account!
            aManager.updateAccount(model: dao)
            
            DispatchQueue.main.async {
                callBack()
            }
        }
    }
}
