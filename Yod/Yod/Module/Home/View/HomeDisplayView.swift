//
//  HomeDisplayView.swift
//  Yod
//
//  Created by eamon on 2018/5/2.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

class HomeDisplayView: UIView {
    

    //MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(leftView)
        addSubview(rightView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var currentDate: YodDate! {
        didSet {
            guard oldValue != nil else {
                rightAnimation()
                rightView.date = currentDate
                return
            }
            
            if oldValue => currentDate {
                
                rightAnimation()
                rightView.date = currentDate
            } else {

                leftAnimation()
                leftView.date = currentDate
            }
        }
    }
    
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
        leftView.alpha = 0
        
        return leftView
    }()
    
    private lazy var rightView: AccountContentView = {
       
        var rightView = AccountContentView(frame: bounds)
        rightView.alpha = 0
        
        return rightView
    }()
}
