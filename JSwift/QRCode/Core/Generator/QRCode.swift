//
//  QRCode.swift
//  JSwift
//
//  Created by jps on 2021/4/6.
//

import Foundation
import UIKit

extension QRCode {
    
    enum CorrectionLevel: String {
        ///低纠正率
        case low = "L"
        ///一般纠正率
        case normal = "M"
        ///较高纠正率
        case superior = "Q"
        ///高纠正率
        case hight = "H"
    }
    
    enum ShapeStyle {
        /// 正方形
        case square
        /// 圆
        case circle
    }
    
    enum GradientType {
        /// 纯色
        case none(_ color: UIColor)
        /// 水平渐变
        case horizontal(_ start: UIColor, _ end: UIColor)
        /// 对角渐变
        case diagonal(_ start: UIColor, _ end: UIColor)
        
        
        var colors: [UIColor] {
            switch self {
            case .horizontal(let start, let end):
                return [start, end]
            case .diagonal(let start, let end):
                return [start, end]
            case .none(let color):
                return [color, color]
            }
        }
        
    }
    
    /*
     放大风格。
     系统生成的二维码是固定大小的，所以scale可以转为具体的customeSize，customeSize也可以转为scale
     */
    enum ScaleSize {
        ///放到到scale倍
        case scale(_ scale: CGFloat)
        ///放大到自定义size。最终会以x,y中最小值转为sale
        case customeSize(_ size: CGSize)
        
        /// 得到二维码的缩放倍数
        /// - Parameter extent: 系统生成的二维码的rect
        /// - Returns: 需要的缩放倍数
        func getValue(extent: CGRect) -> CGFloat {
            switch self {
            case .scale(let scale):
                return scale
            case .customeSize(let size):
                //自定义size转为scale
                let scale = min(size.width/extent.width, size.width/extent.height)
                return scale
            }
        }
    }
    
    
    
}

class QRCode {
    ///纠错级别: 默认高
    var correctionLevel: CorrectionLevel = .hight
    
    
    /// 文本
    var content: String
    /// 二维码中间的logo
    var icon: UIImage?
    /// logo大小，默认二维码的1/4
    var iconScale: CGFloat = 0.25
    /// 二维码颜色
    var color: UIColor
    /// 背景色
    var bgColor: UIColor
    
    init(content: String, icon: UIImage?, iconScale: CGFloat = 0.25, color: UIColor = .black, bgColor: UIColor = .white) {
        self.content = content
        self.icon = icon
        self.iconScale = iconScale
        self.color = color
        self.bgColor = bgColor
    }
}



/*
class QRCode {
    
    
    
    /// 文本
    var text: String
    /// 二维码中间的logo
    //var icon: UIImage?
    var logo: Logo?
    
    ///纠错级别
    var correctionLevel: CorrectionLevel = .hight
    ///绘制形状
    var shapeStyle: ShapeStyle = .square
    ///二维码颜色，默认纯色无渐变
    var color: GradientType = .none(.black)
    
    /// 二维码缩放倍数{27*scale,27*scale}
    var scale: Float = 10
    
    
    
    /// 二维码颜色
    //var color: UIColor = UIColor.black
    
    /// 二维码背景颜色
    var bgColor: UIColor = UIColor.white
    
    
    
    
    
    
    init(content: String) {
        self.text = content
    }
    
}

class GradientQRCode {
    
}


class Logo {
    
    enum ValueStyle {
        case fix(_ value: CGFloat)
        case scale(_ scale: CFloat)
    }
    
    struct Border {
        ///边框颜色
        var color: UIColor
        /*
         边款宽度。默认为logoSize的1/15
         如果为外边框时，可见宽度为: outerWidth - innerWidth
         */
        var width: ValueStyle = .scale(1/15)
        ///边框圆角 (默认为边框宽度的1/5)
        var corner: ValueStyle = .scale(1/2)
    }
    
    ///logo图片
    var image: UIImage
    ///logo大小，默认为二维码大小的1/4
    var size: ValueStyle = .scale(0.25)
    
    ///外边框
    var outerBorder: Border?
    ///那边框
    var innerBorder: Border?
    
    ///绘制logo时的填充色，logo带透明度时，就能看到这个颜色
    var fillColor: UIColor?
    
    
    
    
    init(image: UIImage, size: ValueStyle = .scale(0.25), outerBorder: Border? = nil, innerBorder: Border? = nil, fillColor: UIColor? = nil) {
        self.image = image
        self.size = size
        self.outerBorder = outerBorder
        self.innerBorder = innerBorder
        self.fillColor = fillColor
    }
    
}

*/

