//
//  BillDetailContentView.swift
//  Yod
//
//  Created by eamon on 2018/5/7.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

class BillDetailContentView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    //MARK: - Getter | Setter
    private lazy var backBtn: UIButton = {
        
        let backBtn = UIButton()
        backBtn.setImage(#imageLiteral(resourceName: "ic_white_back"), for: .normal)
        return backBtn
    }()
}
