//
//  Double+Yod.swift
//  Yod
//
//  Created by eamon on 2018/7/17.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

extension Double {
    
    public func format() -> String {
        return String(format: "%.2f", self)
    }
    
    public func formatIncome() -> String {
        return "+ \(self.format())"
    }
    
    public func formatExpend() -> String {
        return "- \(self.format())"
    }
}
