//
//  DisplayScrollView.swift
//  Yodo
//
//  Created by eamon on 2018/4/23.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

public protocol DisplayViewDataSrouce: NSObjectProtocol {
    
    func displayView(_ displayView: DisplayView, contentViewForRowAt index: Int) -> UIView
}


public class DisplayView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(scrollView)
        addSubview(leftPage)
        addSubview(rightPage)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Getter | Setter
    
    private let total = 3
    
    public var index: Int = 0 {
        didSet {
            if index < 0 || index >= 3 {
                index = 0
            }
        }
    }
    
    /// 中间page
    private lazy var centerPage: UIView = {
        
        let centerPage = UIView()
        centerPage.frame = bounds
        centerPage.x = frame.width
        
        return centerPage
    }()
    
    /// 左边page
    private lazy var leftPage: UIView = {
        
        let leftPage = UIView()
        leftPage.frame = bounds
        
        return leftPage
    }()
    
    /// 右边page
    private lazy var rightPage: UIView = {
        
        let rightPage = UIView()
        rightPage.frame = bounds
        rightPage.x = 2*frame.width
        
        return rightPage
    }()
    
    /// scrollView
    private (set) lazy var scrollView: UIScrollView = {
        
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: width*3, height: 0)
        
        return scrollView
    }()
    
    weak open var ds: DisplayViewDataSrouce? {
        didSet {
            if ds != nil {
                reloadData()
            }
        }
    }
}

// MARK: - UIScrollViewDelegate
extension DisplayView: UIScrollViewDelegate {
    
}

// MARK: - Public Methods
extension DisplayView {
    
    public func reloadData() {
        removeSubviews()
        
        initPage()
    }
}

// MARK: - Private Methods
extension DisplayView {
    
    private func removeSubviews() {
        for left in leftPage.subviews {
            left.removeFromSuperview()
        }
        for center in centerPage.subviews {
            center.removeFromSuperview()
        }
        for right in rightPage.subviews {
            right.removeFromSuperview()
        }
    }
    
    private func initPage() {
        
        for i in 0..<total {
            let v = ds!.displayView(self, contentViewForRowAt: i)
            switch i {
            case 0:
                leftPage.addSubview(v)
            case 1:
                centerPage.addSubview(v)
            case 2:
                rightPage.addSubview(v)
            default:
                break
            }
        }
    }
}
