//
//  HomeNavigationView.swift
//  Yod
//
//  Created by eamon on 2018/3/6.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit
import SnapKit

/// 首页导航栏


protocol HomeNavigationViewDelegate: class {
    
    /// 点击item回调
    func navigationView(_ navigationView: HomeNavigationView, itemDidSelectedAt index: Int, _ date: YodDate)

    /// 点击菜单
    func navigationView(_ navigationView: HomeNavigationView, menuBtnDidClick: UIButton)
    
    /// 点击统计
    func navigationView(_ navigationView: HomeNavigationView, chartBtn: UIButton)
}


class HomeNavigationView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Getter | Setter
    weak var delegate: HomeNavigationViewDelegate?
    
    /// 防止频繁点击
    private var tapEnable: Bool = true
    
    /// item高度
    private let itemSize: CGSize = CGSize(width: 50, height: 60)
    private let itemInset: CGFloat = 20
    private let itemMargin: CGFloat = 20
    
    /// 当前选中cell
    var selectedIndex: Int = 0 {
        didSet {
            
            guard selectedIndex < dates.count && dates.count > 0 else { return }
            
            let selectedView = dateViews[selectedIndex]
            dateViews[oldValue].isSelected = false
            selectedView.isSelected = true
            showAnimation(current: selectedView)
        }
    }
    
    /// 导航栏日期数据
    var dates: [YodDate] = [] {
        didSet {
            
            reloadData()
        }
    }
    
    private var dateViews: [HomeDateItemView] = []
    
    /// 菜单
    private lazy var menuBtn: UIButton = {
        
        var menuBtn = UIButton()
        menuBtn.addTarget(self, action: #selector(menuBtnDidClick), for: .touchUpInside)
        menuBtn.setImage(#imageLiteral(resourceName: "ic_home_menu"), for: .normal)
        return menuBtn
    }()
    
    /// 分割线
    private lazy var sepLine: UIView = {
        
        var sepLine = UIView()
        sepLine.backgroundColor = YodConfig.color.sepLine
        return sepLine
    }()
    
    /// 标题
    private lazy var titleLabel: UILabel = {
       
        var titleLabel = UILabel()
        titleLabel.text = "日常记账"
        titleLabel.textColor = YodConfig.color.blackTitle
        titleLabel.font = YodConfig.font.homeTitle
        return titleLabel
    }()
    
    /// 图标
    private lazy var chartBtn: UIButton = {
        
        var chartBtn = UIButton()
        chartBtn.setImage(#imageLiteral(resourceName: "ic_home_chart"), for: .normal)
        chartBtn.addTarget(self, action: #selector(chartBtnDidClick), for: .touchUpInside)
        return chartBtn
    }()
    
    /// 选中背景view
    private lazy var selectView: UIView = {
        
        var selectView = UIView()
        selectView.layer.cornerRadius = 10
        selectView.backgroundColor = YodConfig.color.theme
        return selectView
    }()
    
    /// 日期
    private lazy var scrollView: UIScrollView = {
        
        var scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    /// 底部分割线
    private lazy var borderLine: UIView = {
        
        let borderLine = UIView()
        borderLine.backgroundColor = YodConfig.color.background
        
        return borderLine
    }()
}

// MARK: - Public Methods
extension HomeNavigationView {
    /** 这里会有3种情况出现
     *   1. 当前page 小于 0.5                                        ===>  滚到最前
     *   2. 0.5 < page <= contentSize.width - scrollView.width*0.5  ===> 中间位置
     *   3. page > contentSize.width - scrollView.width*0.5         ===> 滚到最后
     */
    func setContentOffSet(animate: Bool) {
        
        let selectedView = dateViews[selectedIndex]
        let rect = convert(selectedView.frame, from: scrollView)
        guard rect.origin.x < 0 || rect.origin.x > scrollView.width-itemSize.width else {
            return
        }
        
        let contentSizeWidth = scrollView.contentSize.width
        let indexViewX = selectedView.x - scrollView.width * 0.5
        if indexViewX <= scrollView.width * 0.5 {
            scrollView.setContentOffset(.zero, animated: animate)
        } else if indexViewX >= contentSizeWidth - scrollView.width {
            scrollView.setContentOffset(CGPoint(x: contentSizeWidth-scrollView.width, y: 0), animated: animate)
        } else {
            scrollView.setContentOffset(CGPoint(x: indexViewX, y: 0), animated: animate)
        }
    }
}

//MARK: - PrivateMethods
extension HomeNavigationView {
    
    /// 刷新数据
    private func reloadData() {
        
        scrollView.subviews.forEach{
            $0.removeFromSuperview()
        }
        dateViews.removeAll()
        
        scrollView.addSubview(selectView)
        var lastView: HomeDateItemView!
        for i in 0..<dates.count {
            
            let itemFrame = CGRect(origin: CGPoint(x: itemInset+CGFloat(i)*(itemSize.width+itemMargin), y: 0), size: itemSize)
            let item = HomeDateItemView(frame: itemFrame)
            item.tag = i
            item.date = dates[i]
            scrollView.addSubview(item)
            dateViews.append(item)
            
            item.viewAddTarget(target: self, action: #selector(itemDidClick(tap:)))
            
            if i == dates.count - 1 { lastView = item }
        }
        
        // 设置contentSize
        scrollView.contentSize = CGSize(width: lastView.frame.maxX+itemMargin, height: 0)
    }
    
    /// 点击每个日历
    @objc private func itemDidClick(tap: UITapGestureRecognizer) {
        
        let index = tap.view!.tag
        
        if index == selectedIndex || !tapEnable { return }
        
        // 防止频繁点击
        tapEnable = false
        perform(#selector(tapEnough), with: nil, afterDelay: 0.3)
        
        // 执行动画
        dateViews[selectedIndex].isSelected = false
        dateViews[index].isSelected = true
        selectedIndex = index
        
        showAnimation(current: dateViews[index])
        
        // 震动
        shake(action: .selection)
        
        // 回调给控制器
        if let delegate = delegate {
            delegate.navigationView(self, itemDidSelectedAt: index, dates[index])
        }
    }
    
    /// 点击菜单
    @objc private func menuBtnDidClick() {
        if let delegate = delegate {
            delegate.navigationView(self, menuBtnDidClick: menuBtn)
        }
    }
    
    /// 点击统计
    @objc private func chartBtnDidClick() {
        if let delegate = delegate {
            delegate.navigationView(self, chartBtn: chartBtn)
        }
    }
    
    /// 添加控件
    private func initView() {
        backgroundColor = .white
        
        addSubview(menuBtn)
        addSubview(sepLine)
        addSubview(titleLabel)
        addSubview(chartBtn)
        addSubview(scrollView)
        addSubview(borderLine)
        
        setupLayout()
    }
    
    
    /// 约束
    private func setupLayout() {
        
        menuBtn.snp.makeConstraints{ (make) in
            make.left.equalTo(YodConfig.frame.nvIconMarginBorder)
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.top.equalTo(self).offset(YodConfig.frame.nvIconMarginTop + YodConfig.frame.safeTopHeight)
        }
        
        sepLine.snp.makeConstraints { (make) in
            make.left.equalTo(menuBtn.snp.right).offset(YodConfig.frame.nvIconMarginLeft)
            make.size.equalTo(CGSize(width: 1, height: 15))
            make.centerY.equalTo(menuBtn)
        }
        
        chartBtn.snp.makeConstraints { (make) in
            make.size.centerY.equalTo(menuBtn)
            make.right.equalTo(self).offset(-YodConfig.frame.nvIconMarginBorder)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(sepLine.snp.right).offset(YodConfig.frame.nvIconMarginLeft)
            make.height.equalTo(30)
            make.centerY.equalTo(menuBtn)
            make.right.equalTo(chartBtn.snp.left).offset(-YodConfig.frame.nvIconMarginLeft)
        }
        
        scrollView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.bottom.equalTo(self).offset(-5)
            make.height.equalTo(itemSize.height)
        }
        
        borderLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
    
    /// 选择框执行缩放和渐变动画
    private func showAnimation(current: HomeDateItemView) {
    
        selectView.frame = current.frame
        selectView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        UIView.animate(withDuration: 0.2, animations: {
            self.selectView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) { (final) in
            
        }
    }
    
    @objc private func tapEnough() {
        tapEnable = true
    }
}
