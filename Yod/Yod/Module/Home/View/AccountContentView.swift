//
//  AccountContentView.swift
//  Yod
//
//  Created by eamon on 2018/4/24.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit
import ViewAnimator
import SwipeCellKit

protocol AccountContentViewDelegate: NSObjectProtocol {
    /// 点击删除按钮
    func accountContentView(_ contentView: AccountContentView, itemDeleted withIndexPath: IndexPath, callBack: @escaping  (_ isDelete: Bool) -> Void)
}

/// 首页每月的数据
class AccountContentView: UIView {
    
    weak var delegate: AccountContentViewDelegate?
    
    //MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(tableView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds
        
        if editIndexPath != nil {
//            configSwipeButtons()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var editIndexPath: IndexPath?
    
    //MARK: - Getter | Setter
    /// 列表
    private(set) lazy var tableView: UITableView = {
        
        var tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.backgroundColor = YodConfig.color.background
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 60
        tableView.tableHeaderView = headerView
        tableView.register(HomeItemCell.self, forCellReuseIdentifier: HomeItemCell.reuseIdentifier)
        
        return tableView
    }()
    
    var date: YodDate! {
        didSet {
            loadingMonthDate()
        }
    }
    
    var monthModel: HomeMonthModel? {
        didSet {
            if let monthModel = monthModel {
                
                headerView.expendMoney = monthModel.expend
                headerView.expendMonth = monthModel.date.month
                headerView.incomeMoney = monthModel.income
                headerView.incomeMonth = monthModel.date.month
            }
        }
    }
    
    /// 列表顶部view
    private lazy var headerView: HomeHeaderView = {
        let headerView = HomeHeaderView(frame: CGRect(x: 0, y: 0, width: width-40, height: 120))
        return headerView
    }()
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension AccountContentView: UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        if orientation != .right { return nil }
        
        let action = SwipeAction(style: .default, title: nil) { (_, indexPath) in
            
            guard let delegate = self.delegate else {
                return
            }
            
            delegate.accountContentView(self, itemDeleted: indexPath, callBack: {
                if $0 { self.deleteAction(indexPath: indexPath) }
            })
        }
        action.backgroundColor = YodConfig.color.background
        action.image = #imageLiteral(resourceName: "ic_home_delete")
        
        return [action]
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if monthModel == nil {
            return 0
        }
        
        return monthModel!.dailyModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monthModel!.dailyModels[section].accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rowData = monthModel!.dailyModels[indexPath.section].accounts[indexPath.row]
        let cell = HomeItemCell.cell(withTableView: tableView, indexPath: indexPath)
        cell.delegate = self
        cell.account = rowData
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if monthModel == nil { return nil }
        
        var headerView = tableView.dequeueReusableHeaderFooterView() as HomeItemSectionView?
        if headerView == nil {
            headerView = HomeItemSectionView(reuseIdentifier: HomeItemSectionView.reuseIdentifier)
        }
        headerView!.dailyModel = monthModel!.dailyModels[section]
        return headerView!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HomeItemSectionView.sectionViewHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let cell = cell as! HomeItemCell
        cell.content.backgroundColor = UIColor.clear
        
        let rect = CGRect(x: 20, y: 0, width: width-40, height: 60)
        
        // 获取path
        let path = sectionBackgroundPath(cell: cell, indexPath: indexPath, rect: rect)
        
        // 创建layer
        let layer = createCellLayer(path: path, indexPath: indexPath)
        
        let backgroundView = UIView(frame: rect)
        backgroundView.backgroundColor = .clear
        backgroundView.layer.insertSublayer(layer, at: 0)
        cell.backgroundView = backgroundView
    }
}

// MARK: - Private Methods
extension AccountContentView {
    
    
    /// 点击删除操作
    ///
    /// - Parameter indexPath: indexPath
    private func deleteAction(indexPath: IndexPath) {
        
        let deleteModel = monthModel!.dailyModels[indexPath.section].accounts[indexPath.row]
        if deleteModel.type == .expend {
            let expendPrice = monthModel!.expend.double()! - deleteModel.money
            monthModel?.expend = expendPrice.format()
        } else {
            let incomePrice = monthModel!.income.double()! - deleteModel.money
            monthModel?.income = incomePrice.format()
        }
        
        if monthModel!.dailyModels[indexPath.section].accounts.count == 1 {
            
            monthModel!.dailyModels.remove(at: indexPath.section)
            tableView.deleteSections([indexPath.section], with: .fade)
            
        } else {
            
            monthModel!.dailyModels[indexPath.section].accounts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    /// 根据cell去绘制section的圆角
    ///
    /// - Parameter cell: cell
    /// - Returns: 返回绘制cell的路径
    private func sectionBackgroundPath(cell: HomeItemCell, indexPath: IndexPath, rect: CGRect) -> UIBezierPath {
        
        let cornerRadiusSize = CGSize(width: 5, height: 5)
        let numberOfRows = tableView.numberOfRows(inSection: indexPath.section)
        
        var path: UIBezierPath
        if indexPath.row == 0 && numberOfRows == 1 {
            // 一个为一组时，四个角都为圆角
            path = UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: cornerRadiusSize)
        } else if (indexPath.row == 0) {
            // 为组的第一行时，左上、右上角为圆角
            path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: cornerRadiusSize)
        } else if (indexPath.row == numberOfRows - 1) {
            path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: cornerRadiusSize)
        } else {
            path = UIBezierPath(rect: rect)
        }
        
        return path
    }
    
    /// 创建cell的图层
    ///
    /// - Parameter indexPath: 索引
    /// - Returns: 返回cell的背景图片
    private func createCellLayer(path: UIBezierPath, indexPath: IndexPath) -> CALayer {
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = UIColor.white.cgColor
        
        let numberOfRows = tableView.numberOfRows(inSection: indexPath.section)
        
        // 设置阴影
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.1
        layer.shadowColor = UIColor.lightGray.cgColor
        
        if indexPath.row == 0 && numberOfRows == 1 {
            layer.shadowOffset = CGSize(width: 3, height: 3)
        } else if (indexPath.row == 0) {
            layer.shadowOffset = CGSize(width: 3, height: -1)
        } else if (indexPath.row == numberOfRows - 1) {
            layer.shadowOffset = CGSize(width: 3, height: 3)
        } else {
            layer.shadowOffset = CGSize(width: 3, height: -1)
        }
        
        return layer
    }
    
    /// 执行动画
    private func cellsOffsetAnimation() {
        
        let visibleCells = tableView.visibleCells
        if visibleCells.count == 0 { return }
        
        var animateViews: [UIView] = []
        animateViews.append(headerView)
        for visibleCell in visibleCells {
            
            // 添加headerView
            if let indexPath = tableView.indexPath(for: visibleCell) {
                if let headerView = tableView.headerView(forSection: indexPath.section) {
                    if !animateViews.contains(headerView) {
                        animateViews.append(headerView)
                    }
                }
            }
            
            // 添加cell
            animateViews.append(visibleCell)
        }
        
        let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
        UIView.animate(views: animateViews, animations: animations)
    }
    
    /// 加载当月的数据
    private func loadingMonthDate() {
        
        if let date = date {
            
            tableView.isHidden = true
            showProgress()
            
            YodService.getMonthData(withYodDate: date) {
                
                self.monthModel = $0
                
                self.hiddenProgress()
                self.tableView.isHidden = false
                self.tableView.reloadData()
                self.cellsOffsetAnimation()
            }
        }
    }
}
