//
//  CircularTransition.swift
//  Yod
//
//  Created by eamon on 2018/6/2.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit
import ViewAnimator

@objc protocol CircleTransitionable {
    var triggerButton: UIButton { get }
    var mainView: UIView { get }
    @objc optional var movingViews: [UIView]? { get }
}

class CircularTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    weak var context: UIViewControllerContextTransitioning!
    
    private var operation: UINavigationControllerOperation = .push
    
    private var snapshot: UIView?
    
    convenience init(operation: UINavigationControllerOperation) {
        self.init()
        self.operation = operation
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
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
            
            toVC.triggerButton.alpha = 0
            toVC.triggerButton.transform = CGAffineTransform(translationX: 0, y: 60)
            if let views = toVC.movingViews {
                views?.forEach{ $0.isHidden = true }
            }
            
            animate(fromView: fromVC.mainView, toView: toVC.mainView, triggerButton: fromVC.triggerButton)
        } else if operation == .pop {
            
            containerView.addSubview(toVC.mainView)
            containerView.addSubview(fromVC.mainView)
            
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
        
        if operation == .push {
            
            let toVC = context.viewController(forKey: .to) as! CircleTransitionable
            let animateViews = toVC.movingViews
            if let views = animateViews {
                
                views?.forEach { $0.isHidden = false }
                let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
                UIView.animate(views: views!, animations: animations)
            }
            
            UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseOut, animations: {
                toVC.triggerButton.transform = .identity
                toVC.triggerButton.alpha = 1
            }, completion: nil)
            
            context.completeTransition(flag)
        } else if operation == .pop {
            context.completeTransition(flag)
        }
        
    }
}
