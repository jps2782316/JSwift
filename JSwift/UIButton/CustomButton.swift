//
//  CustomButton.swift
//  JSwift
//
//  Created by jps on 2021/4/26.
//

import UIKit
/*
 Swift - 自由调整图标按钮中的图标和文字位置（扩展UIButton）
 https://www.hangge.com/blog/cache/detail_960.html
 */

//https://blog.csdn.net/RookieJin/article/details/74639294
class CustomButton: UIControl {
    enum ImagePosition {
        ///图片在文字之前
        case beforeText
        ///图片在文字之后
        case afterText
    }
    
    private var stack: UIStackView!
    private(set) var titleLabel: UILabel!
    private(set) var imageView: UIImageView!
    
    ///图片显示位置
    var style: ImagePosition = .beforeText
    ///水平排列or竖直排列
    var axis: NSLayoutConstraint.Axis = .horizontal
    ///图片与文字的间隔
    var spacing: CGFloat = 12
    
    
    
    /*
    private var title: String?
    private var image: UIImage?
    
    init(title: String?, image: UIImage?) {
        super.init(frame: .zero)
        self.title = title
        self.image = image
    }*/
    
    init(style: ImagePosition, axis: NSLayoutConstraint.Axis, spacing: CGFloat) {
        self.style = style
        self.axis = axis
        self.spacing = spacing
        super.init(frame: .zero)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
    
    private func setUI() {
//        let stackView = UIStackView()
//        stackView.isUserInteractionEnabled = false
//        stackView.axis = .horizontal
//        stackView.spacing = 12
//        self.addSubview(stackView)
//        stackView.snp.makeConstraints { (make) in
//            make.center.equalToSuperview()
//        }
//        
//        imageView = UIImageView()
//        imageView.contentMode = .center
//        stackView.addArrangedSubview(imageView)
//        
//        titleLabel = UILabel()
//        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
//        titleLabel.textColor = UIColor.yl_black1F2329
//        stackView.addArrangedSubview(titleLabel)
    }
    
    
    //MARK: ---------------- button 基础接口 ----------------
    
    // default is nil. title is assumed to be single line
    open func setTitle(_ title: String?, for state: UIControl.State) {
        titleLabel.text = title
    }
    // default is nil. should be same size if different for different states
    open func setImage(_ image: UIImage?, for state: UIControl.State) {
        imageView.image = image
    }
    // default is nil. use opaque white
    open func setTitleColor(_ color: UIColor?, for state: UIControl.State) {
        titleLabel.textColor = color
    }
    
}
