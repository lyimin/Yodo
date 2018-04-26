//
//  DisplayScrollView.swift
//  Yodo
//
//  Created by eamon on 2018/4/23.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

@objc public protocol DisplayViewDelegate: UIScrollViewDelegate {
    
    func numberOfContentView(_ displayView: DisplayView) -> Int
    func displayView(_ displayView: DisplayView, contentViewForRowAt index: Int) -> UIView
    
    @objc optional func displayViewScrollToTop(_ displayView: DisplayView) -> Bool
    @objc optional func displayViewScrollToBottom(_ displayView: DisplayView) -> Bool
    @objc optional func displayView(_ displayView: DisplayView, shouldReloadDataAt index: Int, lastIndex: Int)
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
    
    private var total = 3
    
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
    
    weak public var delegate: DisplayViewDelegate! {
        didSet {
            reloadData()
        }
    }
    
    /// 是否滚到底部
    private var scrollToBottom: Bool = false
    
    /// 是否滚动顶部
    private var scrollToTop: Bool = false
}

// MARK: - UIScrollViewDelegate
extension DisplayView: UIScrollViewDelegate {
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        YodoDebug(debug: "begingragging \(scrollView.contentOffset.x)")
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let i = Int(scrollView.contentOffset.x/scrollView.width)
        
        if i == index || (index != 1 && i == 1) { return }
        
        if delegate.responds(to: #selector(DisplayViewDelegate.displayView(_:shouldReloadDataAt:lastIndex:))) {
            delegate.displayView!(self, shouldReloadDataAt: i, lastIndex: index)
        }
    }
 
}

// MARK: - Public Methods
extension DisplayView {
    
    public func reloadData() {
        removeSubviews()
        
        initPage()
        
        contentOffset()
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
        
        let total = delegate!.numberOfContentView(self)
        self.total = total
        
        for i in 0..<total {
            let v = delegate!.displayView(self, contentViewForRowAt: i)
            
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
    
    private func contentOffset() {
        
        if delegate.responds(to: #selector(DisplayViewDelegate.displayViewScrollToTop(_:))) {
            
            scrollToTop = delegate.displayViewScrollToTop!(self)
            if scrollToTop {
                scrollView.setContentOffset(CGPoint.zero, animated: false)
                index = 0
            }
        }
        
        if delegate.responds(to: #selector(DisplayViewDelegate.displayViewScrollToBottom(_:))) {
            
            scrollToBottom = delegate.displayViewScrollToBottom!(self)
            if scrollToBottom {
                scrollView.setContentOffset(CGPoint(x: width*2, y: 0), animated: false)
                index = 2
            }
        }
        
        if !scrollToTop && !scrollToBottom {
            scrollView.setContentOffset(CGPoint(x: width, y: 0), animated: false)
            index = 1
        }
    }
}
