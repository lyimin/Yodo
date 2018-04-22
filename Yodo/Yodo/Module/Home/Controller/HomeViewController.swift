//
//  File.swift
//  Yodo
//
//  Created by eamon on 2018/3/2.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit
import ViewAnimator

class HomeViewController: BaseViewController {
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(navigationView)
        view.addSubview(tableView)
        
        navigationView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(145)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(navigationView.snp.bottom)
        }
                
        let dates = viewM.getDateDataSource()
        navigationView.dates = dates
    }
   
    
    // MARK: - Getter | Setter
    private lazy var dataSource: [AccountDailyModel] = []
    
    /// 导航栏
    private lazy var navigationView: HomeNavigationView = {
        
        var navigationView = HomeNavigationView()
        navigationView.delegate = self
        return navigationView
    }()
     
    /// 列表
    private lazy var tableView: UITableView = {
        
        var tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.backgroundColor = YodoConfig.color.backgroundColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 60
        tableView.tableHeaderView = headerView
        
        return tableView
    }()
    
    /// 列表顶部view
    private lazy var headerView: HomeHeaderView = {
        let headerView = HomeHeaderView(frame: CGRect(x: 0, y: 0, width: view.width-40, height: 120))
        return headerView
    }()
    
    /// viewModel
    private let viewM = AccountViewModel()
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rowData = dataSource[indexPath.section].accounts[indexPath.row]
        let cell = HomeItemCell.cell(withTableView: tableView)
        cell.account = rowData
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var headerView = tableView.dequeueReusableHeaderFooterView() as HomeItemSectionView?
        if headerView == nil {
            headerView = HomeItemSectionView(reuseIdentifier: HomeItemSectionView.reuseIdentifier)
        }
        headerView!.dailyModel = dataSource[section]
        return headerView!
//        let headerView = HomeItemSectionView(frame: CGRect(x: 0, y: 0, width: view.width, height: HomeItemSectionView.sectionViewHeight))
//
//        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HomeItemSectionView.sectionViewHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let cell = cell as! HomeItemCell
        cell.content.backgroundColor = UIColor.clear
        
        let rect = CGRect(x: 20, y: 0, width: view.width-40, height: 60)
        
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

// MARK: - HomeNavigationViewDelegate
extension HomeViewController: HomeNavigationViewDelegate {
    
    /// 点击日期
    func navigationView(_ navigationView: HomeNavigationView, itemDidSelectedAt indexPath: IndexPath, _ date: YodoDate) {
        
        // 获取列表数据
        dataSource = viewM.getListData(withYodoDate: date)
        let total = viewM.calculatePrice(withAccounts: viewM.accounts)
        
        headerView.expendMoney = total.expend
        headerView.expendMonth = date.month
        headerView.incomeMoney = total.income
        headerView.incomeMonth = date.month
        
        tableView.reloadData()
        
        // cell动画
        cellsOffsetAnimat()
    }
}

// MARK: - Getter | Setter
extension HomeViewController {
    
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
    
    // 执行动画
    private func cellsOffsetAnimat() {
        
        let visibleCells = tableView.visibleCells
        if visibleCells.count == 0 { return }
        
        var animateViews: [UIView] = []
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
}


