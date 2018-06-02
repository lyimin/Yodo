//
//  CircularTransition.swift
//  Yod
//
//  Created by eamon on 2018/6/2.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

protocol CircleTransitionable {
    var triggerButton: UIButton { get }
    var mainView: UIView { get }
}

class CircularTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    weak var context: UIViewControllerContextTransitioning?
    
    private var operation: UINavigationControllerOperation = .push
    
    private var snapshot: UIView?
    
    convenience init(operation: UINavigationControllerOperation) {
        self.init()
        self.operation = operation
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
        let fromVC = transitionContext.viewController(forKey: .from) as? CircleTransitionable,
        let toVC = transitionContext.viewController(forKey: .to) as? CircleTransitionable,
        let snapshot = fromVC.mainView.snapshotView(afterScreenUpdates: false) else {
            
            transitionContext.completeTransition(false)
            return
        }
        
        self.snapshot = snapshot
        context = transitionContext
        
        let containerView = transitionContext.containerView
        if operation == .push {
            
            containerView.addSubview(snapshot)
            fromVC.mainView.removeFromSuperview()
            containerView.addSubview(toVC.mainView)
        } else {
            containerView.addSubview(toVC.mainView)
            containerView.addSubview(fromVC.mainView)
        }
        
        if operation == .push {
            animate(fromView: fromVC.mainView, toView: toVC.mainView, triggerButton: fromVC.triggerButton)
        } else if operation == .pop {
            animate(fromView: fromVC.mainView, toView: toVC.mainView, triggerButton: toVC.triggerButton)
        }
    }
    
    func animate(fromView: UIView, toView: UIView, triggerButton: UIButton) {
        
        // starting path
        let rect = CGRect(x: triggerButton.x, y: triggerButton.y, width: triggerButton.width, height: triggerButton.height)
        
        let circleMaskPathInitial = UIBezierPath(ovalIn: rect)
        
        //Destination Path
        let extremePoint = CGPoint(x: triggerButton.center.x,
                                   y: triggerButton.center.y)
        let radius = sqrt((extremePoint.x*extremePoint.x) +
            (extremePoint.y*extremePoint.y))
        let circleMaskPathFinal = UIBezierPath(ovalIn: triggerButton.frame.insetBy(dx: -radius,dy: -radius))
        
        var fromPath = circleMaskPathInitial
        var toPath = circleMaskPathFinal
        if operation == .pop {
            toPath = circleMaskPathInitial
            fromPath = circleMaskPathFinal
        }
        
        //Actual mask layer
        let maskLayer = CAShapeLayer()
        maskLayer.path = circleMaskPathFinal.cgPath
        if operation == .pop {
            fromView.layer.mask = maskLayer
        } else {
            toView.layer.mask = maskLayer
        }
        
        //Mask Animation
        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.fromValue = fromPath.cgPath
        maskLayerAnimation.toValue = toPath.cgPath
        maskLayerAnimation.delegate = self
        maskLayerAnimation.duration = transitionDuration(using: context!)
        maskLayerAnimation.isRemovedOnCompletion = false;
        maskLayerAnimation.fillMode = kCAFillModeForwards;
        maskLayerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        maskLayer.add(maskLayerAnimation, forKey: "path")
        
        
    }
}

extension CircularTransition: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        if operation == .pop {
//            context?.viewController(forKey: .from)?.view.layer.mask = nil
//            context?.viewController(forKey: .from)?.view.removeFromSuperview()
        }
        context?.completeTransition(flag)

    }
}
