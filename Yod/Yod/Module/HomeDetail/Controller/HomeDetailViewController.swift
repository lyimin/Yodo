//
//  HomeDetailViewController.swift
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
public enum HomeDetailControllerType {
    case created
    case edit
}

protocol HomeDetailViewControllerDelegate: NSObjectProtocol {
    
    /// 回调给首页控制器
    func accountDidChange(type: HomeDetailControllerType, account: Account)
}

class HomeDetailViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        YodService.getCategories { [weak self](expends, incomes) in
            
            guard let strongSelf = self else { return }
            
            strongSelf.expends = expends
            strongSelf.incomes = incomes
            
            strongSelf.initAccount(incomes: incomes, expends: expends)
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
    
    convenience init(controllerType: HomeDetailControllerType = .created) {
        self.init()
        self.type = controllerType
    }
    
    
    //MARK: - Getter | Setter
    
    public weak var delegate: HomeDetailViewControllerDelegate?
    
    public var account: Account!
    
    /// 状态栏颜色
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent;
    }
    
    /// 执行动画对象,手势驱动
    private let coordinator = TransitionCoordinator()
    private var percentDrivenTransition: UIPercentDrivenInteractiveTransition?
    
    /// 类型
    private var type: HomeDetailControllerType = .created

    /// 内容显示
    private lazy var contentView: HomeDetailContentView = {
        
        let contentView = HomeDetailContentView(frame: view.bounds)
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

// MARK: - HomeDetailContentViewDelegate
extension HomeDetailViewController: HomeDetailContentViewDelegate {
    
    /// 点击支出，收入
    func typeBtnDidClick(headerView: HomeDetailHeaderView, currentType: CategoryType) {
        if currentType == CategoryType.expend {
            contentView.categories = expends
            account.type = .expend
            account.category = expends.first
            
            headerView.typeControlDidSelected(btn: headerView.typeControl.expendBtn, accountType: account.type)
            headerView.iconChangeAnimate(icon: account.category.icon, color: account.category.color)
        } else {
            contentView.categories = incomes
            account.type = .income
            account.category = incomes.first
            
            headerView.typeControlDidSelected(btn: headerView.typeControl.incomeBtn, accountType: account.type)
            headerView.iconChangeAnimate(icon: account.category.icon, color: account.category.color)
        }
    }
    
    
    /// 点击备注
    func noteItemDidClick(item: HomeDetailItem, content: String) {
        
        let noteView = HomeDetailNoteView(frame: view.bounds)
        noteView.content = content
        view.addSubview(noteView)
        noteView.show()
        
        noteView.callBack = { [unowned self] (text: String) -> Void in
            self.account.remarks = text
            item.descLabel.text = text == "" ? "无" : text
        }
    }
    
    /// 点击日历
    func calendarItemDidClick(item: HomeDetailItem, date: YodDate) {
        
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
    func priceDidChange(headerView: HomeDetailHeaderView, price: String) {
        account.money = Double(price)!
        
        headerView.textField.text = account.type == .expend ? account.money.formatExpend() : account.money.formatIncome()
    }
    
    /// 点击某个分类
    func categoryItemDidClick(cardView: HomeDetailCardView, category: Category) {
        
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
        dismiss()
    }
}

// MARK: - Event | Action
extension HomeDetailViewController {
    
    /// 点击保存
    @objc private func saveBtnDidClick() {
        if account.money == 0 {
            noticeError("请填写金额💰💰")
            return 
        }
        
        if type == .created {
            // 添加数据到数据库
            insertAction()
        } else {
            updateAction()
        }
        
        delay(delay: 1, closure: {
            self.dismiss()
        })
    }
    
    private func dismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    // 添加
    private func insertAction() {
        YodService.insertAccount(account) {
            
            self.noticeSuccess("添加成功🎉🎉")
            if let delegate = self.delegate {
                delegate.accountDidChange(type: self.type, account: self.account)
            }
        }
    }
    
    private func updateAction() {
        YodService.updateAccount(account) {
            
            self.noticeSuccess("修改成功🎉🎉")
            if let delegate = self.delegate {
                delegate.accountDidChange(type: self.type, account: self.account)
            }
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

// MARK: - PrivateMethods
extension HomeDetailViewController {
    
    // init account model
    private func initAccount(incomes: [Category], expends: [Category]) {
        
        
        var category: Category!
        if type == .created, expends.count > 0 {
            account = Account()
            category = expends.first
        } else {
            if account.type == .expend {
                category = expends.filter {
                    $0.id == account.category.id
                    }.first
            } else {
                category = incomes.filter {
                    $0.id == account.category.id
                    }.first
            }
        }
        
        account.category = category
        
        if account.type == .expend {
            self.contentView.categories = expends
        } else {
            self.contentView.categories = incomes
        }
        contentView.account = account
    }
    
    private func initView() {
        
        view.addSubview(contentView)
        view.addSubview(saveBtn)
        
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        saveBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 130, height: 35))
            make.bottom.equalTo(self.view).offset(-(30+YodConfig.frame.safeBottomHeight))
            make.centerX.equalTo(self.view)
        }
    }
}

// MARK: - CircleTransitionable
extension HomeDetailViewController: CircleTransitionable, UINavigationControllerDelegate  {
    
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
