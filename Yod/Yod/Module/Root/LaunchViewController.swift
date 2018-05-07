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
        view.layer.addSublayer(textLayer)
        
        show()
    }
    
    private func show() {
        
        UIView.animate(withDuration: 0.3) {
            self.icon.alpha = 1
        }
        
        delay(delay: 0.3) {
            self.textAnimation()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        textAnimation()
    }
    
    private func textAnimation() {
        
        let text = "记录每一笔消费，让生活有度"
        let textFont = YodConfig.font.bold(size: 15)
        let attributeText = NSMutableAttributedString(attributedString: NSAttributedString(string: text))
        
        let fontRef = CTFontCreateWithName(textFont.fontName as CFString, textFont.pointSize, nil)
        let attributes = [
            NSAttributedStringKey.foregroundColor: UIColor.white.cgColor,
            NSAttributedStringKey.font: fontRef
            ] as [NSAttributedStringKey : Any]
        
        attributeText.setAttributes(attributes, range: NSMakeRange(0, attributeText.length))
        
        for i in 0..<text.length {

            delay(delay: TimeInterval(0.1*CGFloat(i))) {
                self.changeToBlack(fontRef: fontRef, attributeText: attributeText, index: i)
            }
        }
    }
    
    @objc private func changeToBlack(fontRef: CTFont, attributeText: NSMutableAttributedString, index: Int) {
        
        let attributes = [
            NSAttributedStringKey.foregroundColor: YodConfig.color.blackTitle.cgColor,
            NSAttributedStringKey.font: fontRef
        ] as [NSAttributedStringKey : Any]
        
        attributeText.setAttributes(attributes, range: NSMakeRange(index, 1))
        textLayer.string = attributeText
    }
    
    //MARK: - Getter | Setter
    private var index: Int! = 0
    
    
    private lazy var icon: UIImageView = {
        
        let iconSize: CGFloat = 160
        let iconX: CGFloat = (self.view.width-iconSize)*0.5
        let iconY: CGFloat = (self.view.height-iconSize)*0.5-50
        
        let icon = UIImageView(image: #imageLiteral(resourceName: "ic_logo_launch"))
        icon.frame = CGRect(x: iconX, y: iconY, width: iconSize, height: iconSize)
        icon.alpha = 0
        icon.contentMode = .scaleToFill
        
        return icon
    }()
    
    private lazy var textLayer: CATextLayer = {
        
        let shapeLabelWidth: CGFloat = 200
        let shapeLabelX = (view.width-shapeLabelWidth)*0.5
        let shapeLabelY = icon.frame.maxY + 30
        
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: shapeLabelX, y: shapeLabelY, width: shapeLabelWidth, height: 20)
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.alignmentMode = kCAAlignmentCenter
        textLayer.isWrapped = true
        
        return textLayer
    }()
    
}
