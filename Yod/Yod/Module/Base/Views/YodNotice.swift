//
//  YodNotice.swift
//  Yod
//
//  Created by eamon on 2018/7/18.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

public enum NoticeType {
    case success
    case error
    
    func backgroundColor() -> UIColor {
        switch self {
        case .success:
            return YodConfig.color.noticeSuccess
        case .error:
            return YodConfig.color.noticeError
        }
    }
}

extension UIResponder {
    
    @discardableResult
    public func noticeSuccess(_ text: String, autoClear: Bool = true, autoClearTime: Int = 1) -> UIWindow {
        shake(action: .success)
        return notice(text, type: .success, autoClear: autoClear, autoClearTime: autoClearTime)
    }
    
    @discardableResult
    public func noticeError(_ text: String, autoClear: Bool = true, autoClearTime: Int = 1) -> UIWindow {
        shake(action: .error)
        return notice(text, type: .error, autoClear: autoClear, autoClearTime: autoClearTime)
    }
    
    @discardableResult
    public func notice(_ text: String, type: NoticeType, autoClear: Bool = true, autoClearTime: Int = 1) -> UIWindow {
        return YodNotice.notice(text, type: type, autoclear: autoClear, autoClearTime: autoClearTime)
    }
    
    public func clearNotice() {
        return YodNotice.hideNotice()
    }
}

class YodNotice: NSObject {
    
    static var window: UIWindow?

    class func notice(_ text: String, type: NoticeType, autoclear: Bool, autoClearTime: Int) -> UIWindow {
        
        if let w = self.window { return w }
        
        let frame = UIApplication.shared.statusBarFrame
        window = UIWindow()
        window!.backgroundColor = .clear
        let contentView = UIView()
        contentView.backgroundColor = type.backgroundColor()
        
        let label = UILabel(frame: frame.height > 20 ? CGRect(x: frame.origin.x, y: frame.origin.y + frame.height - 17, width: frame.width, height: 20) : frame)
        label.textAlignment = .center
        label.font = YodConfig.font.bold(size: 12)
        label.textColor = .white
        label.text = text
        contentView.addSubview(label)
        
        window!.frame = frame
        contentView.frame = frame
        
        window!.windowLevel = UIWindowLevelStatusBar
        window!.isHidden = false
        window!.addSubview(contentView)
        
        var origin = contentView.frame.origin
        origin.y = -(contentView.frame.size.height)
        let destPoint = contentView.frame.origin
        
        contentView.frame = CGRect(origin: origin, size: contentView.frame.size)
        UIView.animate(withDuration: 0.3, animations: {
            contentView.frame = CGRect(origin: destPoint, size: contentView.frame.size)
        }) { _ in
            if autoclear {
                delay(delay: TimeInterval(autoClearTime), closure: {
                    hideNotice()
                })
            }
        }
        
        return window!
    }
    
    static func hideNotice() {
        if let w = window {
            if let v = w.subviews.first {
                UIView.animate(withDuration: 0.2, animations: {
                    v.frame = CGRect(x: 0, y: -v.frame.height, width: v.frame.width, height: v.frame.height)
                    v.alpha = 0
                }) { _  in
                    
                    window = nil
                }
            }
        }
    }
}
