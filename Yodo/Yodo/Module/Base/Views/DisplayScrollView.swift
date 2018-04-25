//
//  DisplayScrollView.swift
//  Yodo
//
//  Created by eamon on 2018/4/23.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

public protocol DisplayViewDataSource: NSObjectProtocol {
    
    func displayView(_ displayView: DisplayView, contentViewForRowAt index: Int) -> UIView?
}


public class DisplayView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(scrollView)
        scrollView.addSubview(leftPage)
        scrollView.addSubview(centerPage)
        scrollView.addSubview(rightPage)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.frame = bounds
        leftPage.frame = bounds
        centerPage.frame = CGRect(x: frame.width, y: 0, width: bounds.width, height: bounds.height)
        rightPage.frame = CGRect(x: 2*frame.width, y: 0, width: bounds.width, height: bounds.height)
        scrollView.contentSize = CGSize(width: width*3, height: 0)
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
        
        let scrollView = UIScrollView(frame: bounds)
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        
        return scrollView
    }()
    
    weak open var ds: DisplayViewDataSource? {
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
            if let v = v {
                v.frame = scrollView.bounds;
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
}
