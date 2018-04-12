//
//  HomeDateItemCell.swift
//  Yodo
//
//  Created by eamon on 2018/3/8.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit
import SnapKit

class HomeDateItemCell: UICollectionViewCell, Reusable {
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.addSublayer(bgLayer)
       
        addSubview(yearLabel)
        addSubview(monthLabel)
        
    }
    
    override func layoutSubviews() {
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Getter | Setter
    
    /// 数据
    var date: YodoDate! {
        didSet {
            self.yearLabel.text = date.year
            self.monthLabel.text = date.month
            
            /*
            if date.isThisMonth {
//                backgroundColor = UIColor(red: 0, green: 118.0/255, blue: 1, alpha: 1)
                yearLabel.textColor = .white
                monthLabel.textColor = .white
            } else {
//                backgroundColor = UIColor.clear
                yearLabel.textColor = YodoConfig.color.darkGraySubTitle
                monthLabel.textColor = YodoConfig.color.blackTitle
            }
             */
        }
    }
    
    /// 年份
    private lazy var yearLabel: UILabel = {
       
        var yearLabel = UILabel()
        yearLabel.textAlignment = .center
        yearLabel.textColor = YodoConfig.color.darkGraySubTitle
        yearLabel.font = YodoConfig.font.bold(size: 13)
        
        return yearLabel
    }()
    
    /// 月份
    private lazy var monthLabel: UILabel = {
      
        var monthLabel = UILabel()
        monthLabel.textAlignment = .center
        monthLabel.textColor = YodoConfig.color.blackTitle
        monthLabel.font = YodoConfig.font.bold(size: 28)
        
        return monthLabel
    }()
    
    /// 背景色
    public lazy var bgLayer: CAShapeLayer = {
        
        var bgLayer = CAShapeLayer()
        bgLayer.cornerRadius = 10
        bgLayer.frame = self.bounds
//        bgLayer.opacity = 0
        
        return bgLayer
    }()
    
    /// 背景layer
    private var maskLayer: CAShapeLayer?
}

// MARK: - Public Methods
extension HomeDateItemCell: CAAnimationDelegate {
    
    /// 点击item时显示动画
    public func showAnimation() {
        
        bgLayer.backgroundColor = YodoConfig.color.theme.cgColor
        yearLabel.textColor = .white
        monthLabel.textColor = .white
        
        if maskLayer == nil {
            
            maskLayer = CAShapeLayer()
            maskLayer?.path = UIBezierPath(rect: CGRect(x: 25, y: 30, width: 1, height: 1)).cgPath
            bgLayer.mask = maskLayer
        }
        
        
        let maskAnimation = CABasicAnimation(keyPath: "path")
        maskAnimation.fromValue = UIBezierPath(rect: CGRect(x: 25, y: 30, width: 1, height: 1)).cgPath
        maskAnimation.toValue = UIBezierPath(roundedRect: self.bounds, cornerRadius: 10).cgPath
        
        let alphaAnimation = CABasicAnimation(keyPath: "opacity")
        alphaAnimation.fromValue = 0
        alphaAnimation.toValue = 1
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [alphaAnimation, maskAnimation]
        animationGroup.duration = 0.3
        animationGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animationGroup.isRemovedOnCompletion = false
        animationGroup.fillMode = kCAFillModeForwards
        
        maskLayer?.add(animationGroup, forKey: "show")
    }
    
    
    /// 点击item时隐藏动画
    public func hiddenAnimation() {
        
        bgLayer.backgroundColor = UIColor.clear.cgColor
        yearLabel.textColor = YodoConfig.color.darkGraySubTitle
        monthLabel.textColor = YodoConfig.color.blackTitle
        
        if let mask = maskLayer {
            
            let maskAnimation = CABasicAnimation(keyPath: "path")
            maskAnimation.fromValue = UIBezierPath(roundedRect: self.bounds, cornerRadius: 10).cgPath
            maskAnimation.toValue = UIBezierPath(rect: CGRect(x: 25, y: 30, width: 1, height: 1)).cgPath
            
            let alphaAnimation = CABasicAnimation(keyPath: "opacity")
            alphaAnimation.fromValue = 1
            alphaAnimation.toValue = 0
            
            let animationGroup = CAAnimationGroup()
            animationGroup.animations = [alphaAnimation, maskAnimation]
            animationGroup.duration = 0.3
            animationGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            animationGroup.isRemovedOnCompletion = false
            animationGroup.fillMode = kCAFillModeForwards
            animationGroup.delegate = self;
            animationGroup.setValue(mask, forKey: "hidden")
            
            mask.add(animationGroup, forKey: "hidden")
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        if anim.value(forKeyPath: "hidden") != nil {
            self.maskLayer = nil
        }
    }
}

// MARK: - Private Methods
extension HomeDateItemCell {
    
    /// 约束
    private func setupLayout() {
        
        yearLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self).offset(5)
            make.height.equalTo(20)
        }
        
        monthLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.height.equalTo(30)
            make.top.equalTo(yearLabel.snp.bottom)
        }
    }
}
