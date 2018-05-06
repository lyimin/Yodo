//
//  File.swift
//  Yod
//
//  Created by eamon on 2018/5/6.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

class ShapeLabel: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
    }
    
    convenience init(frame: CGRect, _ font: UIFont, fontSize size: CGFloat) {
        self.init(frame: frame)
        
        self.font = font
        self.fontSize = size
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /**
     动画
     */
    func startAnimation() {
        self.layer.addSublayer(pathLayer)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
//        animation.delegate = self
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 0.3
        animation.isRemovedOnCompletion = false
        self.pathLayer.add(animation, forKey: animation.keyPath)
    }
    
    /**
     停止动画
     */
    func stopAnimation() {
        self.pathLayer.removeAllAnimations()
    }
    
    private func setupLayer() -> CAShapeLayer {
        

        // 创建字体
        let letters = CGMutablePath()
        
        let fontName = self.font.fontName as CFString
        let font = CTFontCreateWithName(fontName, self.fontSize, nil)
        let attrString = NSAttributedString(string: animationString, attributes: [NSAttributedStringKey(rawValue: kCTFontAttributeName as String as String): font])
        
        let line = CTLineCreateWithAttributedString(attrString)
        let runArray = CTLineGetGlyphRuns(line)
        // for each RUN
        for runIndex in 0..<CFArrayGetCount(runArray) {
            // Get FONT for this run
            let run = unsafeBitCast(CFArrayGetValueAtIndex(runArray, runIndex), to: CTRun.self)
            let runFont = unsafeBitCast(CFDictionaryGetValue(CTRunGetAttributes(run), unsafeBitCast(kCTFontAttributeName, to: UnsafeRawPointer.self)), to: CTFont.self)
            // for each GLYPH in run
            for runGlyphIndex in 0..<CTRunGetGlyphCount(run) {
                let thisGlyphRange = CFRangeMake(runGlyphIndex, 1)
                var glyph : CGGlyph = CGGlyph()
                var position : CGPoint = CGPoint()
                CTRunGetGlyphs(run, thisGlyphRange, &glyph)
                CTRunGetPositions(run, thisGlyphRange, &position)
                // Get PATH of outline
                let letter = CTFontCreatePathForGlyph(runFont, glyph, nil)
                let t = CGAffineTransform(translationX: position.x, y: position.y)
                letters.addPath(letter!, transform: t)
            }
        }
        
        
        // create path
        let path = UIBezierPath()
        path.move(to: CGPoint.zero)
        path.append(UIBezierPath(cgPath: letters))
        
        let pathLayer = CAShapeLayer()
        pathLayer.frame = self.bounds
        pathLayer.bounds = path.cgPath.boundingBox
        pathLayer.isGeometryFlipped = true
        pathLayer.path = path.cgPath
        pathLayer.strokeColor = UIColor.white.cgColor
        pathLayer.fillColor = nil
        pathLayer.strokeEnd = 1
        pathLayer.lineWidth = 1.0
        pathLayer.lineJoin = kCALineJoinBevel
        return pathLayer
    }
    
    //MARK: - Getter | Setter
    // 做动画的字体
    var animationString : String! {
        didSet {
            self.pathLayer = setupLayer()
        }
    }
    
    // 字体
    var font: UIFont!
    
    // 字体大小
    var fontSize: CGFloat!
    
    // 图层
    private var pathLayer: CAShapeLayer!
}
