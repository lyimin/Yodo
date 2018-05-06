//
//  LaunchViewController.swift
//  Yod
//
//  Created by eamon on 2018/5/6.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit


class LaunchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        view.addSubview(icon)
        view.addSubview(shapeLabel)
        
        show()
    }
    
    private func show() {
        
        UIView.animate(withDuration: 0.3) {
            self.icon.alpha = 1
        }
        
        delay(delay: 0.3) {
            self.shapeLabel.startAnimation()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.shapeLabel.stopAnimation()
        self.shapeLabel.startAnimation()
    }
    
    //MARK: - Getter | Setter
    private lazy var icon: UIImageView = {
        
        let iconSize: CGFloat = 50
        let iconX: CGFloat = (self.view.width-iconSize)*0.5
        let iconY: CGFloat = (self.view.height)*0.5-30
        
        let icon = UIImageView(image: #imageLiteral(resourceName: "ic_logo_launch"))
        icon.frame = CGRect(x: iconX, y: iconY, width: iconSize, height: iconSize)
        icon.alpha = 0
        icon.contentMode = .scaleAspectFit
        
        return icon
    }()
    
    private lazy var shapeLabel: ShapeLabel = {
        
        let shapeLabelWidth: CGFloat = 175
        let shapeLabelX = (view.width-shapeLabelWidth)*0.5
        let shapeLabelY = icon.frame.maxY + 25
        
        let shapeLabelFrame = CGRect(x: shapeLabelX, y: shapeLabelY, width: shapeLabelWidth, height: 17)
        let shapeLabel = ShapeLabel(frame: shapeLabelFrame, YodConfig.font.bold(size: 13), fontSize: 13);
        shapeLabel.animationString = "记录每一笔消费，让生活有度"
        return shapeLabel;
    }()
    
    
    /*
    private lazy var textLabel: UILabel = {
        
        let textLabel = UILabel()
        textLabel.alpha = 0
        textLabel.textColor = YodConfig.color.darkGraySubTitle
        textLabel.textAlignment = .center
        textLabel.text = "记录每一笔消费，让生活有度"
        textLabel.font = YodConfig.font.bold(size: 13)
        
        return textLabel
    }()
    */
}
