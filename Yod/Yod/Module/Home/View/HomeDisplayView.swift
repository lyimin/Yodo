//
//  HomeDisplayView.swift
//  Yod
//
//  Created by eamon on 2018/5/2.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

class HomeDisplayView: UIView {
    
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
 
    private weak var currentView: AccountContentView!
    
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
    
    private(set) lazy var leftView: AccountContentView = {
        
        var leftView = AccountContentView(frame: bounds)
        return leftView
    }()
    
    private(set) lazy var rightView: AccountContentView = {
       
        var rightView = AccountContentView(frame: bounds)
        return rightView
    }()
}
