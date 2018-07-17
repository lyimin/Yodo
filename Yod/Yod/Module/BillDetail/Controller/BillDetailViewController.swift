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
        
        YodService.getCategories { [unowned self](expends, incomes) in
            self.expends = expends
            self.incomes = incomes
            
            self.contentView.categories = expends
            
            if let normalCategory = expends.first {
                self.initAccount(withCategory: normalCategory)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = coordinator
        // 添加滑动手势
//        let pan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(panGesture(pan:)))
//        pan.edges = .left
//        view.addGestureRecognizer(pan)
    }
    
    convenience init(controllerType: BillDetailControllerType = .created) {
        self.init()
        self.type = controllerType
    }
    
    
    //MARK: - Getter | Setter
    
    public var account: Account!
    
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
        saveBtn.addTarget(self, action: #selector(saveBtnDidClick), for: .touchUpInside)
        return saveBtn
    }()
    
    /// 分类
    private var expends: [Category] = []
    private var incomes: [Category] = []
}

// MARK: - BillDetailContentViewDelegate
extension BillDetailViewController: BillDetailContentViewDelegate {
    
    /// 点击支出，收入
    func typeBtnDidClick(headerView: BillDetailHeaderView, currentType: CategoryType) {
        if currentType == CategoryType.expend {
            contentView.categories = expends
            account.type = .expend
            account.category = expends.first
            
            headerView.typeControlDidSelected(btn: headerView.typeControl.expendBtn, accountType: account.type)
        } else {
            contentView.categories = incomes
            account.type = .income
            account.category = incomes.first
            
            headerView.typeControlDidSelected(btn: headerView.typeControl.incomeBtn, accountType: account.type)
        }
        
        shake(action: .selection)
    }
    
    
    /// 点击备注
    func noteItemDidClick(item: BillDetailItem, content: String) {
        
        let noteView = BillDetailNoteView(frame: view.bounds)
        noteView.content = content
        view.addSubview(noteView)
        noteView.show()
        
        noteView.callBack = { [unowned self] (text: String) -> Void in
            self.account.remarks = text
            item.descLabel.text = text
        }
    }
    
    /// 点击日历
    func calendarItemDidClick(item: BillDetailItem, date: YodDate) {
        
        let calendarView = YodCalendarView(frame: view.bounds)
        view.addSubview(calendarView)
        calendarView.show()
        
        calendarView.callBack = { [unowned self](date: YodDate) -> Void in
            self.account.date = date
            self.account.createdAt = date.description
            item.descLabel.text = date.gobalDesc
        }
    }
    
    /// 金额改变
    func priceDidChange(headerView: BillDetailHeaderView, price: String) {
        account.money = Double(price)!
        
        headerView.textField.text = account.type == .expend ? account.money.formatExpend() : account.money.formatIncome()
    }
    
    /// 点击某个分类
    func categoryItemDidClick(cardView: BillDetailCardView, category: Category) {
        
        account.category = category
        
        let headerView = self.contentView.headerView
        UIView.animate(withDuration: 0.3) {
            headerView.backgroundColorView.backgroundColor = UIColor(hexString: category.color)
            headerView.iconView.image = UIImage(named: category.icon)
        }
        
        shake(action: .selection)
    }
    
    /// 点击返回
    func backBtnDidClick() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Event | Action
extension BillDetailViewController {
    
    /// 点击保存
    @objc private func saveBtnDidClick() {
        if account.money == 0 {
            
        }
    }
    
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

extension BillDetailViewController {
    
    // init account model
    private func initAccount(withCategory category: Category) {
        account = Account()
        account.category = category
        
        contentView.account = account
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
