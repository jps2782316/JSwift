//
//  IndexConfig.swift
//  JSwift
//
//  Created by jps on 2021/4/20.
//

import UIKit

class SectionIndexConfig: NSObject {
    
    ///索引栏背景色
    var backgroundColor: UIColor?
    ///索引栏高亮时的背景色
    var trackingBackgroundColor: UIColor?
    
    ///索引内容视图和北京视图的边距
    var contentInset: UIEdgeInsets = .zero
    var contentOffset: UIOffset = .zero
    
    ///索引元素配置
    var indexItem: IndexItem
    ///指示器配置
    var indicator: Indicator?
    
    
    init(indexItem: IndexItem, indicator: Indicator, backgroundColor: UIColor? = nil , trackingBackgroundColor: UIColor? = nil) {
        self.indicator = indicator
        self.indexItem = indexItem
        self.backgroundColor = backgroundColor
        self.trackingBackgroundColor = trackingBackgroundColor
    }
    
    
}

///指示器风格
enum IndicatorStyle {
    ///指向选中的索引位置
    case `defualt`
    ///中间显示一个toast
    case toast
}

class Indicator {
    ///索引提示风格
    var style: IndicatorStyle = .defualt
    ///指示器背景颜色
    var bgColor: UIColor = .yellow
    ///指示器文字颜色
    var textColor: UIColor = .black
    ///指示器文字字体
    var textFont: UIFont
    ///指示器高度
    var height: CGFloat
    ///指示器距离右边屏幕距离（default有效）
    var rightMargin: CGFloat
    ///指示器圆角半径（centerToast有效）
    var cornerRadius: CGFloat
    
    init(style: IndicatorStyle, bgColor: UIColor, textColor: UIColor, textFont: UIFont, height: CGFloat, rightMargin: CGFloat, cornerRadius: CGFloat) {
        self.style = style
        self.bgColor = bgColor
        self.textColor = textColor
        self.textFont = textFont
        self.height = height
        self.rightMargin = rightMargin
        self.cornerRadius = cornerRadius
    }
    
    static func defualt(style: IndicatorStyle) -> Indicator {
        var backgroundColor: UIColor
        var font: UIFont
        var height: CGFloat
        switch style {
        case .defualt:
            backgroundColor = UIColor.lightGray
            font = UIFont.systemFont(ofSize: 38)
            height = 50
        case .toast:
            backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
            font = UIFont.systemFont(ofSize: 60)
            height = 120
        }
        let indicator = Indicator(style: style, bgColor: backgroundColor, textColor: .white, textFont: font, height: height, rightMargin: 40, cornerRadius: 10)
        return indicator
    }
    
}


struct IndexItem {
    ///索引元素背景颜色
    var bgColor: UIColor
    ///索引元素选中时背景颜色
    var selectedBgColor: UIColor
    ///索引元素文字颜色
    var textColor: UIColor
    ///索引元素选中时文字颜色
    var selectedTextColor: UIColor
    ///索引元素文字字体
    var textFont: UIFont
    ///索引元素选中时文字字体
    var selectedTextFont: UIFont?
    ///索引元素高度
    var height: CGFloat
    ///索引元素距离右边屏幕距离
    var rightMargin: CGFloat
    ///索引元素之间间隔距离
    var spacing: CGFloat
    
    init(bgColor: UIColor, selectedBgColor: UIColor, textColor: UIColor, selectedTextColor: UIColor, textFont: UIFont, selectedTextFont: UIFont?, height: CGFloat, rightMargin: CGFloat, spacing: CGFloat) {
        self.bgColor = bgColor
        self.selectedBgColor = selectedBgColor
        self.textColor = textColor
        self.selectedTextColor = selectedTextColor
        self.textFont = textFont
        self.selectedTextFont = selectedTextFont
        self.height = height
        self.rightMargin = rightMargin
        self.spacing = spacing
    }
    
    
    static var defualt: IndexItem {
        let indexItem = IndexItem(bgColor: .clear, selectedBgColor: .green, textColor: .gray, selectedTextColor: .white, textFont: UIFont.systemFont(ofSize: 12), selectedTextFont: nil, height: 15, rightMargin: 5, spacing: 0)
        return indexItem
    }
}
