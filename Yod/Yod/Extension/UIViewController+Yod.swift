//
//  UIViewController+Yod.swift
//  Yod
//
//  Created by eamon on 2018/7/20.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    
    func showAlert(title: String? = nil, msg: String?, cancelBtn: String = "取消", otherBtn: String? = nil, handler:((UIAlertAction) -> Void)?) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelBtn, style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        if let other = otherBtn {
            let otherAction = UIAlertAction(title: other, style: .default, handler: handler)
            alert.addAction(otherAction)
        }
        present(alert, animated: true, completion: nil)
    }
    
    func showSheet(title: String? = nil, msg: String?, cancelBtn: String = "取消", otherBtn: String? = nil, handler:((UIAlertAction) -> Void)?) {
        
        let sheet = UIAlertController(title: title, message: msg, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: cancelBtn, style: .cancel, handler: nil)
        sheet.addAction(cancelAction)
        
        if let other = otherBtn {
            let otherAction = UIAlertAction(title: other, style: .destructive, handler: handler)
            sheet.addAction(otherAction)
        }
        
        present(sheet, animated: true, completion: nil)
    }
}
