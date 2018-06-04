//
//  YodConst.swift
//  Yod
//
//  Created by eamon on 2018/6/4.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

public enum TouchAction {
    case selection
    case notification
}

public func shake(action: TouchAction) {
    
    if #available(iOS 10.0, *) {
        switch action {
        case .selection:
            
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
            
        default:
            break
        }
    }
}
