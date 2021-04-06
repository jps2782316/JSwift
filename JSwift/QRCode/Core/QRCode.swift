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
    
    enum DrawShape {
        /// 正方形
        case square
        /// 圆
        case circle
    }

    enum GradientType {
        /// 纯色
        case none
        /// 水平渐变
        case horizontal
        /// 对角渐变
        case diagonal
    }
    
}




class QRCode {
    
    /// 文本
    var text: String!
    
    /// 二维码中间的logo
    var logo: UIImage?
    
    /// 二维码缩放倍数{27*scale,27*scale}
    var scale: Float = 10
    
    /// 二维码背景颜色
    var backgroundColor: UIColor = UIColor.white
    
    /// 二维码颜色
    var contentColor: UIColor = UIColor.black
    
}




