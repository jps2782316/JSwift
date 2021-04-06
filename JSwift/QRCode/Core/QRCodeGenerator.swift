//
//  QRCodeGenerator.swift
//  JSwift
//
//  Created by jps on 2021/4/4.
//

import Foundation
import UIKit
import CoreGraphics

class QRCodeGenerator: NSObject {
    
    
    
    
    
    
    
    /// 生成二维码
    /// - Parameters:
    ///   - inputStr: 二维码保存的信息 (Limited to at most 1273 characters.)
    ///   - logoImg: 中间logo
    /// - Returns:
    func generateCode(inputStr: String, logo: UIImage?) -> UIImage? {
        // 生成一个二维码图片
        guard let cgImage = generateQRCode(content: inputStr) else { return nil }
        let qrcodeImage = UIImage(cgImage: cgImage)
        
        let qrSize = qrcodeImage.size
        if let icon = logo {
            //logo设置为1/4大小
            let iconSize = CGSize(width: qrSize.width*0.25, height: qrSize.height*0.25)
            //logo圆角、描边
            let finalIcon = clipIcon(icon, iconSize: iconSize)!
            let resultImage = addIconToQRCode(qrcodeImage, icon: finalIcon, qrSize: qrSize, iconSize: iconSize)
            return resultImage
        }
        
        return qrcodeImage
    }
    
    
    
    //MARK: ----------------- qrCode -----------------
    
    
    /// 生成一个二维码图片
    /// - Parameter content: 二维码的内容
    /// - Returns:
    private func generateQRCode(content: String) -> CGImage? {
        //1. 创建一个二维码滤镜
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        //恢复默认设置
        qrFilter.setDefaults()
        //设置生成的二维码的容错率
        qrFilter.setValue("H", forKey: "inputCorrectionLevel")
        
        //2. 设置输入的内容(KVC)
        //注意:key = inputMessage, value必须是Data类型
        let strData = content.data(using: .utf8, allowLossyConversion: false)
        qrFilter.setValue(strData, forKey: "inputMessage")
        
        //3. 从二维码滤镜里面, 获取结果图片
        guard let ciImage = qrFilter.outputImage else { return nil }
        
        //4. 获得一张高清二维码图片
        let cgImage = getHDQRCodeWithContext(qrImage: ciImage, size: CGSize(width: 300, height: 300))
        //let qrcodeImage = getHDQRCodeWithColorFilter(qrImage: qrImg)
        return cgImage
    }
    
    
    
    //MARK: ----------------- 处理原始二维码图片为高清图 -----------------
    
    /// 调用该方法处理图像变清晰
    /// - Parameters:
    ///   - qrImage: 原始二维码图片
    ///   - size: 图片宽度以及高度
    /// - Returns: 高清二维码图片
    private func getHDQRCodeWithContext(qrImage: CIImage, size: CGSize) -> CGImage? {
        let extent = qrImage.extent.integral
        let scale = min(size.width/extent.width, size.width/extent.height)
        
        let width = extent.width * scale
        let height = extent.height * scale
        
        let cgContext = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpaceCreateDeviceGray(), bitmapInfo: CGImageAlphaInfo.none.rawValue)
        let ciContext = CIContext(options: nil)
        let bitmapImage = ciContext.createCGImage(qrImage, from: extent)
        cgContext?.interpolationQuality = CGInterpolationQuality.none
        cgContext?.scaleBy(x: scale, y: scale)
        cgContext?.draw(bitmapImage!, in: extent)
        
        let scaleImage = cgContext?.makeImage()
        return scaleImage
    }
    
    
    /// 使用颜色滤镜获得一张高清图
    /// - Parameter qrImage: 原始二维码图片
    /// - Returns: 高清二维码图片
    private func getHDQRCodeWithColorFilter(qrImage: CIImage) -> UIImage? {
        /*let ciImage = qrImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
        return UIImage(ciImage: ciImage)*/
        // 创建颜色滤镜
        guard let colorFilter = CIFilter(name: "CIFalseColor") else {
            return nil
        }
        colorFilter.setDefaults()
        colorFilter.setValue(qrImage, forKey: "inputImage")
        let color0 = CIColor(red: 1, green: 1, blue: 1, alpha: 1)
        let color1 = CIColor(red: 0, green: 1, blue: 0, alpha: 1)
        colorFilter.setValue(color0, forKey: "inputColor0")
        colorFilter.setValue(color1, forKey: "inputColor1")
        // 借助这个方法, 处理成为一个高清图片(默认放大10倍)
        let ciImg = colorFilter.outputImage?.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
        // 获得一张二维码图片
        if let ciImg = ciImg {
            return UIImage(ciImage: ciImg)
        }
        return nil
    }
    
    
    
    //MARK: ----------------- icon -----------------
    
    /// 添加一个icon到二维码中间
    /// - Parameters:
    ///   - qrImage: 原本的二维码图片
    ///   - icon: 添加到中间的icon
    ///   -  qrsize: 二维码大小
    ///   - iconSize: icon的大小
    /// - Returns:
    private func addIconToQRCode(_ qrImage: UIImage, icon: UIImage, qrSize: CGSize, iconSize: CGSize) -> UIImage? {
        let qrRect = CGRect(x: 0, y: 0, width: qrSize.width, height: qrSize.height)
        let x = (qrRect.width - iconSize.width) / 2.0
        let y = (qrRect.height - iconSize.height) / 2.0
        let iconRect = CGRect(x: x, y: y, width: iconSize.width, height: iconSize.height)
        
        UIGraphicsBeginImageContext(qrRect.size)
        //将二维码绘制到上下文
        qrImage.draw(in: qrRect)
        //icon绘制到上下文
        icon.draw(in: iconRect)
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage
    }
    
    /*
    private func generateQRCode(qrImage: UIImage, iconImage: UIImage, qrSize: CGSize) -> UIImage? {
        //画布的rect
        let qrRect = CGRect(origin: .zero, size: qrSize)
        let iconRect = CGRect(x: 0, y: 0, width: qrSize.width/4.0, height: qrSize.height/4.0)
        
        UIGraphicsBeginImageContextWithOptions(qrSize, true, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.saveGState()
        context.translateBy(x: 0, y: qrSize.height)
        context.scaleBy(x: 1, y: -1)
        // 根据 bgRect 用二维码填充视图 (注意⚠️: 滤镜生成的qrImage转cgImage为空)
        context.draw(qrImage.cgImage!, in: qrRect)
        // 根据logoRect 填充头像区域
        context.draw(iconImage.cgImage!, in: iconRect)
        context.restoreGState()
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage
    }*/
    
        
    /// 处理logo图片，添加圆角、描边
    /// - Parameters:
    ///   - iconImage: logo
    ///   - iconSize: logo大小。头像大小不能大于画布的1/4 （这个大小之内的不会遮挡二维码的有效信息）
    /// - Returns:
    private func clipIcon(_ icon: UIImage, iconSize: CGSize) -> UIImage? {
        guard let cgIcon = icon.cgImage else { return nil }
        
        let outerWidth = iconSize.width / 15.0
        let innerWidth = outerWidth / 10.0
        let cornerRadius = iconSize.width / 5.0
        
        let areaRect = CGRect(x: 0, y: 0, width: iconSize.width, height: iconSize.height)
        let areaPath = UIBezierPath(roundedRect: areaRect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        
        let outerOrigin = outerWidth / 2.0
        let innerOrigin = innerWidth / 2.0 + outerOrigin / 1.2
        let outerRect = areaRect.insetBy(dx: outerOrigin, dy: outerOrigin)
        let innerRect = outerRect.insetBy(dx: innerOrigin, dy: innerOrigin)
        //外层path
        let size1 = CGSize(width: outerRect.size.width/5.0, height: outerRect.size.width/5.0)
        let size0 = CGSize(width: cornerRadius, height: cornerRadius)
        let outerPath = UIBezierPath(roundedRect: outerRect, byRoundingCorners: .allCorners, cornerRadii: size0)
        //内层path
        let size2 = CGSize(width: innerRect.size.width/5.0, height: innerRect.size.width/5.0)
        let innerPath = UIBezierPath(roundedRect: innerRect, byRoundingCorners: .allCorners, cornerRadii: size2)
        //设置画布信息
        UIGraphicsBeginImageContextWithOptions(iconSize, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        // 开启画布
        context.saveGState()
        // 翻转context
        context.translateBy(x: 0, y: iconSize.height)
        context.scaleBy(x: 1, y: -1)
        // 1.先对画布进行裁切
        context.addPath(areaPath.cgPath)
        context.clip()
        // 2.填充背景颜色
        context.addPath(areaPath.cgPath)
        let fillColor = UIColor.red
        context.setFillColor(fillColor.cgColor)
        context.fillPath()
        // 3.执行绘制logo
        context.draw(cgIcon, in: innerRect)
        // 4.添加并绘制白色边框
        context.addPath(outerPath.cgPath)
        context.setStrokeColor(UIColor.white.cgColor)
        context.setLineWidth(outerWidth)
        context.strokePath()
        // 5.白色边框的基础上进行绘制黑色分割线
        context.addPath(innerPath.cgPath)
        context.setStrokeColor(UIColor.black.cgColor)
        context.setLineWidth(innerWidth)
        context.strokePath()
        // 提交画布
        context.restoreGState()
        
        // 从画布中提取图片
        let radiusImage = UIGraphicsGetImageFromCurrentImageContext()
        // 释放画布
        UIGraphicsEndImageContext()
        return radiusImage
    }
    
    
    
}
