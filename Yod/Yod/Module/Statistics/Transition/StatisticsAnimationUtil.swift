//
//  StatisticsAnimationUtil.swift
//  Yod
//
//  Created by eamon on 2018/8/30.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

class StatisticsAnimationUtil: NSObject {

    class func animate(withYearLabel label: UILabel, text: String) {
        
        let translationY: CGFloat = label.height*0.5
        // 隐藏
        UIView.animate(withDuration: 0.15, animations: {
            
            label.alpha = 0
            label.transform = CGAffineTransform(translationX: 0, y: -translationY)
            
        }) { (finished) in
            // 显示
            label.text = text
            label.transform = CGAffineTransform(translationX: 0, y: translationY*2)
            
            UIView.animate(withDuration: 0.15, animations: {
                label.transform = .identity
                label.alpha = 1
            })
        }
    }
}
