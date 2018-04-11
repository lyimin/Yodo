//
//  YodoConfig.swift
//  Yodo
//
//  Created by 梁亦明 on 2018/3/7.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import Foundation
import UIKit

struct YodoConfig {
    
    /// 布局
    struct frame {
        
        // 导航栏边距
        static let nvIconMarginBorder: CGFloat = 20
        static let nvIconMarginTop: CGFloat = 35
        static let nvIconMarginLeft: CGFloat = 10
    }
    
    
    struct font {
        
        // 首页标题
        static let homeTitle = UIFont.boldSystemFont(ofSize: 20)
        
        static func bold(size fontSize: CGFloat) -> UIFont {
            return UIFont.boldSystemFont(ofSize:fontSize)
        }
    }
    
    struct color {
        
        // 黑色标题
        static let blackTitle = UIColor(red: 20/255.0, green: 20/255.0, blue: 20/255.0, alpha: 1)
        // 深灰色副标题
        static let darkGraySubTitle = UIColor(red: 155/255.0, green: 155/255.0, blue: 155/255.0, alpha: 1)
        // 分割线
        static let sepLine = UIColor(red: 216/255.0, green: 216/255.0, blue: 216/255.0, alpha: 1)
        // 背景色
        static let backgroundColor = UIColor(red: 229/255.0, green: 235/255.0, blue: 239/255.0, alpha: 1)
        
    }
}

