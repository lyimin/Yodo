//
//  YodoConfig.swift
//  Yodo
//
//  Created by eamon on 2018/3/7.
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
            return UIFont(name: "Helvetica-Bold", size: fontSize)!
        }
        
        static func light(size fontSize: CGFloat) -> UIFont {
            return UIFont(name: "Helvetica-Light", size: fontSize)!
        }
    }
    
    struct color {
        
        static func rgb(red r: CGFloat, green g: CGFloat, blue b: CGFloat, alpha a: CGFloat = 1) -> UIColor {
            return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
        }
        
        // 主题色
        static let theme = UIColor(red: 0, green: 118.0/255, blue: 1, alpha: 1)
        // 黑色标题
        static let blackTitle = UIColor(red: 20/255.0, green: 20/255.0, blue: 20/255.0, alpha: 1)
        // 深灰色副标题
        static let darkGraySubTitle = UIColor(red: 155/255.0, green: 155/255.0, blue: 155/255.0, alpha: 1)
        // 分割线
        static let sepLine = UIColor(red: 216/255.0, green: 216/255.0, blue: 216/255.0, alpha: 1)
        // 背景色
        static let background = UIColor(red: 229/255.0, green: 235/255.0, blue: 239/255.0, alpha: 1)
//        static let expend = 
        
    }
}

