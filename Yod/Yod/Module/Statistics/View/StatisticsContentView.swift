//
//  StatisticsContentView.swift
//  Yod
//
//  Created by eamon on 2018/8/26.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

// MARK: - StatisticsContentView
class StatisticsContentView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Getter | Setter
    
    /// 日期数据
    var dateModels: [StatisticsDateModel] = [] {
        didSet {
            headerView.reload()
        }
    }
    
    var model: StatisticsModel? {
        didSet {
            chartView.collectionView.reloadData()
        }
    }
    
    /// headerView
    private lazy var headerView: StatisticsHeaderView = {
        
        let headerView = StatisticsHeaderView()
        headerView.contentView = self
        return headerView
    }()
    
    /// 图表
    private lazy var chartView: StatisticsChartView = {
        
        let chartView = StatisticsChartView()
        chartView.contentView = self
        return chartView
    }()
}

// MARK: - Private Methods
extension StatisticsContentView {
    
    private func initView() {
        
        backgroundColor = YodConfig.color.background
        
        addSubview(headerView)
        addSubview(chartView)
        
        setupLayout()
    }
    
    private func setupLayout() {
        
        headerView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.height.equalTo(120)
        }
        
        chartView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(headerView.snp.bottom)
            make.height.equalTo(UIScreen.main.bounds.width*1.3)
        }
    }
}

// MARK: - StatisticsHeaderView
class StatisticsHeaderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
    
    // MARK: - Getter | Setter
    weak var contentView: StatisticsContentView!

    /// 当前选中的日期索引
    private var selectedIndex: Int = 0
    
    /// 大标题
    private lazy var largeTitleLabel: UILabel = {
        
        var largeTitleLabel = UILabel()
        largeTitleLabel.text = "统计"
        largeTitleLabel.textColor = YodConfig.color.blackTitle
        largeTitleLabel.font = YodConfig.font.bold(size: 25)
        return largeTitleLabel
    }()
  
    /// 月份列表
    private lazy var menuView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 35)
        layout.scrollDirection = .horizontal
        
        let rect = CGRect(x: 0, y: largeTitleLabel.frame.maxY+20, width: width, height: 35)
        var menuView = UICollectionView(frame: rect, collectionViewLayout: layout)
        menuView.showsHorizontalScrollIndicator = false
        menuView.backgroundColor = .white
        menuView.delegate = self
        menuView.dataSource = self
        menuView.registerClass(StatisticsMenuItem.self)
        return menuView
    }()
    
    /// 年份
    private lazy var yearLabel: UILabel = {
        
        var yearLabel = UILabel()
        yearLabel.textAlignment = .center
        yearLabel.textColor = YodConfig.color.darkGraySubTitle
        yearLabel.font = YodConfig.font.bold(size: 10)
        return yearLabel
    }()
    
    private lazy var yearLeftView: UIView = {
        
        var yearLeftView = UIView()
        yearLeftView.backgroundColor = YodConfig.color.gary
        return yearLeftView
    }()
    
    private lazy var yearRightView: UIView = {
        
        var yearRightView = UIView()
        yearRightView.backgroundColor = YodConfig.color.gary
        return yearRightView
    }()
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension StatisticsHeaderView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return contentView.dateModels.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = collectionView.dequeueReusableCell(indexPath: indexPath) as StatisticsMenuItem
        item.model = contentView.dateModels[indexPath.row]
        
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if selectedIndex == indexPath.row { return }
        
        // 更改数据源
        contentView.dateModels[selectedIndex].isSelect = false
        contentView.dateModels[indexPath.row].isSelect = true
        selectedIndex = indexPath.row
        
        collectionView.reloadData()
        
        // 滚动到对应位置
        let selectItem = IndexPath(item: indexPath.row, section: 0)
        menuView.scrollToItem(at: selectItem, at: .centeredHorizontally, animated: true)
        
        // 设置年份
        let model = contentView.dateModels[indexPath.row]
        setupYear(withModel: model)
    }
}

// MARK: - Public Methods
extension StatisticsHeaderView {
    
    func reload() {
        
        if contentView.dateModels.count < 2 {return}
        // 设置年份
        selectedIndex = contentView.dateModels.count-2
        yearLabel.text = contentView.dateModels[selectedIndex].date?.year
        
        menuView.reloadData()
        
        let item = collectionView(menuView, numberOfItemsInSection: 0) - 1
        let lastItemIndex = IndexPath(item: item, section: 0)
        
        // TODO fix:iPhone6s 不显示
        delay(delay: 0.1) {
            self.menuView.scrollToItem(at: lastItemIndex, at: .left, animated: false)
            self.menuView.layoutIfNeeded()
        }
    }
}

// MARK: - PrivateMethods
extension StatisticsHeaderView {
    
    private func setupYear(withModel model: StatisticsDateModel) {
        
        // 点击的是日期
        if model.isDate() {
            
            if yearLabel.text == model.date?.year { return }
            StatisticsAnimationUtil.animate(withYearLabel: yearLabel, text: model.date!.year)
            return
        }
        
        // 点击的是全部
        let firstDate = contentView.dateModels.first!
        let lastDate = contentView.dateModels[contentView.dateModels.count-2]
        
        if firstDate.date?.year != lastDate.date?.year {
            
            let text = String(format: "%@ ~ %@", String(describing: firstDate.date!.year), String(describing: lastDate.date!.year))
            StatisticsAnimationUtil.animate(withYearLabel: yearLabel, text: text)
        } else {
            
            if yearLabel.text == firstDate.date!.year { return }
            yearLabel.text = firstDate.date?.year
        }
    }
    
    
    private func initView() {
        
        backgroundColor = .white
        
        addSubview(largeTitleLabel)
        addSubview(menuView)
        addSubview(yearLabel)
        addSubview(yearLeftView)
        addSubview(yearRightView)
    }
    
    private func setupLayout() {
        
        largeTitleLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self).offset(25)
            make.size.equalTo(CGSize(width: 100, height: 40))
            make.top.equalTo(self)
        }
        
        menuView.snp.remakeConstraints { (make) in
            make.left.right.equalTo(self)
            make.height.equalTo(35)
            make.top.equalTo(largeTitleLabel.snp.bottom).offset(20)
        }
        
        yearLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(menuView.snp.bottom).offset(10)
            make.height.equalTo(15)
            make.centerX.equalTo(self)
        }
        
        yearLeftView.snp.remakeConstraints { (make) in
            make.right.equalTo(yearLabel.snp.left).offset(-10)
            make.left.equalTo(self)
            make.height.equalTo(0.5)
            make.centerY.equalTo(yearLabel)
        }
        
        yearRightView.snp.remakeConstraints { (make) in
            make.left.equalTo(yearLabel.snp.right).offset(10)
            make.right.equalTo(self)
            make.height.centerY.equalTo(yearLeftView)
        }
    }
}


