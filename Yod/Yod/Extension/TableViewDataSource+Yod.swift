//
//  TableViewDataSource.swift
//  Yod
//
//  Created by eamon on 2018/7/28.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit


@objc protocol YodTableViewDataSource: UITableViewDataSource {
    
    @objc optional func placeHolderView(tableView: UITableView) -> UIView?
    @objc optional func placeHolderTitleView(tableView: UITableView) -> UILabel
}

fileprivate struct AssociatedKeys {
    static var kTableHolderView = "kTableHolderView"
    static var kTableHolderTitle = "kTableHolderTitle"
}

extension UITableView {
    
    private var holderView: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.kTableHolderView) as! UIView?
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.kTableHolderView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var titleLabel: UILabel? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.kTableHolderTitle) as? UILabel
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.kTableHolderTitle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func yod_reloadData() {
        reloadData()
        checkEmpty()
    }
    
    fileprivate func checkEmpty() {
        
        guard dataSource != nil, dataSource is YodTableViewDataSource else {
            return
        }
    
        let ds = dataSource as! YodTableViewDataSource
        
        // 获取tableView组数
        var sections = 1
        if ds.responds(to: #selector(ds.numberOfSections(in:))) {
            sections = ds.numberOfSections!(in: self)
        }
        
        var isEmpty = true
        for i in 0..<sections {
            if ds.tableView(self, numberOfRowsInSection: i) != 0 {
                isEmpty = false
            }
        }
        
        if !isEmpty {
            if let headerView = tableHeaderView {
                headerView.isHidden = false
            }
            isHidden = false
            if holderView != nil {
                holderView!.removeFromSuperview()
                holderView = nil
            }
            if titleLabel != nil {
                titleLabel!.removeFromSuperview()
                titleLabel = nil
            }
            return
        }
        
        if ds.responds(to: #selector(ds.placeHolderView(tableView:))) && ds.placeHolderView!(tableView: self) != nil {
            
            let holderView = ds.placeHolderView!(tableView: self)!
            show(holderView: holderView)
        }
        
        if ds.responds(to: #selector(ds.placeHolderTitleView(tableView:))) {
            
            let titleView = ds.placeHolderTitleView!(tableView: self)
            if titleView.text == nil { return }
            show(titleLabel: titleView)
        }
    }
    
    private func show(holderView: UIView) {
        
        if let headerView = tableHeaderView {
            headerView.isHidden = true
        }
        
        if let holder = self.holderView {
            
            if holder.frame == .zero {
                holderView.frame = bounds
            }
            holder.center = CGPoint(x: center.x, y: center.y-50)
            holder.isHidden = false
            holder.alpha = 1
            return
        }
        
        if holderView.frame == CGRect.zero {
            holderView.frame = bounds
        }
        holderView.center = CGPoint(x: center.x, y: center.y-50)
        addSubview(holderView)
        self.holderView = holderView
    }
    
    private func show(titleLabel: UILabel) {
        
        if let headerView = tableHeaderView {
            headerView.isHidden = true
        }
        
        if let holder = self.titleLabel {
            
            if let holderView = self.holderView {
                holder.frame = CGRect(x: 0, y: holderView.frame.maxY+20, width: width, height: 20)
            }
            holder.isHidden = false
            holder.alpha = 1
            return
        }
        
        if let holderView = self.holderView {
            titleLabel.frame = CGRect(x: 0, y: holderView.frame.maxY+20, width: width, height: 20)
        } else {
            titleLabel.frame = CGRect(x: 0, y: 0, width: width, height: 20)
            titleLabel.center = CGPoint(x: center.x, y: center.y-30)
        }
        addSubview(titleLabel)
        self.titleLabel = titleLabel
    }
}
