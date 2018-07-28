//
//  YodCommonNavigationView.swift
//  Yod
//
//  Created by eamon on 2018/7/27.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

class YodCommonNavigationView: UIView {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(backBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Getter | Setter
    
    private(set) lazy var backBtn: UIButton = {
        
        var backBtn = UIButton()
        backBtn.setImage(#imageLiteral(resourceName: "ic_blue_back"), for: .normal)
        return backBtn
    }()

    private(set) lazy var titleLabel: UILabel = {

        var titleLabel = UILabel()
        titleLabel.textColor = YodConfig.color.theme
        titleLabel.font = YodConfig.font.bold(size: 25)
        return titleLabel
    }()
}

extension YodCommonNavigationView {

    private func setupLayout() {

        backBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(25)
            make.top.equalTo(self).offset(40)
            make.size.equalTo(CGSize(width: 23, height: 23))
        }

    }

}
