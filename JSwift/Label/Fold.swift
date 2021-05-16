//
//  Fold.swift
//  JSwift
//
//  Created by jps on 2021/5/13.
//

import Foundation
import UIKit

class Fold {
    /**
     折叠文字、颜色、字体设置。
     */
    var foldText: String?
    var foldTextColor: UIColor?
    var foldFont: UIFont?
    
    /**
     展开文字、颜色、字体设置。
     */
    var packupText: String?
    var packupTextColor: UIColor?
    var packupFont: UIFont?
    
    /**
     label.text因为添加折叠文字被裁剪,重新保存完整的text、attributedText。
     */
    var text: String = ""
    var attributeText: NSAttributedString?
    var foldAttributeText: NSAttributedString?
    
    /**
     绘制区域。
     */
    var foldFrame: CTFrame?
    var packupFrame: CTFrame?
    
    ///label的numberOfLines。
    var numberOfLines: Int = 2
    
    ///折叠后最后一行的index
    var endLineIndex: Int?
    
    ///展开后总行数
    var lineCount: Int = 0
    ///label内容文字字体
    var textFont: UIFont?
    ///label的size
    var labelSize: CGSize = .zero
    ///折叠后的文字高度
    lazy var foldHeight: CGFloat = {
        if numberOfLines == 0 {
            return textHeight
        }else {
            let h = FoldLabel.sizeFor(text: text, font: textFont!, size: CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude), lineBreakMode: .byWordWrapping).height * CGFloat(numberOfLines + 1)
            return h
        }
    }()
    ///展开后的文字高度
    lazy var textHeight: CGFloat = {
        if text.isEmpty { return 0 }
        let h = FoldLabel.sizeFor(text: text, font: textFont!, size: CGSize(width: labelSize.width, height: .greatestFiniteMagnitude), lineBreakMode: .byWordWrapping).height + textFont!.pointSize
        return h
    }()
    ///label是否展开，foldLabel方法调用之后才能生效，默认值为NO
    var isFolded: Bool = false
}
