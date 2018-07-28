//
//  TableViewDataSource.swift
//  Yod
//
//  Created by eamon on 2018/7/28.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit


@objc protocol YodTableViewDataSource: UITableViewDataSource {
    
    @objc optional
    func placeHolderView(tableView: UITableView) -> UIView?
}

fileprivate struct AssociatedKeys {
    static var kTableHolderView = "kTableHolderView"
}

extension UITableView {
    
    public var holderView: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.kTableHolderView) as! UIView?
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.kTableHolderView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
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
            return
        }
        if !ds.responds(to: #selector(ds.placeHolderView(tableView:))) {
            return
        }
        
        if let holderView = ds.placeHolderView!(tableView: self) {
            
            if let headerView = tableHeaderView {
                headerView.isHidden = true
            }
            
            if let holder = self.holderView {
                
                if holder.frame == CGRect.zero {
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
    }
}
