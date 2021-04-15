//
//  QRCodeGenerator+Extension.swift
//  JSwift
//
//  Created by j on 2021/4/6.
//

import UIKit

extension QRCodeGenerator {
    
    func drawQRCode(codePoints: [[Bool]], finalSize: CGSize, shapeStyle: QRCode.ShapeStyle, gradientType: QRCode.GradientType) -> UIImage? {
        let h = finalSize.height 
        let delta = h / CGFloat(codePoints.count)
        
        UIGraphicsBeginImageContext(CGSize(width: h, height: h))
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        for indexY in 0..<codePoints.count {
            for indexX in 0..<codePoints[indexY].count {
                let shouldDisplay = codePoints[indexY][indexX]
                if shouldDisplay {
                    drawPoint(context: context, indexX: CGFloat(indexX), indexY: CGFloat(indexY), delta: delta, imgWH: h, gradientType: gradientType, shapeStyle: shapeStyle)
                }
            }
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    
    func drawPoint(context: CGContext, indexX: CGFloat, indexY: CGFloat, delta: CGFloat, imgWH: CGFloat, gradientType: QRCode.GradientType, shapeStyle: QRCode.ShapeStyle) {
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
            bezierPath = UIBezierPath(rect: CGRect(x: indexX * delta, y: indexY * delta, width: delta, height: delta))
        }
        
        //渐变色
        let point1 = CGPoint(x: indexX * delta, y: indexY * delta)
        let point2 = CGPoint(x: (indexX + 1) * delta, y: (indexY + 1) * delta)
        let gradientColors = getGradientColors(startPoint: point1, endPoint: point2, totalW: imgWH, gradientType: gradientType)
        
        //绘制
        if let color1 = gradientColors?.first?.cgColor, let color2 = gradientColors?.last?.cgColor {
            drawLinearGradient(context: context, path: bezierPath.cgPath, startColor: color1, endColor: color2, gradientType: gradientType)
        }
        
    }
    
    
    //MARK: ----------------- 绘制点 -----------------
    
    ///绘制每一个点
    func drawLinearGradient(context: CGContext, path: CGPath, startColor: CGColor, endColor: CGColor, gradientType: QRCode.GradientType) {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let locations: [CGFloat] = [0.0, 1.0]
        /*
        guard let startComponents = startColor.components else { return }
        guard let endComponents = endColor.components else { return }
        let colorComponents = [startComponents[0], startComponents[1], startComponents[2], startComponents[3], endComponents[0], endComponents[1], endComponents[2], endComponents[3]]
        guard let gradient = CGGradient(colorSpace: colorSpace, colorComponents: colorComponents, locations: locations, count: 2) else { return }
        */
        let colors: CFArray = [startColor, endColor] as CFArray
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations) else { return }
        
        let pathRect = path.boundingBox
        var startPoint = CGPoint.zero
        var endPoint = CGPoint.zero
        
        switch gradientType {
        case .diagonal:
            startPoint = CGPoint(x: pathRect.minX, y: pathRect.minY)
            endPoint = CGPoint(x: pathRect.maxX, y: pathRect.maxY)
        case .horizontal:
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
    
    ///计算每个点的渐变色
    func getGradientColors(startPoint: CGPoint, endPoint: CGPoint, totalW: CGFloat, gradientType: QRCode.GradientType) -> [UIColor]? {
        let colors = gradientType.colors
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
        case .horizontal: //水平渐变
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
            
        case .diagonal: //对角渐变
            let startDelta = calculateDiagonal(point: startPoint) / (totalW * totalW)
            let endDelta = calculateDiagonal(point: endPoint) / (totalW * totalW)
            
            //(1 - startDelta) * red1 + startDelta * red2
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
