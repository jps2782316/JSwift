//
//  QRCodeGenerator2.swift
//  JSwift
//
//  Created by jps on 2021/4/6.
//

import Foundation
import UIKit


class QRCodeGenerator2: NSObject {
    
    
    ///生成一个上下文对象
    private func createContext(size: CGSize) -> CGContext? {
        let bitmapInfo = CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
        /*
         width和height要传Int，否则报错:
         Type of expression is ambiguous without more context
         */
        let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: bitmapInfo, releaseCallback: nil, releaseInfo: nil)
        return context
    }
    
    
    
    
    
    func generateQRCode2() -> CGImage? {
        //二维码的大小
        let size = CGSize(width: 256, height: 256)
        let bgColor = UIColor.red.cgColor
        let foregroundColor = UIColor.black.cgColor
        let icon = UIImage(named: "Pikachu")?.cgImage
        let iconSize = CGSize(width: 40, height: 40)
        let watermark = UIImage(named: "Miku")?.cgImage
        let watermarkMode = UIView.ContentMode.scaleAspectFill
        
        guard let context = createContext(size: size) else { return nil }
        
        //绘制水印
        if let watermark = watermark {
            // Draw background with watermark
            drawWatermark(context: context, watermark: watermark, bgColor: bgColor, mode: .scaleAspectFill, watermarkSize: size)
        }else {
            context.setFillColor(bgColor)
            context.fill(CGRect(origin: .zero, size: size))
        }
        
        
        //绘制二维码
        var qrCodeImage: CGImage?
        if let _ = watermark {
            qrCodeImage = createTransparentQRCodeImage(bgColor: bgColor, frontColor: foregroundColor, size: size) //minSuitableSize
        }else {
            qrCodeImage = createQRCodeImage(codes: [[]], bgColor: bgColor, frontColor: foregroundColor, size: size)
        }
        if let image = qrCodeImage {
            context.draw(image, in: CGRect(origin: .zero, size: size))
        }
        
        //添加icon
        if let icon = icon {
            drawIcon(context: context, icon: icon, iconSize: iconSize)
        }
        
        
        let result: CGImage? = context.makeImage()
        
        //灰度模式
        //result = result?.grayscale
        
        return result
    }
    
    
    //透明二维码(有水印时)
    private func createTransparentQRCodeImage(bgColor: CGColor, frontColor: CGColor, size: CGSize) -> CGImage? {
        return nil
    }
    
    //二维码(无水印时)
    private func createQRCodeImage(codes: [[Bool]], bgColor: CGColor, frontColor: CGColor, size: CGSize) -> CGImage? {
        return nil
    }
    
    //水印
    func drawWatermark(context: CGContext, watermark: CGImage, bgColor: CGColor?, mode: EFWatermarkMode, watermarkSize: CGSize) {
        if let bgColor = bgColor {
            context.setFillColor(bgColor)
            context.fill(CGRect(origin: .zero, size: watermarkSize))
        }
        
        let isWatermarkOpaque = false
        if !isWatermarkOpaque {
            guard let codes = generateCodes() else { return }
            if let img = createQRCodeImage(codes: codes, bgColor: bgColor!, frontColor: UIColor.black.cgColor, size: watermarkSize) {
                context.draw(img, in: CGRect(origin: .zero, size: watermarkSize))
            }
        }
        let imageRect = mode.calculateRectInCanvas(canvasSize: watermarkSize, imageSize: CGSize(width: watermark.width, height: watermark.height))
        context.draw(watermark, in: imageRect)
        
    }
    
    //icon
    func drawIcon(context: CGContext, icon: CGImage, iconSize: CGSize) {
        let x = CGFloat(context.width) - iconSize.width
        let y = CGFloat(context.height) - iconSize.height
        let rect = CGRect(origin: CGPoint(x: x/2.0, y: y/2.0), size: iconSize)
        context.draw(icon, in: rect)
    }
    
    
}


extension QRCodeGenerator2 {
    
    private func generateCodes() -> [[Bool]]? {
        return [[]]
    }
    
    
    
    
}
