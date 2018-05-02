//
//  YodConfig.swift
//  Yod
//
//  Created by eamon on 2018/3/7.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import Foundation
import UIKit

struct YodConfig {
    
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
        static let theme = rgb(red: 0, green: 118, blue: 255)
        // 黑色标题
        static let blackTitle = rgb(red: 20, green: 20, blue: 20)
        // 深灰色副标题
        static let darkGraySubTitle = rgb(red: 155, green: 155, blue: 155)
        // 分割线
        static let sepLine = rgb(red: 216, green: 216, blue: 216)
        // 背景色
        static let background = rgb(red: 229, green: 235, blue: 239)
        // 支出
        static let expend = rgb(red: 234, green: 84, blue: 80)
        // 收入
        static let income = rgb(red: 105, green: 205, blue: 203)
        
    }
}

