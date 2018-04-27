//
//  UIView+Load.swift
//  Yodo
//
//  Created by eamon on 2018/4/27.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit


extension UIView {
    
    func showProgress () {
        let progressView = UIActivityIndicatorView()
        progressView.activityIndicatorViewStyle = .gray
        progressView.hidesWhenStopped = true
        progressView.tag = 500
        self.addSubview(progressView)
        
        progressView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.height.width.equalTo(30)
        }
        
        progressView.startAnimating()
    }
    
    func hiddenProgress() {
        for view in self.subviews {
            if view.tag == 500 {
                let indicatorView : UIActivityIndicatorView = view as! UIActivityIndicatorView
                indicatorView.stopAnimating()
                indicatorView.removeFromSuperview()
            }
        }
    }
}
