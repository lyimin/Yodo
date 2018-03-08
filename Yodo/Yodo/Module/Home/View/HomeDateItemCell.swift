//
//  HomeDateItemCell.swift
//  Yodo
//
//  Created by 梁亦明 on 2018/3/8.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

class HomeDateItemCell: UICollectionViewCell {
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Getter | Setter
    private lazy var yearLabel: UILabel = {
       
        var yearLabel = UILabel()
        yearLabel.textAlignment = .center
        yearLabel.text = "2018"
        yearLabel.font = YodoConfig.font.bold(size: 28)
        return yearLabel
    }()
    
    private lazy var monthLabel: UILabel = {
      
        var monthLabel = UILabel()
        
        return monthLabel
    }()
}

// MARK: Private Methods
extension HomeDateItemCell {
    
    private func setupLayout() {
        
    }
    
}
