//
//  YodTextField.swift
//  Yod
//
//  Created by eamon on 2018/6/6.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

class YodTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        inputAccessoryView = UIView(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        UIMenuController.shared.isMenuVisible = false
        return false
    }
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect(x: -20, y: -20, width: 0, height: 0)
    }

    override func selectionRects(for range: UITextRange) -> [Any] {
        return []
    }

}
