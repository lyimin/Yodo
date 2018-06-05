//
//  NumberKeyboardView.swift
//  Yod
//
//  Created by eamon on 2018/6/5.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

class NumberKeyboardView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bounds = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: keyboardHeight)
        
        initView()
    }
    
    convenience init(textField: UITextField) {
        
        self.init(frame: CGRect.zero)
        
        self.textField = textField
        
        textField.inputView = self
        textField.addTarget(self, action: #selector(textFieldChangedEditing), for: .editingChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Getter | Setter
    
    
    /// 字体颜色
    public var fontColor: UIColor! = .black
    
    /// 字体大小
    public var font: UIFont! = YodConfig.font.light(size: 18)
    
    /// 间隙
    public var itemSpace: CGFloat! = 1.0
    
    /// 输入框
    private weak var textField: UITextField!
    
    /// 工具条高度
    private var toolbarHeight: CGFloat = 44
    
    /// 按钮size
    private var kItemSize: CGSize {
        
        let itemW: CGFloat = (UIScreen.main.bounds.width - 2*itemSpace) / 3
        let itemH: CGFloat = (size.height - 3*itemSpace - toolbarHeight) / 4
        return CGSize(width: itemW, height: itemH)
    }
    
    /// 键盘高度
    private var keyboardHeight: CGFloat! {
        return 0.4 * UIScreen.main.bounds.size.height
    }
    
    /// 工具栏
    private lazy var toolbar: UIToolbar = {
        
        var toolbar = UIToolbar()
        toolbar.backgroundColor = .groupTableViewBackground
        
        let flexibleBarBtnItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let finishInputBarBtnItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBtnDidClick))
        toolbar.tintColor = .black
        toolbar.items = [flexibleBarBtnItem, finishInputBarBtnItem]
        
        return toolbar
    }()
    
    ///  键盘
    private lazy var keyboardView: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = itemSpace
        flowLayout.minimumLineSpacing = itemSpace
        flowLayout.sectionInset = UIEdgeInsetsMake(itemSpace, 0, -itemSpace, 0)
        flowLayout.itemSize = kItemSize
        
        var keyboardView = UICollectionView(frame: CGRect(x: 0, y: toolbarHeight, width: size.width, height: size.height-toolbarHeight), collectionViewLayout: flowLayout)
        keyboardView.backgroundColor = .groupTableViewBackground
        keyboardView.delaysContentTouches = false
        keyboardView.delegate = self
        keyboardView.dataSource = self
        keyboardView.registerClass(KeyboardTextCell.self)
        keyboardView.registerClass(KeyboardImageCell.self)
        return keyboardView
    }()
    
    /// 数据源
    private var titleArray: [String] = ["1", "2", "3",
                                        "4", "5", "6",
                                        "7", "8", "9",
                                        "c", "0", "D"]
}

// MARK: - UICollectionViewDelegateFlowLayout | UICollectionViewDataSource
extension NumberKeyboardView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return titleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == titleArray.count - 1 {
            
            let cell = collectionView.dequeueReusableCell(indexPath: indexPath) as KeyboardImageCell
            cell.imageView.image = #imageLiteral(resourceName: "ic_keyboard_delete")
            return cell
        } else {
            
            let cell = collectionView.dequeueReusableCell(indexPath: indexPath) as KeyboardTextCell
            cell.titleLabel.textColor = fontColor
            cell.titleLabel.font = font
            cell.titleLabel.text = titleArray[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.contentView.backgroundColor = YodConfig.color.rgb(red: 224, green: 224, blue: 224)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.contentView.backgroundColor = .white
    }
}

extension NumberKeyboardView {
    
    private func initView() {
        
        addSubview(toolbar)
        addSubview(keyboardView)
        
        toolbar.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo(toolbarHeight)
        }
    }
    
    /// 点击完成按钮
    @objc private func doneBtnDidClick() {
        if let sv = textField.superview {
            sv.endEditing(true)
        } else {
            UIApplication.shared.keyWindow?.endEditing(true)
        }
    }
    
    /// 文本改变时调用
    @objc private func textFieldChangedEditing() {
        
    }
}

class KeyboardTextCell: UICollectionViewCell, Reusable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private(set) lazy var titleLabel: UILabel = {
        
        var titleLabel = UILabel()
        titleLabel.textAlignment = .center
        return titleLabel
    }()
}


class KeyboardImageCell: UICollectionViewCell, Reusable {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(imageView)
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Getter | Setter
    private(set) lazy var imageView: UIImageView = {
        
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
}
