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
    private func getPixelWith(cgImage: CGImage) -> [[Bool]] {
        
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
        free(&rawData)
        return pixels
    }
    
    
    

}
