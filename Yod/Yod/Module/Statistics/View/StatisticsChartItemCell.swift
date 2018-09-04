//
//  StatisticsChartItemCell.swift
//  Yod
//
//  Created by eamon on 2018/9/4.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit
import Charts

class StatisticsChartItemCell: UICollectionViewCell, Reusable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initBackgroundLayer()
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var models: [StatisticsCategoryModel] = [] {
        didSet {
            if models.count == 0 { return }
            setupPieChartData()
        }
    }
    
    // MARK: - Getter | Setter
    
    private lazy var pieChartView: PieChartView = {
        
        let pieChartView = PieChartView()
        // 显示百分比
        pieChartView.usePercentValuesEnabled = false
        // 拖拽时惯性效果
        pieChartView.dragDecelerationEnabled = true
        // 不显示标签
        pieChartView.drawEntryLabelsEnabled = false
        
        // 设置空心
        pieChartView.drawHoleEnabled = true
        // 空心半径占比
        pieChartView.holeRadiusPercent = 0.5
        // 空心颜色
        pieChartView.holeColor = .clear
        // 半透明空心半径占比
        pieChartView.transparentCircleRadiusPercent = 0.55
        // 半透明空心颜色
        pieChartView.transparentCircleColor = UIColor.white.withAlphaComponent(0.3)
        return pieChartView
    }()
}



// MARK: - Private Methods
extension StatisticsChartItemCell {
    
    
    // 设置饼状图所需的数据
    private func setupPieChartData() {
        
        var dataEntries: [ChartDataEntry] = []
        for model in models {
            let entry = PieChartDataEntry(value: model.total.double()!, label: model.category.name)
            dataEntries.append(entry)
        }
        let dateSet = PieChartDataSet(values: dataEntries, label: nil)
        dateSet.colors = models.map {
            return UIColor(hexString: $0.category.color)
        }
        pieChartView.data = PieChartData(dataSet: dateSet)
        
        pieChartView.setNeedsDisplay()
    }
    
    private func initBackgroundLayer() {
        
        let titleLayerH: CGFloat = 50
        let cornerRadii = CGSize(width: 10, height: 10)
        
        // 标题背景
        let titleRect = CGRect(x: 0, y: 0, width: width, height: titleLayerH)
        let titleLayer = CAShapeLayer()
        titleLayer.path = UIBezierPath(roundedRect: titleRect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: cornerRadii).cgPath
        titleLayer.fillColor = YodConfig.color.rgb(red: 250, green: 250, blue: 250).cgColor
        
        // 图标背景
        let chartRect = CGRect(x: 0, y: titleLayerH, width: width, height: height-titleLayerH)
        let chartLayer = CAShapeLayer()
        chartLayer.path = UIBezierPath(roundedRect: chartRect, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: cornerRadii).cgPath
        chartLayer.fillColor = UIColor.white.cgColor
        
        let background = UIView(frame: bounds)
        background.backgroundColor = .clear
        background.layer.insertSublayer(titleLayer, at: 0)
        background.layer.insertSublayer(chartLayer, at: 0)
        backgroundView = background
    }
    
    private func initView() {
        
        contentView.addSubview(pieChartView)
        
        setupLayout()
    }
    
    private func setupLayout() {
        pieChartView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-20)
            make.width.equalTo(pieChartView.snp.height)
            make.center.equalTo(contentView)
        }
    }
}
