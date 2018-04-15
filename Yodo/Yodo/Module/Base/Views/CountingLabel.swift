//
//  CountingLabel.swift
//  Yodo
//
//  Created by eamon on 2018/4/15.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

class CountingLabel: UILabel {

    /// 动画时间
    private let duration: TimeInterval = 0.5
    
    /// 开始数字
    private var fromValue: Double = 0
    
    /// 结束数字
    private var toValue: Double = 0
    
    /// 计时器
    private var timer: CADisplayLink?
    
    private var progress: TimeInterval = 0
    
    private var lastUpdateTime: TimeInterval = 0
    private var totalTime: TimeInterval = 0
    
    private var currentValue: Double {
        if progress >= totalTime { return toValue }
        return fromValue + Double(progress / totalTime) * (toValue - fromValue)
    }
    
    /// 开始计时
    private func start() {
        timer = CADisplayLink(target: self, selector: #selector(updateValue(timer:)))
        timer?.add(to: .main, forMode: .defaultRunLoopMode)
        timer?.add(to: .main, forMode: .UITrackingRunLoopMode)
    }
    
    /// 停止计时
    private func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc fileprivate func updateValue(timer: Timer) {
        let now = Date.timeIntervalSinceReferenceDate
        progress += now - lastUpdateTime
        lastUpdateTime = now
        
        if progress >= totalTime {
            stop()
            progress = totalTime
        }
        
        setTextValue(value: currentValue)
    }
    
    private func setTextValue(value: Double) {
        text = String(format: "%.2f", value)
    }
}

extension CountingLabel {
   
    func animate(fromValue from: Double = 0, toValue to: Double, duration t: TimeInterval? = nil) {
        self.fromValue = from
        self.toValue = to
        
        stop()
        
        if (t == 0.0) {
            setTextValue(value: to)
            return
        }
        
        progress = 0.0
        totalTime = t ?? self.duration
        lastUpdateTime = Date.timeIntervalSinceReferenceDate
        
        start()
    }
}
