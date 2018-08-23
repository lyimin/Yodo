//
//  HomeDetailCardView.swift
//  Yod
//
//  Created by eamon on 2018/5/18.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

class HomeDetailCardView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 添加背景色
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.fillColor = UIColor.white.cgColor
        backgroundLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20)).cgPath
        layer.insertSublayer(backgroundLayer, at: 0)
        
        addSubview(categoryTitleLabel)
        addSubview(categoryView)
        addSubview(dateItem)
        addSubview(noteItem)
        
        setupLayout()
    }
    
    convenience init(frame: CGRect, contentView: HomeDetailContentView) {
        self.init(frame: frame)
        self.contentView = contentView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Getter | Setter
    
    weak var contentView: HomeDetailContentView!
    
    var date: YodDate! {
        didSet {
            if contentView.account.date.isToday {
                dateItem.descLabel.text = "今天"
            } else {
                dateItem.descLabel.text = contentView.account.date.gobalDesc
            }
        }
    }
    
    var note: String! {
        didSet {
            if contentView.account.remarks == "" {
                noteItem.descLabel.text = "无"
            } else {
                noteItem.descLabel.text = contentView.account.remarks
            }
        }
    }
    
    /// 分类数据
    var categories: [Category] = [] {
        didSet {
            categoryView.reloadData()
        }
    }
    
    /// 标题
    private lazy var categoryTitleLabel: UILabel = {
        
        let categoryTitleLabel = UILabel()
        categoryTitleLabel.text = "选择分类"
        categoryTitleLabel.font = YodConfig.font.bold(size: 16)
        categoryTitleLabel.textColor = YodConfig.color.blackTitle
        return categoryTitleLabel
    }()
    
    /// 分类
    private var categoryViewHeight: CGFloat = 180
    
    private lazy var categoryView: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let frame = CGRect(x: 0, y: 50, width: width, height: categoryViewHeight)
        let categoryView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        categoryView.showsHorizontalScrollIndicator = false
        categoryView.backgroundColor = .clear
        categoryView.registerClass(HomeDetailCategoryCell.self)
        categoryView.delegate = self
        categoryView.dataSource = self
        return categoryView
    }()
    
    /// 日期
    private lazy var dateItem: HomeDetailItem = {
        
        var dateItem = HomeDetailItem()
        dateItem.viewAddTarget(target: self, action: #selector(dateItemDidClick))
        dateItem.iconView.image = #imageLiteral(resourceName: "ic_HomeDetail_date")
        dateItem.titleLabel.text = "日期"
        return dateItem
    }()
    
    /// 备注
    private lazy var noteItem: HomeDetailItem = {
        
        var noteItem = HomeDetailItem()
        noteItem.viewAddTarget(target: self, action: #selector(noteItemDidClick))
        noteItem.isShowLineView = false
        noteItem.iconView.image = #imageLiteral(resourceName: "ic_HomeDetail_note")
        noteItem.titleLabel.text = "备注"
        return noteItem
    }()
}

extension HomeDetailCardView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! HomeDetailCategoryCell
        cell.category = categories[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(indexPath: indexPath) as HomeDetailCategoryCell
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let delegate = contentView.delegate {
            delegate.categoryItemDidClick(cardView: self, category: categories[indexPath.row])
        }
    }
}

// MARK: - Private Methods
extension HomeDetailCardView {
    
    private func setupLayout() {
        
        categoryTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(30)
            make.top.equalTo(self).offset(25)
            make.right.equalTo(self).offset(-30)
            make.height.equalTo(25)
        }
        
        dateItem.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.height.equalTo(49)
            make.top.equalTo(categoryTitleLabel.snp.bottom).offset(categoryViewHeight+50)
        }
        
        noteItem.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(dateItem)
            make.top.equalTo(dateItem.snp.bottom)
        }
    }
    
    /// 点击日历
    @objc private func dateItemDidClick() {
        
        if let delegate = contentView.delegate {
            delegate.calendarItemDidClick(item: dateItem, date: YodDate.now())
        }
    }
    
    /// 点击备注
    @objc private func noteItemDidClick() {
        
        if let delegate = contentView.delegate, let text = noteItem.descLabel.text {
            delegate.noteItemDidClick(item: noteItem, content: text)
        }
    }
}


class HomeDetailItem: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(descLabel)
        addSubview(lineViw)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isShowLineView: Bool = true {
        didSet {
            lineViw.isHidden = !isShowLineView
        }
    }
    
    private func setupLayout() {
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(30)
            make.size.equalTo(CGSize(width: 23, height: 23))
            make.centerY.equalTo(self)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(15)
            make.height.equalTo(20)
            make.centerY.equalTo(iconView)
            make.width.greaterThanOrEqualTo(60)
        }
        
        descLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(10)
            make.right.equalTo(self).offset(-30)
            make.centerY.height.equalTo(titleLabel)
        }
        
        lineViw.snp.makeConstraints { (make) in
            make.left.equalTo(iconView)
            make.right.equalTo(self)
            make.height.equalTo(0.5)
            make.bottom.equalTo(self)
        }
    }
    
    private(set) lazy var iconView: UIImageView = {
        
        var iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        return iconView
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        
        var titleLabel = UILabel()
        titleLabel.textColor = YodConfig.color.blackTitle
        titleLabel.font = YodConfig.font.bold(size: 16)
        return titleLabel
    }()
    
    private(set) lazy var descLabel: UILabel = {
        
        var descLabel = UILabel()
        descLabel.textColor = YodConfig.color.darkGraySubTitle
        descLabel.font = YodConfig.font.bold(size: 16)
        descLabel.textAlignment = .right
        return descLabel
    }()
    
    private lazy var lineViw: UIView = {
        
        var lineView = UIView()
        lineView.backgroundColor = YodConfig.color.sepLine
        return lineView
    }()
}
