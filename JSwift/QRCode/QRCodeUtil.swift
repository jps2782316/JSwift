//
//  QRCode.swift
//  JSwift
//
//  Created by jps on 2021/4/2.
//

import Foundation
import UIKit


class QRCodeUtil {
    
    /*
     Swift之二维码的生成、识别和扫描
     https://juejin.cn/post/6844903576817369096
     
     //https://www.hangge.com/blog/cache/detail_909.html
     */
    
    
    
    
    
    /// 识别图片中的二维码
    /// - Parameter image: 需要提取的图片
    /// - Returns:
    static func recognitionQRCode(image: UIImage) -> [String]? {
        //问题: 从相册读取的可以转成功，自己用滤镜生成的初始化出来就为nil?
        //1. 获取CIImage
        let ciImg = CIImage(image: image)!
        //2. 创建过滤器
        let context = CIContext(options: nil)
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        //3. 识别二维码
        guard let features = detector?.features(in: ciImg) as? [CIQRCodeFeature] else { return nil }
        let results: [String] = features.compactMap({ $0.messageString })
        return results
    }
    
    
    
    /// 生成二维码
    /// - Parameters:
    ///   - inputStr: 二维码保存的信息
    ///   - logoImg: 中间logo
    /// - Returns:
    static func generateCode(inputStr: String, logo: UIImage?) -> UIImage? {
        //1. 创建一个二维码滤镜
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        //恢复默认设置
        qrFilter.setDefaults()
        //设置生成的二维码的容错率
        qrFilter.setValue("H", forKey: "inputCorrectionLevel")
        //2. 设置输入的内容(KVC)
        //注意:key = inputMessage, value必须是Data类型
        let strData = inputStr.data(using: .utf8, allowLossyConversion: false)
        qrFilter.setValue(strData, forKey: "inputMessage")
        
        //3. 获取输出的图片
        let qrImg = qrFilter.outputImage
        
        //4. 获得一张二维码图片
        guard let colorFilter = CIFilter(name: "CIFalseColor") else { return nil }
        colorFilter.setDefaults()
        colorFilter.setValue(qrImg, forKey: "inputImage")
        let color0 = CIColor(red: 1, green: 0, blue: 0, alpha: 1)
        let color1 = CIColor(red: 1, green: 0, blue: 1, alpha: 1)
        colorFilter.setValue(color0, forKey: "inputColor0")
        colorFilter.setValue(color1, forKey: "inputColor1")
        let ciImg = colorFilter.outputImage?.transformed(by: CGAffineTransform(scaleX: 5, y: 5))
        let codeImage = UIImage(ciImage: ciImg!)
        
        //5. 中间是否需要加logo
        if let iconImage = logo {
            //将二维码绘制到上下文
            let rect = CGRect(x: 0, y: 0, width: codeImage.size.width, height: codeImage.size.height)
            UIGraphicsBeginImageContext(rect.size)
            codeImage.draw(in: rect)
            //设置logo大小
            let avatarSize = CGSize(width: rect.size.width*0.25, height: rect.size.height*0.25)
            let x = (rect.width - avatarSize.width) * 0.5
            let y = (rect.height - avatarSize.height) * 0.5
            //将logo绘制到上下文
            iconImage.draw(in: CGRect(x: x, y: y, width: avatarSize.width, height: avatarSize.height))
            let resultImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return resultImage
        }
        return codeImage
    }
    
}




