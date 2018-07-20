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
}

class HomeDisplayView: UIView {
    
    weak var delegate: HomeDisplayViewDelegate?
    
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
                rightAnimation()
                rightView.date = currentDate
                currentView = rightView
                return
            }
            
            if oldValue => currentDate || oldValue <=> currentDate {
                
                rightAnimation()
                rightView.date = currentDate
                currentView = rightView
            } else {

                leftAnimation()
                leftView.date = currentDate
                currentView = leftView
            }
        }
    }
    
    
    var currentView: AccountContentView!
    
    
    
    private func rightAnimation() {
        
        self.rightView.transform = CGAffineTransform(translationX: self.width*0.15, y: 0)
        self.rightView.alpha = 0
        self.rightView.tableView.setContentOffset(CGPoint.zero, animated: false)
        self.leftView.transform = CGAffineTransform.identity
        self.leftView.alpha = 1
        
        UIView.animate(withDuration: 0.3, animations: {
            self.leftView.transform = CGAffineTransform(translationX: -self.width*0.15, y: 0)
            self.leftView.alpha = 0
            self.rightView.transform = CGAffineTransform.identity
            self.rightView.alpha = 1
        })
    }
    
    private func leftAnimation() {
        
        self.leftView.transform = CGAffineTransform(translationX: -self.width*0.15, y: 0)
        self.leftView.alpha = 0
        self.leftView.tableView.setContentOffset(CGPoint.zero, animated: false)
        self.rightView.transform = CGAffineTransform.identity
        self.rightView.alpha = 1
        
        UIView.animate(withDuration: 0.3, animations: {
            UIView.animate(withDuration: 0.3) {
                self.rightView.transform = CGAffineTransform(translationX: self.width*0.15, y: 0)
                self.rightView.alpha = 0
                self.leftView.transform = CGAffineTransform.identity
                self.leftView.alpha = 1
            }
        })
    }
    
    //MARK: - Getter | Setter
    private lazy var leftView: AccountContentView = {
        
        var leftView = AccountContentView(frame: bounds)
        leftView.delegate = self
        leftView.alpha = 0
        
        return leftView
    }()
    
    private lazy var rightView: AccountContentView = {
       
        var rightView = AccountContentView(frame: bounds)
        rightView.delegate = self
        rightView.alpha = 0
        
        return rightView
    }()
}

extension HomeDisplayView: AccountContentViewDelegate {
    
    func accountContentView(_ contentView: AccountContentView, itemDeleted withIndexPath: IndexPath, callBack: @escaping (Bool) -> Void) {
        if let delegate = self.delegate {
            delegate.homeDisplayView(contentView, itemDeleted: withIndexPath, callBack: callBack)
        }
    }
}
