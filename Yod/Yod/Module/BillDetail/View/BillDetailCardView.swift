//
//  BillDetailCardView.swift
//  Yod
//
//  Created by eamon on 2018/5/18.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

class BillDetailCardView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 添加背景色
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.fillColor = UIColor.white.cgColor
        backgroundLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20)).cgPath
        layer.insertSublayer(backgroundLayer, at: 0)
        
        addSubview(categoryTitleLabel)
        addSubview(categoryView)
        
        setupLayout()
    }
    
    convenience init(frame: CGRect, contentView: BillDetailContentView) {
        self.init(frame: frame)
        self.contentView = contentView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Getter | Setter
    
    weak var contentView: BillDetailContentView!
    
    /// 标题
    private lazy var categoryTitleLabel: UILabel = {
        
        let categoryTitleLabel = UILabel()
        categoryTitleLabel.text = "选择分类"
        categoryTitleLabel.font = YodConfig.font.bold(size: 16)
        categoryTitleLabel.textColor = YodConfig.color.blackTitle
        return categoryTitleLabel
    }()
    
    private lazy var categoryView: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let frame = CGRect(x: 0, y: 50, width: width, height: 180)
        let categoryView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        categoryView.showsHorizontalScrollIndicator = false
        categoryView.backgroundColor = .clear
        categoryView.registerClass(BillDetailCategoryCell.self)
        categoryView.delegate = self
        categoryView.dataSource = self
        return categoryView
    }()
    
    var categories: [Category] = [] {
        didSet {
            categoryView.reloadData()
        }
    }
}

extension BillDetailCardView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! BillDetailCategoryCell
        cell.category = categories[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(indexPath: indexPath) as BillDetailCategoryCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(20, 30, 0, 30)
    }
}

// MARK: - Private Methods
extension BillDetailCardView {
    
    private func setupLayout() {
        
        categoryTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(30)
            make.top.equalTo(self).offset(25)
            make.right.equalTo(self).offset(-30)
            make.height.equalTo(25)
        }
    }
}
