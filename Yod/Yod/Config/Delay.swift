//
//  Delay.swift
//  Yod
//
//  Created by eamon on 2018/4/12.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit


func delay(delay: Double, closure: @escaping () -> ()) {
    
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        closure()
    }
}
