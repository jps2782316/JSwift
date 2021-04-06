//
//  QRCode.swift
//  JSwift
//
//  Created by jps on 2021/4/6.
//

import Foundation
import UIKit

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
