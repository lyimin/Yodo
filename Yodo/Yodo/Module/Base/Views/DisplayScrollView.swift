//
//  DisplayScrollView.swift
//  Yodo
//
//  Created by eamon on 2018/4/23.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

public protocol DisplayScrollViewDataSrouce: NSObjectProtocol {
    
    func numberOfContentView() -> Int
    
}

// TODO
class DisplayScrollView: UIScrollView {

    weak open var ds: DisplayScrollViewDataSrouce?
}
