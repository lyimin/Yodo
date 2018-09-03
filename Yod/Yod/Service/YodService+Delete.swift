//
//  YodService+Delete.swift
//  Yod
//
//  Created by eamon on 2018/8/30.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import Foundation

// MARK: - Delete
extension YodService {
    
    // 删除账单
    class func deleteAccount(_ account: Account, callBack: @escaping () -> Void) {
        
        guard let id = Int64(account.id) else { return }
        
        DispatchQueue.global().async {
            
            let aManager = SQLManager.default.account!
            aManager.deleteAccount(accountId: id)
            
            DispatchQueue.main.async {
                callBack()
            }
        }
    }
}
