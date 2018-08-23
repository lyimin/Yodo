//
//  HomeDisplayView.swift
//  Yod
//
//  Created by eamon on 2018/5/2.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit


protocol HomeDisplayViewDelegate: NSObjectProtocol {
    /// 点击删除按钮
    func homeDisplayView(_ contentView: AccountContentView, itemDeleted withIndexPath: IndexPath, callBack: @escaping (_ isDelete: Bool) -> Void)
    
    /// 点击item
    func homeDisplayView(_ contentView: AccountContentView, itemDidClick withIndexPath: IndexPath)
}

class HomeDisplayView: UIView {
    
    weak var delegate: HomeDisplayViewDelegate?
    
    private enum AnimateDirection {
        case none
        case left
        case right
    }
    
    //MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(leftView)
        addSubview(rightView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // TODO:
    var currentDate: YodDate! {
        didSet {
            guard oldValue != nil else {
                
                rightView.date = currentDate
                currentView = rightView
                
                animate(after: leftView, before: currentView, direction: .right)
                return
            }
            
            let afterView = currentView == leftView ? leftView : rightView
            let beforeView = currentView == leftView ? rightView : leftView
            
            var direction: AnimateDirection = .left
            if oldValue => currentDate || oldValue <=> currentDate {
                direction = .right
            }
            
            beforeView.date = currentDate
            currentView = beforeView
            animate(after: afterView, before: beforeView, direction: direction)
        }
    }
 
    weak var currentView: AccountContentView!
    
    private func animate(after: AccountContentView!, before: AccountContentView!, direction: AnimateDirection) {
        
        let translationX = direction == .left ? (-width*0.15) : (width*0.15)
        
        before.transform = CGAffineTransform(translationX: translationX, y: 0)
        before.alpha = 0
        before.tableView.setContentOffset(.zero, animated: false)
        
        UIView.animate(withDuration: 0.3) {
            
            after.transform = CGAffineTransform(translationX: -translationX, y: 0)
            after.alpha = 0
            
            before.transform = .identity
            before.alpha = 1
        }
    }
    
    //MARK: - Getter | Setter
    
    private lazy var leftView: AccountContentView = {
        
        var leftView = AccountContentView(frame: bounds)
        leftView.delegate = self
        
        return leftView
    }()
    
    private lazy var rightView: AccountContentView = {
       
        var rightView = AccountContentView(frame: bounds)
        rightView.delegate = self
        
        return rightView
    }()
}

extension HomeDisplayView: AccountContentViewDelegate {
    
    func accountContentView(_ contentView: AccountContentView, itemDeleted withIndexPath: IndexPath, callBack: @escaping (Bool) -> Void) {
        if let delegate = self.delegate {
            delegate.homeDisplayView(contentView, itemDeleted: withIndexPath, callBack: callBack)
        }
    }
    
    func accountContentView(_ contentView: AccountContentView, itemDidClick withIndexPath: IndexPath) {
        if let delegate = self.delegate {
            delegate.homeDisplayView(contentView, itemDidClick: withIndexPath)
        }
    }
}
