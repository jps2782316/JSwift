//
//  QRCodeRecognizer.swift
//  JSwift
//
//  Created by jps on 2021/4/4.
//

import Foundation
import UIKit

class QRCodeRecognizer {
    
    /// 识别图片中的二维码
    /// - Parameter image: 要识别的图片
    /// - Returns:
    static func recognitionQRCode(image: UIImage) -> [String]? {
        //问题: 从相册读取的可以转成功，
        //注意⚠️: 自己用滤镜生成的二维码图片初始化出来为nil?
        //1. 获取CIImage
        guard let ciImg = CIImage(image: image) else { return nil }
        //2. 创建过滤器
        let context = CIContext(options: nil)
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        //3. 识别二维码
        guard let features = detector?.features(in: ciImg) else { return nil }
        let results: [String] = features.compactMap { (feature) in
            (feature as? CIQRCodeFeature)?.messageString
        }
        return results
    }
    
}
