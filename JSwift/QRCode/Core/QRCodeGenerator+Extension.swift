//
//  QRCodeGenerator+Extension.swift
//  JSwift
//
//  Created by j on 2021/4/6.
//

import UIKit







extension QRCodeGenerator {

    //MARK: ----------------- 生成矩阵数组 -----------------
    
    /// 取出一张图片指定 pixel 的 RGBA 值，然后将这个值存在二维数组中
    /// - Parameter cgImage: 二维码图片
    /// - Returns:
    func getPixelWith(cgImage: CGImage) -> [[Bool]] {
        
        let width  = cgImage.width
        let height = cgImage.height
        
        //创建一个颜色空间
        let colorSpace = CGColorSpaceCreateDeviceRGB()
                
        // 开辟一段 unsigned char 的存储空间，用 rawData 指向这段内存.
        // 每个 RGBA 色值的范围是 0-255，所以刚好是一个 unsigned char 的存储大小.
        // 每张图片有 height * width 个点，每个点有 RGBA 4个色值，所以刚好是 height * width * 4.
        // 这段代码的意思是开辟了 height * width * 4 个 unsigned char 的存储大小.
        let dataSize = width * height * 4
        var rawData = [UInt8](repeating: 0, count: Int(dataSize))
        //let rawData = UnsafeMutableRawPointer.allocate(byteCount: width * height * 4, alignment: 8)
        
        //每个像素的大小是4字节
        let bytesPerPixel = 4
        //每行字节数
        let bytesPerRow = width * bytesPerPixel
        //一个字节8比特
        let bitsPerComponent = 8
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        
        // 将系统的二维码图片和我们创建的 rawData 关联起来，这样我们就可以通过 rawData 拿到指定 pixel 的内存地址.
        let context = CGContext(data: &rawData, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        var pixels: [[Bool]] = [[]]
        for indexY in 0..<height {
            var arr: [Bool] = []
            for indexX in 0..<width {
                //取出每个pixel的RGBA值，保存到矩阵中
                var byteIndex = bytesPerRow * indexY + indexX * bytesPerPixel
                let red = rawData[byteIndex]
                let green = rawData[byteIndex + 1]
                let blue = rawData[byteIndex + 2]
                
                let shouldDisplay = red == 0 && green == 0 && blue == 0
                arr.append(shouldDisplay)
                
                byteIndex += bytesPerPixel
            }
            pixels.append(arr)
        }
        //free(&rawData)
        return pixels
    }
    
    
    
    func drawWith(codePoints: [[Bool]], size: CGSize, gradientColors: [UIColor], shapeStyle: QRCode.ShapeStyle, gradientType: QRCode.GradientType) -> UIImage? {
        let h = size.height //有多少行像素
        let delta = h / CGFloat(codePoints.count)
        
        //UIGraphicsBeginImageContextWithOptions(CGSize(width: h, height: h), false, 0)
        UIGraphicsBeginImageContext(CGSize(width: h, height: h))
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        for indexY in 0..<codePoints.count {
            for indexX in 0..<codePoints[indexY].count {
                let shouldDisplay = codePoints[indexY][indexX]
                if shouldDisplay {
                    
                }
            }
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    
    func drawPoint(context: CGContext, indexX: CGFloat, indexY: CGFloat, delta: CGFloat, imgWH: CGFloat, colors: [UIColor], gradientType: QRCode.GradientType, shapeStyle: QRCode.ShapeStyle) {
        //点的形状
        var bezierPath: UIBezierPath
        switch shapeStyle {
        case .circle:
            let centerX = indexX * delta + 0.5 * delta
            let centerY = indexY * delta + 0.5 * delta
            let radius = delta * 0.5 - drawPointMargin
            let startAngle: CGFloat = 0
            let endAngle: CGFloat = 2 * CGFloat.pi
            bezierPath = UIBezierPath(arcCenter: CGPoint(x: centerX, y: centerY), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        case .square:
            bezierPath = UIBezierPath(rect: CGRect(x: indexX * delta, y: indexX * delta, width: delta, height: delta))
        }
        
        //渐变色
        let point1 = CGPoint(x: indexX * delta, y: indexY * delta)
        let point2 = CGPoint(x: (indexX + 1) * delta, y: (indexY + 1) * delta)
        let gradientColors = getGradientColors(startPoint: point1, endPoint: point2, totalW: imgWH, colors: colors, gradientType: gradientType)
        
        //绘制
        if let color1 = gradientColors?.first?.cgColor, let color2 = gradientColors?.last?.cgColor {
            drawLinearGradient(context: context, path: bezierPath.cgPath, startColor: color1, endColor: color2, gradientType: gradientType)
            //context.saveGState()
        }
        
    }
    
    
    //MARK: ----------------- 颜色 -----------------
    
    func drawLinearGradient(context: CGContext, path: CGPath, startColor: CGColor, endColor: CGColor, gradientType: QRCode.GradientType) {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let locations: [CGFloat] = [0.0, 1.0]
        
        guard let startComponents = startColor.components else { return }
        guard let endComponents = endColor.components else { return }
        let colorComponents = [startComponents[0], startComponents[1], startComponents[2], endComponents[0], endComponents[1], endComponents[2]]
        
        guard let gradient = CGGradient(colorSpace: colorSpace, colorComponents: colorComponents, locations: locations, count: 2) else { return }
        
        let pathRect = path.boundingBox
        var startPoint = CGPoint.zero
        var endPoint = CGPoint.zero
        
        switch gradientType {
        case .diagonal(_):
            startPoint = CGPoint(x: pathRect.minX, y: pathRect.minY)
            endPoint = CGPoint(x: pathRect.maxX, y: pathRect.maxY)
        case .horizontal(_):
            startPoint = CGPoint(x: pathRect.minX, y: pathRect.midY)
            endPoint = CGPoint(x: pathRect.maxX, y: pathRect.midY)
        case .none: break
        }
        
        context.saveGState()
        context.addPath(path)
        context.clip()
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
        context.restoreGState()
    }
    
    
    
    //MARK: ----------------- 颜色 -----------------
    
    func getGradientColors(startPoint: CGPoint, endPoint: CGPoint, totalW: CGFloat, colors: [UIColor], gradientType: QRCode.GradientType) -> [UIColor]? {
        guard let color1 = colors.first else { return nil }
        let color2 = colors.last ?? color1
        
        guard let components1 = color1.cgColor.components else { return nil }
        guard let components2 = color2.cgColor.components else { return nil }
        
        let red1 = components1[0]
        let green1 = components1[1]
        let blue1 = components1[2]
        
        let red2 = components2[0]
        let green2 = components2[1]
        let blue2 = components2[2]
        
        
        var result: [UIColor]?
        switch gradientType {
        case .horizontal(let _): //水平渐变
            let startDelta = startPoint.x / totalW
            let endDelta = endPoint.x / totalW
            
            let startRed = (1 - startDelta) * red1 + startDelta * red2
            let startGreen = (1 - startDelta) * green1 + startDelta * green2
            let startBlue = (1 - startDelta) * blue1 + startDelta * blue2
            let startColor = UIColor(red: startRed, green: startGreen, blue: startBlue, alpha: 1)
            
            let endRed = (1 - endDelta) * red1 + endDelta * red2
            let endGreen = (1 - endDelta) * green1 + endDelta * green2
            let endBlue = (1 - endDelta) * blue1 + endDelta * blue2
            let endColor = UIColor(red: endRed, green: endGreen, blue: endBlue, alpha: 1)
            
            result = [startColor, endColor]
            
        case .diagonal(let _): //对角渐变
            let startDelta = calculateDiagonal(point: startPoint) / (totalW * totalW)
            let endDelta = calculateDiagonal(point: endPoint) / (totalW * totalW)
            
            let startRed = red1 + startDelta * (red2 - red1)
            let startGreen = green1 + startDelta * (green2 - green1)
            let startBlue = blue1 + startDelta * (blue2 - blue1)
            let startColor = UIColor(red: startRed, green: startGreen, blue: startBlue, alpha: 1)
            
            let endRed = red1 + endDelta * (red2 - red1)
            let endGreen = green1 + endDelta * (green2 - green1)
            let endBlue = blue1 + endDelta * (blue2 - blue1)
            let endColor = UIColor(red: endRed, green: endGreen, blue: endBlue, alpha: 1)
            
            result = [startColor, endColor]
            
        case .none: break
        }
        
        return result
    }
    
    
    //计算对角渐变的点
    func calculateDiagonal(point: CGPoint) -> CGFloat {
        let x = point.x
        let y = point.y
        
        let pi_4 = CGFloat.pi / 4.0
        let tarArcValue = x >= y ? (pi_4 - atan(y/x)) : (pi_4 - atan(x/y))
        let c = cos(tarArcValue) * (x * x + y * y)
        return c
    }
    
    
    
    

}
