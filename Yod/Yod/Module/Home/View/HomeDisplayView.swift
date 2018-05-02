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
    
    var leftDate: YodDate? {
        didSet {
            leftView.date = leftDate
            
            UIView.animate(withDuration: 0.5) {
                self.rightView.alpha = 0
                
                self.rightView.transform = CGAffineTransform(translationX: self.width*0.2, y: 0)
                
                self.leftView.alpha = 1
                self.leftView.transform = CGAffineTransform.identity
            }
        }
    }
    
    var rightDate: YodDate? {
        didSet {
            rightView.date = rightDate
            
            UIView.animate(withDuration: 0.5) {
                self.leftView.alpha = 0
                self.leftView.transform = CGAffineTransform(translationX: -self.width*0.2, y: 0)
                
                self.rightView.alpha = 1
                self.rightView.transform = CGAffineTransform.identity
            }
        }
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
