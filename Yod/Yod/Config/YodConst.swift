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
    case error
    case warning
    case success
    case light
    case medium
    case heavy
}

// 震动
public func shake(action: TouchAction) {
    
    if #available(iOS 10.0, *) {
        switch action {
            
        case .selection:
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
            break
            
        case .error:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            break
            
        case .warning:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
            break
            
        case .success:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            break
            
        case .light:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            break
            
        case .medium:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            break
            
        case .heavy:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            break
        }
    }
}
