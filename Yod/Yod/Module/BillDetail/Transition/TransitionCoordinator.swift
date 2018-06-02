//
//  TransitionCoordinator.swift
//  Yod
//
//  Created by eamon on 2018/6/2.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

class TransitionCoordinator: NSObject, UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
        return CircularTransition(operation: operation)
    }
}
