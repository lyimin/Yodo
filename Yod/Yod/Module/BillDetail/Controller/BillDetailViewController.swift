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
        
        view.addSubview(contentView)
        
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        YodService.getCategories { (expends, incomes) in
            self.expends = expends
            self.incomes = incomes
            
            self.contentView.categories = (expends, incomes)
        }
    }
    
    convenience init(controllerType: BillDetailControllerType = .created) {
        self.init()
        self.type = controllerType
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent;
    }
    
    //MARK: - Getter | Setter
    
    /// 类型
    private var type: BillDetailControllerType = .created

    /// 内容显示
    private lazy var contentView: BillDetailContentView = {
        
        let contentView = BillDetailContentView(frame: view.bounds)
        contentView.delegate = self
        return contentView
    }()
    
    /// 分类
    private var expends: [Category] = []
    private var incomes: [Category] = []
}

// MARK: - BillDetailContentViewDelegate
extension BillDetailViewController: BillDetailContentViewDelegate {
    
    /// 点击返回
    func backBtnDidClick() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Private Methods
extension BillDetailViewController {
    
    
}
