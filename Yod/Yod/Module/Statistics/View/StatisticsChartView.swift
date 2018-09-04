//
//  StatisticsChartView.swift
//  Yod
//
//  Created by eamon on 2018/9/4.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

class StatisticsChartView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Getter | Setter
    
    weak var contentView: StatisticsContentView!
    
    private(set) lazy var collectionView: UICollectionView = {
        
        let margin: CGFloat = 20
        let width = UIScreen.main.bounds.width
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        layout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin)
        layout.itemSize = CGSize(width: width-2*margin, height: UIScreen.main.bounds.width*1.3-2*margin)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = YodConfig.color.background
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClass(StatisticsChartItemCell.self)
        return collectionView
    }()
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension StatisticsChartView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if contentView.model == nil { return 0 }
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(indexPath: indexPath) as StatisticsChartItemCell
        cell.models = contentView.model!.expendModels
        return cell
    }
}

// MARK: - Private Methods
extension StatisticsChartView {
    
    private func initView() {
        
        addSubview(collectionView)
        
        setupLayout()
    }
    
    private func setupLayout() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
}
