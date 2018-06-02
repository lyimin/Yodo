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
        view.addSubview(saveBtn)
        
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        saveBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 130, height: 35))
            make.bottom.equalTo(self.view).offset(-30)
            make.centerX.equalTo(self.view)
        }
        
        YodService.getCategories { (expends, incomes) in
            self.expends = expends
            self.incomes = incomes
            
            self.contentView.categories = expends
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
    
    /// 保存
    private lazy var saveBtn: UIButton = {
        
        var saveBtn = UIButton()
        saveBtn.setTitle("保存", for: .normal)
        saveBtn.setTitleColor(.white, for: .normal)
        saveBtn.titleLabel?.font = YodConfig.font.bold(size: 16)
        saveBtn.backgroundColor = YodConfig.color.theme
        saveBtn.layer.cornerRadius = 17.5
        return saveBtn
    }()
    
    /// 分类
    private var expends: [Category] = []
    private var incomes: [Category] = []
}

// MARK: - BillDetailContentViewDelegate
extension BillDetailViewController: BillDetailContentViewDelegate {
    
    /// 点击支出，收入
    func typeBtnDidClick(currentType: CategoryType) {
        if currentType == CategoryType.expend {
            contentView.categories = expends
        } else {
            contentView.categories = incomes
        }
    }
    
    
    /// 点击返回
    func backBtnDidClick() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Private Methods
extension BillDetailViewController: CircleTransitionable {
    var triggerButton: UIButton {
        return saveBtn
    }
    
    var mainView: UIView {
        return view
    }
}
