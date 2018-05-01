//
//  Account.swift
//  Yod
//
//  Created by eamon on 2018/3/28.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import Foundation
import SQLite



public struct Account {
    /// 账单id
    var id: String = ""
    
    /// 账单类型
    var type: AccountType = .expend
    
    /// 分类
    var category: String = ""
    var categoryType: CategoryType = .none
    
    /// 金额
    var money: Double = 0.00
    
    /// 备注
    var remarks: String = ""
    
    /// 地址
    var address: String = ""

    /// 图片
    var pic: String = ""
    
    /// 创建日期
    var createdAt: String = ""
    
    /// 日期对象
    var date: YodDate!
    
    init(){}
    
    init(dic: [String: AnyObject]) {
        id = "\(dic["id"] as! Int64)"
        type = AccountType(rawValue: dic["type"] as! Int)!
        category = dic["category"] as! String
        if let type = CategoryType(rawValue: category) {
            categoryType = type
        } else {
            categoryType = .none
        }
        money =  dic["money"] as? Double ?? 0.00
        remarks = dic["remarks"] as? String ?? ""
        pic = dic["pic"] as? String ?? ""
        
        createdAt = dic["createdAt"] as! String
        date = YodDate(date: createdAt)
    }
    
    /// 账单类型
    ///
    /// - expend: 支出
    /// - income: 收入
    enum AccountType: Int {
        case expend = 0
        case income
    }
    
    
    /// 分类
    enum CategoryType: String {
        case none            = "未知"
        
        case beauty          = "丽人"
        case clothes         = "服饰"
        case communication   = "通讯"
        case dailygoods      = "日用品"
        case dining          = "用餐"
        case drink           = "酒水"
        case entertainment   = "娱乐"
        case fitness         = "健身"
        case fruit           = "水果"
        case gift            = "礼品"
        case home            = "家居"
        case ingredients     = "食材"
        case learn           = "学习"
        case movement        = "运动"
        case movie           = "电影"
        case normal          = "一般"
        case redPack         = "红包"
        case rent            = "住房"
        case shopping        = "购物"
        case snacks          = "零食"
        case tour            = "旅游"
        case traffic         = "交通"
        case treatment       = "医疗"
        
        
        case investment      = "投资"
        case parttime        = "兼职"
        case wage            = "工资"
        
        /// 获取icon名称
        func iconName() -> String {
            switch self {
            case .beauty:
                return "ic_category_beauty"
            case .clothes:
                return "ic_category_clothes"
            case .communication:
                return "ic_category_communication"
            case .dailygoods:
                return "ic_category_dailygoods"
            case .dining:
                return "ic_category_dining"
            case .drink:
                return "ic_category_drink"
            case .entertainment:
                return "ic_category_entertainment"
            case .fitness:
                return "ic_category_fitness"
            case .fruit:
                return "ic_category_fruit"
            case .gift:
                return "ic_category_gift"
            case .home:
                return "ic_category_home"
            case .ingredients:
                return "ic_category_ingredients"
            case .learn:
                return "ic_category_learn"
            case .movement:
                return "ic_category_movement"
            case .movie:
                return "ic_category_movie"
            case .normal:
                return "ic_category_normal"
            case .redPack:
                return "ic_category_redPack"
            case .rent:
                return "ic_category_rent"
            case .shopping:
                return "ic_category_shopping"
            case .snacks:
                return "ic_category_snacks"
            case .tour:
                return "ic_category_tour"
            case .traffic:
                return "ic_category_traffic"
            case .treatment:
                return "ic_category_treatment"
                
            case .investment:
                return "ic_category_investment"
            case .parttime:
                return "ic_category_parttime"
            case .wage:
                return "ic_category_wage"
                
            default:
                return ""
            }
        }
    }
}

extension String {
    
    func formatAccountType() -> Account.AccountType {
        switch self {
        case "支出":
            return Account.AccountType.expend
        case "收入":
            return Account.AccountType.income
        default:
            return Account.AccountType.expend
        }
    }
}

