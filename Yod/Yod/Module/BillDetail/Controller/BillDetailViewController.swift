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
            self.contentView.currentCategory = expends.first
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = coordinator
        // 添加滑动手势
        let pan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(panGesture(pan:)))
        pan.edges = .left
        view.addGestureRecognizer(pan)
    }
    
    convenience init(controllerType: BillDetailControllerType = .created) {
        self.init()
        self.type = controllerType
    }
    
    
    //MARK: - Getter | Setter
    
    /// 状态栏颜色
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent;
    }
    
    /// 执行动画对象,手势驱动
    private let coordinator = TransitionCoordinator()
    private var percentDrivenTransition: UIPercentDrivenInteractiveTransition?
    
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
    
    /// 点击日历
    func calendarItemDidClick(date: YodDate) {
        
        let calendarView = YodCalendarView(frame: view.bounds)
        view.addSubview(calendarView)
    }
    
    /// 点击支出，收入
    func typeBtnDidClick(currentType: CategoryType) {
        if currentType == CategoryType.expend {
            contentView.categories = expends
            contentView.currentCategory = expends.first
        } else {
            contentView.categories = incomes
            contentView.currentCategory = incomes.first
        }
    }
    
    /// 点击某个分类
    func categoryItemDidClick(category: Category) {
        contentView.currentCategory = category
    }
    
    /// 点击返回
    func backBtnDidClick() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Event | Action
extension BillDetailViewController {
    
    @objc private func panGesture(pan: UIScreenEdgePanGestureRecognizer) {
        
        let progress = pan.translation(in: view).x / view.width
        
        if pan.state == .began {
            percentDrivenTransition = UIPercentDrivenInteractiveTransition()
            coordinator.setPercentDrivenTransition(percentDrivenTransition: percentDrivenTransition)
            navigationController?.popViewController(animated: true)
        } else if pan.state == .changed {
            percentDrivenTransition!.update(progress)
        } else if pan.state == .ended {
            if progress > 0.4 {
                percentDrivenTransition?.finish()
            } else {
                percentDrivenTransition?.cancel()
            }
            percentDrivenTransition = nil
        }
    }
}

// MARK: - CircleTransitionable
extension BillDetailViewController: CircleTransitionable, UINavigationControllerDelegate  {
    
    var triggerButton: UIButton {
        return saveBtn
    }
    
    var mainView: UIView {
        return view
    }
    
    var movingViews: [UIView]? {
        return contentView.cardView.subviews
    }
}
