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
    
    /*
     放大风格。
     系统生成的二维码是固定大小的，所以scale可以转为具体的customeSize，customeSize也可以转为scale
     */
    enum ScaleStyle {
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
    
    /// 文本
    var text: String!
    
    /// 二维码中间的logo
    var icon: UIImage?
    
    /// 二维码缩放倍数{27*scale,27*scale}
    var scale: Float = 10
    
    /// 二维码背景颜色
    var backgroundColor: UIColor = UIColor.white
    
    /// 二维码颜色
    var contentColor: UIColor = UIColor.black
    
}




