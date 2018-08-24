//
//  DoflipTransitionAnimation.swift
//  Yod
//
//  Created by eamon on 2018/8/24.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

class DoflipTransitionAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    // 翻转的方向
    enum Direction {
        case left
        case right
    }
    private var dir: Direction = .left
    
    convenience init(dir: Direction) {
        self.init()
        self.dir = dir
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.7
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!
        
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        
        var transform = CATransform3DIdentity
        transform.m34 = -0.002
        containerView.layer.sublayerTransform = transform
        
        let initialFrame = transitionContext.initialFrame(for: fromVC)
        toVC.view.frame = initialFrame
        
        if self.dir == .left {
            toVC.view.layer.transform = rotate(angle: .pi/2)
        } else {
            toVC.view.layer.transform = rotate(angle: -.pi/2)
        }
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIViewKeyframeAnimationOptions(rawValue: 0), animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5, animations: {
                
                if self.dir == .left {
                    fromVC.view.layer.transform = self.rotate(angle: -.pi/2)
                } else {
                    fromVC.view.layer.transform = self.rotate(angle: .pi/2)
                }
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                toVC.view.layer.transform = self.rotate(angle: 0)
            })
            
        }) { (finished) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    private func rotate(angle: CGFloat) -> CATransform3D {
        return CATransform3DMakeRotation(angle, 0.0, 1.0, 0.0)
    }
}
