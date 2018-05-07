//
//  BillDetailViewController.swift
//  Yod
//
//  Created by eamon on 2018/5/7.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

/// 类型
///
/// - created: 创建
/// - edit: 编辑
public enum BillDetailControllerType {
    case created
    case edit
}

class BillDetailViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    convenience init(controllerType: BillDetailControllerType = .created) {
        self.init()
        self.type = controllerType
    }
    
    //MARK: - Getter | Setter
    
    /// 类型
    private var type: BillDetailControllerType = .created

    private lazy var contentView: BillDetailContentView = {
        
        let contentView = BillDetailContentView()
        
        return contentView
    }()
}
