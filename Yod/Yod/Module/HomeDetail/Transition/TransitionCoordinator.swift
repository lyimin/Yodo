//
//  TransitionCoordinator.swift
//  Yod
//
//  Created by eamon on 2018/6/2.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

class TransitionCoordinator: NSObject, UINavigationControllerDelegate {
    
    private var percentDrivenTransition: UIPercentDrivenInteractiveTransition?
    
    func setPercentDrivenTransition(percentDrivenTransition: UIPercentDrivenInteractiveTransition?) {
        self.percentDrivenTransition = percentDrivenTransition
    }
        
    /// 执行动画具体操作
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
        return CircularTransition(operation: operation)
    }
    
    
    /// 手势驱动
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        if animationController is CircularTransition {
            return percentDrivenTransition
        }
        
        return nil
    }
}
