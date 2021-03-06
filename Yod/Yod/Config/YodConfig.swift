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
        
        // 状态栏
        static let statesHeight: CGFloat = UIScreen.main.bounds.height == 812 ? 44 : 20
        // 导航栏
        static let navigationHeight: CGFloat = 64+safeTopHeight
        
        // 顶部安全区域
        static let safeTopHeight: CGFloat = UIScreen.main.bounds.height == 812 ? 24 : 0
        // 底部安全区域
        static let safeBottomHeight: CGFloat = UIScreen.main.bounds.height == 812 ? 34 : 0;
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
        static let blackTitle = rgb(red: 44, green: 58, blue: 88)
        // 深灰色副标题
        static let darkGraySubTitle = rgb(red: 155, green: 155, blue: 155)
        // 浅灰色标题
        static let gary = rgb(red: 200, green: 200, blue: 200)
        // 分割线
        static let sepLine = rgb(red: 216, green: 216, blue: 216)
        // 背景色
        static let background = rgb(red: 229, green: 235, blue: 239)
        // 支出
        static let expend = color.noticeError
        // 收入
        static let income = color.noticeSuccess
        
        static let noticeError = rgb(red: 220, green: 20, blue: 60)
        static let noticeSuccess = rgb(red: 60, green: 179, blue: 113)
        
    }
}

