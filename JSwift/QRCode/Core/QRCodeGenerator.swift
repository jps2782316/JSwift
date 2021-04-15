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
    
    ///保存系统亮度
    private var normalBrightness: CGFloat
    
    ///两个点之间的间距
    var drawPointMargin: CGFloat = 2
    
    
    override init() {
        normalBrightness = UIScreen.main.brightness
        super.init()
    }
    
    //MARK: ----------------- Other -----------------
    
    /// 调高屏幕亮度 (进入二维码界面时调用viewDidAppear)
    /// - Parameter brightness: 0.1~1.0之间，值越大越亮
    func brightnessUp(_ brightness: CGFloat = 0.7) {
        UIScreen.main.brightness = brightness
    }
    
    ///恢复原来的屏幕亮度
    func brightnessRecover() {
        UIScreen.main.brightness = normalBrightness
    }
    
    
    //MARK: ----------------- 生成二维码 -----------------
    
    /// 生成纯色二维码
    /// - Parameters:
    ///   - inputStr: 二维码保存的信息 (Limited to at most 1273 characters.)
    ///   - logoImg: 中间logo
    /// - Returns:
    func generateCode(inputStr: String, logo: UIImage?) -> UIImage? {
        //1. 生成一个原始二维码图片 (CIImage)
        guard let originalImage = gennerateOriginalCodeImage(content: inputStr) else { return nil }
        //2. 获得一张高清二维码图片
        guard let cgImage = getHDQRCodeWithContext(qrImage: originalImage, size: CGSize(width: 300, height: 300)) else { return nil }
        //let cgImage = getHDQRCodeWithColorFilter(qrImage: ciImage)
        let qrcodeImage = UIImage(cgImage: cgImage)
        
        //3. 添加logo
        if let icon = logo {
            //logo设置为1/4大小
            let qrSize = qrcodeImage.size
            let iconSize = CGSize(width: qrSize.width*0.25, height: qrSize.height*0.25)
            //处理icon (圆角、描边)
            let finalIcon = clipIcon(icon, iconSize: iconSize)!
            //把二维码和icon绘制成一张图
            //let resultImage = addIconToQRCode(qrcodeImage, icon: finalIcon, qrSize: qrSize, iconSize: iconSize)
            let resultImage = addIconToQRCode(cgImage, icon: finalIcon.cgImage!, qrSize: qrSize, iconSize: iconSize)
            return resultImage
        }
        
        return qrcodeImage
    }
    
    
    ///生成渐变二维码
    func generateGradientCode(str: String) -> UIImage? {
        //1. 生成一个二维码图片
        guard let originalImage = gennerateOriginalCodeImage(content: str) else { return nil }
        guard let cgImage = originalImage.cgImage else { return nil }
        //2. 获得像素点 (这里会有一行是空的，过滤掉，不然二维码的上下留白不对称)
        let codePoints: [[Bool]] = cgImage.pixcels.filter({$0.count > 0})
        
        // 对应纠错率二维码矩阵点数宽度
        let extent = originalImage.extent.size.width
        let size = CGSize(width: extent*50, height: extent*50)
        
        let image = drawQRCode(codePoints: codePoints, finalSize: size, shapeStyle: .circle, gradientType: .horizontal(.red, .blue))
        return image
    }
    /*
     输入的内容不同，originalImage.extent.size也不同,若放大50倍:
     输入"a":
     originalImage.extent.size 为 (23.0, 23.0)
     codePoints.count 为 23
     最终二维码的image.size 为 (1150.0, 1150.0)
     
     输入"aaaaaaa":
     originalImage.extent.size 为 (27.0, 27.0)
     codePoints.count 为 27
     最终二维码的image.size 为 (1350.0, 1350.0)
     
     */
    
    
    //MARK: ----------------- 从系统滤镜获得原始二维码 -----------------
    
    /// 生成一个二维码图片
    /// - Parameter content: 二维码的内容
    /// - Returns:
    private func gennerateOriginalCodeImage(content: String) -> CIImage? {
        //1. 创建一个二维码滤镜 / 条形码滤镜
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
        let ciImage = qrFilter.outputImage
        
        return ciImage
    }
    
    
    
    //MARK: ----------------- 处理原始二维码图片为高清图 -----------------
    
    ///方式一:  调用该方法处理图像变清晰
    /// - Parameters:
    ///   - qrImage: 原始二维码图片
    ///   - size: 图片宽度以及高度
    /// - Returns: 黑白高清二维码图片
    private func getHDQRCodeWithContext(qrImage: CIImage, size: CGSize) -> CGImage? {
        let extent = qrImage.extent.integral
        //自定义size转为scale
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
    
    
    ///方式二:  使用颜色滤镜获得一张高清图
    /// - Parameter qrImage: 原始二维码图片
    /// - Returns: 彩色高清二维码图片
    private func getHDQRCodeWithColorFilter(qrImage: CIImage) -> CGImage? {
        // 创建颜色滤镜
        let colorFilter = CIFilter(name: "CIFalseColor")
        colorFilter?.setDefaults()
        colorFilter?.setValue(qrImage, forKey: "inputImage")
        let color0 = CIColor(red: 1, green: 1, blue: 1, alpha: 1)
        let color1 = CIColor(red: 0, green: 1, blue: 0, alpha: 1)
        colorFilter?.setValue(color0, forKey: "inputColor0")
        colorFilter?.setValue(color1, forKey: "inputColor1")
        
        var ciImage: CIImage
        if let colorQRImage = colorFilter?.outputImage {
            // 借助这个方法, 处理成为一个高清图片(默认放大10倍)。
            // 不放大是很模糊的，可以自己试一下
            ciImage = colorQRImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
        }else {
            //不使用滤镜，直接放大也是可以的，只不过是黑白的
            ciImage = qrImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
        }
        return ciImage.cgImage
    }
    
    
    
    //MARK: ----------------- 二维码和icon合成 -----------------
    
    /// 方式一: 添加一个icon到二维码中间
    /// - Parameters:
    ///   - qrImage: 原本的二维码图片
    ///   - icon: 添加到中间的icon
    ///   -  qrsize: 二维码大小
    ///   - iconSize: icon的大小
    /// - Returns:
    private func addIconToQRCode(_ qrImage: UIImage, icon: UIImage, qrSize: CGSize, iconSize: CGSize) -> UIImage? {
        //画布的rect
        let qrRect = CGRect(x: 0, y: 0, width: qrSize.width, height: qrSize.height)
        //计算icon的frame
        let x = (qrRect.width - iconSize.width) / 2.0
        let y = (qrRect.height - iconSize.height) / 2.0
        let iconRect = CGRect(x: x, y: y, width: iconSize.width, height: iconSize.height)
        
        UIGraphicsBeginImageContextWithOptions(qrRect.size, false, 0)
        //将二维码绘制到上下文
        qrImage.draw(in: qrRect)
        //icon绘制到上下文
        icon.draw(in: iconRect)
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage
    }
    
    ///方式二: 添加一个icon到二维码中间
    private func addIconToQRCode(_ qrImage: CGImage, icon: CGImage, qrSize: CGSize, iconSize: CGSize) -> UIImage? {
        //画布的rect
        let qrRect = CGRect(origin: .zero, size: qrSize)
        //计算icon的frame
        let x = (qrRect.width - iconSize.width) / 2.0
        let y = (qrRect.height - iconSize.height) / 2.0
        let iconRect = CGRect(x: x, y: y, width: iconSize.width, height: iconSize.height)
        
        UIGraphicsBeginImageContextWithOptions(qrSize, true, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.saveGState()
        context.translateBy(x: 0, y: qrSize.height)
        context.scaleBy(x: 1, y: -1)
        // 根据 bgRect 用二维码填充视图 (注意⚠️: 滤镜生成的qrImage转cgImage为空)
        context.draw(qrImage, in: qrRect)
        // 根据logoRect 填充头像区域
        context.draw(icon, in: iconRect)
        context.restoreGState()
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage
    }
    
        
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
        let outerPath = UIBezierPath(roundedRect: outerRect, byRoundingCorners: .allCorners, cornerRadii: size1)
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
