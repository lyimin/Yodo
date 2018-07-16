//
//  BillDetailNoteView.swift
//  Yod
//
//  Created by eamon on 2018/7/15.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

class BillDetailNoteView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(coverView)
        addSubview(contentView)
        
        contentView.addSubview(noteLabel)
        contentView.addSubview(countLabel)
        contentView.addSubview(textView)
        contentView.addSubview(cancelBtn)
        contentView.addSubview(saveBtn)
        
        setupLayout()
        
        // 监听键盘
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChang(noti:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide , object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func show() {
        
        textView.becomeFirstResponder()
        UIView.animate(withDuration: 0.2) {
            self.coverView.alpha = 0.5
        }
    }
    
    //MARK: - Getter | Setter
    
    typealias TextChangeCallBack = (_ text: String) -> Void
    
    public var callBack: TextChangeCallBack?
    
    public var content: String! {
        didSet {
            if content != "无" {
                textView.text = content
            }
        }
    }
    
    /// 遮盖层
    private lazy var coverView: UIView = {
        
        var coverView = UIView()
        coverView.isUserInteractionEnabled = false
        coverView.backgroundColor = .black
        coverView.alpha = 0
        return coverView
    }()
    
    private var keyBoardlsVisible: Bool = false
    
    private let contentViewH: CGFloat = 160
    
    private lazy var contentView: UIView = {
        
        var contentView = UIView()
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: width, height: contentViewH), byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10, height: 10))
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = YodConfig.color.background.cgColor
        contentView.layer.insertSublayer(layer, at: 0)
        return contentView
    }()
    
    private lazy var noteLabel: UILabel = {
        
        var noteLabel = UILabel()
        noteLabel.textColor = YodConfig.color.blackTitle
        noteLabel.font = YodConfig.font.bold(size: 18)
        noteLabel.text = "备注"
        
        return noteLabel
    }()
    
    private lazy var textView: UITextView = {
        
        var textView = UITextView()
        textView.delegate = self
        textView.layer.cornerRadius = 5
        textView.textColor = YodConfig.color.blackTitle
        textView.font = YodConfig.font.bold(size: 16)
        return textView
    }()
    
    private lazy var countLabel: UILabel = {
        
        var countLabel = UILabel()
        countLabel.textColor = YodConfig.color.darkGraySubTitle
        countLabel.textAlignment = .right
        countLabel.text = "20"
        countLabel.font = YodConfig.font.bold(size: 16)
        return countLabel
    }()
    
    private lazy var cancelBtn: UIButton = {
        
        var cancelBtn = UIButton()
        cancelBtn.layer.cornerRadius = 5
        cancelBtn.titleLabel?.font = YodConfig.font.bold(size: 16)
        cancelBtn.backgroundColor = YodConfig.color.gary
        cancelBtn.setTitleColor(.white, for: .normal)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return cancelBtn
    }()
    
    private lazy var saveBtn: UIButton = {
        
        var saveBtn = UIButton()
        saveBtn.layer.cornerRadius = 5
        saveBtn.titleLabel?.font = YodConfig.font.bold(size: 16)
        saveBtn.backgroundColor = YodConfig.color.theme
        saveBtn.setTitleColor(.white, for: .normal)
        saveBtn.setTitle("保存", for: .normal)
        saveBtn.addTarget(self, action: #selector(saveBtnDidClick), for: .touchUpInside)
        return saveBtn
    }()
}

// MARK: - UITextViewDelegate
extension BillDetailNoteView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textView.text.length >= 20 && text != "" {
            return false
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
    
        if let text = textView.text {
            countLabel.text = "\(20-text.length)"
        } else {
            countLabel.text = "20"
        }
    }
}


// MARK: - Private Methods
extension BillDetailNoteView {
    
    @objc func dismiss() {
        
        textView.resignFirstResponder()
        UIView.animate(withDuration: 0.2, animations: {
            self.contentView.alpha = 0
            self.coverView.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    @objc func saveBtnDidClick() {
        dismiss()
        let text = textView.text.length == 0 ? "无" : textView.text!
        if let callBack = callBack {
            callBack(text)
        }
    }
    
    @objc private func keyboardWillShow() {
        keyBoardlsVisible = true
    }
    
    @objc private func keyboardWillHide() {
        keyBoardlsVisible = false
    }
    
    
    @objc private func keyboardWillChang(noti: Notification) {
        
        if let userInfo = noti.userInfo {
            
            let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue
            let duration = noti.userInfo![UIKeyboardAnimationDurationUserInfoKey] as? Double
            let keyboardY = value!.cgRectValue.origin.y
            
            if !keyBoardlsVisible && keyboardY == height { return }
            
            let transform = keyboardY == height ? .identity : CGAffineTransform(translationX: 0, y: self.contentViewH-keyboardY)
            UIView.animate(withDuration: duration!) {
                self.contentView.transform = transform
            }
        }
    }
    
    private func setupLayout() {
        
        coverView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(contentViewH)
        }
        
        noteLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(16)
            make.top.equalTo(contentView).offset(8)
            make.size.equalTo(CGSize(width: 50, height: 20))
        }
        
        countLabel.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-16)
            make.top.size.equalTo(noteLabel)
        }
        
        cancelBtn.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(8)
            make.size.equalTo(CGSize(width: 75, height: 35))
            make.bottom.equalTo(contentView).offset(-8)
        }
        
        saveBtn.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-8)
            make.bottom.size.equalTo(cancelBtn)
        }
        
        textView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(8)
            make.right.equalTo(contentView).offset(-8)
            make.bottom.equalTo(cancelBtn.snp.top).offset(-8)
            make.top.equalTo(noteLabel.snp.bottom).offset(8)
        }
    }
}
