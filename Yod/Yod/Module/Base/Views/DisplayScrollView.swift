//
//  DisplayScrollView.swift
//  Yod
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
    func displayView(_ displayView: DisplayView, shouldResetFrame leftView: UIView, _ centerView: UIView, _ rightView: UIView, _ dir: DisplayView.ScrollDirection) -> Bool
    func displayView(_ displayView: DisplayView, didResetFrame leftView: UIView, _ centerView: UIView, _ rightView: UIView, _ dir: DisplayView.ScrollDirection)
}


public class DisplayView: UIView {
    
    /// scrollView的滚动方向
    @objc public enum ScrollDirection: Int {
        case left = 0
        case middle = 1
        case right = 2
    }

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
    
    private var lastIndex: Int = 0
    
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
    
    
    private var critical: Bool = true
}

// MARK: - UIScrollViewDelegate
extension DisplayView: UIScrollViewDelegate {
    
    // 防止滑动过快
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollView.isUserInteractionEnabled = false
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let index = Int(scrollView.contentOffset.x/scrollView.width)
        let dir: ScrollDirection = ScrollDirection(rawValue: index)!
        
        if index == lastIndex || (lastIndex != 1 && index == 1) {
            
            // 动画差
            delay(delay: 0.1) {
                scrollView.isUserInteractionEnabled = true
            }
            critical = false
            lastIndex = index
            return
        }
        
        // 判断是否要更新frame
        var subview = getSubviews()
        
        let isResetFrame = delegate.displayView(self, shouldResetFrame: subview.left, subview.center, subview.right, dir)
        
        if !isResetFrame {
            // 动画差
            delay(delay: 0.1) {
                scrollView.isUserInteractionEnabled = true
            }
            critical = true
            lastIndex = index
            return
            
        }
 
        // 重新更新frame
        resetFrame(dir: dir)
        subview = getSubviews()
        
        // 设置frame后，回调给控制器
        if delegate.responds(to: #selector(DisplayViewDelegate.displayView(_:didResetFrame:_:_:_:))) {
            delegate.displayView(self, didResetFrame: subview.left, subview.center, subview.right, dir)
        }
        
        // 动画差
        delay(delay: 0.1) {
            scrollView.isUserInteractionEnabled = true
        }
    }
}

// MARK: - Public Methods
extension DisplayView {
    
    public func reloadData() {
    
        initPage()
        
        contentOffset()
    }
}

// MARK: - Private Methods
extension DisplayView {
    
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
            
            if delegate.displayViewScrollToTop!(self) {
                scrollView.setContentOffset(CGPoint.zero, animated: false)
                lastIndex = 0
                critical = true
            }
        }
        
        if delegate.responds(to: #selector(DisplayViewDelegate.displayViewScrollToBottom(_:))) {
            
            if delegate.displayViewScrollToBottom!(self) {
                scrollView.setContentOffset(CGPoint(x: width*2, y: 0), animated: false)
                lastIndex = 2
                critical = true
            }
        }
 
        
        if !critical {
            scrollView.setContentOffset(CGPoint(x: width, y: 0), animated: false)
            lastIndex = 1
            critical = false
        }
    }
    
    /// 重新设置frame
    /// 这里 index的取值只有两种 0 和 2
    private func resetFrame(dir: ScrollDirection) {
        
        if dir == ScrollDirection.left {
            
            // 往左边滑动
            for subView in scrollView.subviews {
                if subView.x == 0 {
                    subView.x = width
                } else if (subView.x == width) {
                    subView.x = 2*width
                } else if (subView.x == 2*width) {
                    subView.x = 0
                }
            }
            
        } else if dir == ScrollDirection.right {
            
            // 往右边滑动
            for subView in scrollView.subviews {
                if subView.x == 0 {
                    subView.x = 2*width
                } else if (subView.x == width) {
                    subView.x = 0
                } else if (subView.x == 2*width) {
                    subView.x = width
                }
            }
        }
        
        scrollView.setContentOffset(CGPoint(x: width, y: 0), animated: false)
    }
    
    /// 根据frame获取子view
    private func getSubviews() -> (left: UIView, center: UIView, right: UIView) {
        
        var left, center, right: UIView!
        
        for subView in scrollView.subviews {
            if subView.x == 0 {
                left = subView.subviews.first!
            } else if (subView.x == width) {
                center = subView.subviews.first!
            } else if (subView.x == 2*width) {
                right = subView.subviews.first!
            }
        }
        return (left, center, right)
    }
}
