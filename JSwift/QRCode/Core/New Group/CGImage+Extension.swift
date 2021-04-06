//
//  CGImage+Extension.swift
//  JSwift
//
//  Created by jps on 2021/4/6.
//

import Foundation
import CoreGraphics

extension CGImage {
    //获得一个灰度图
    var grayscale: CGImage? {
        let c = CGContext(data: nil, width: self.width, height: self.height, bitsPerComponent: 8, bytesPerRow: 4*self.width, space: CGColorSpaceCreateDeviceGray(), bitmapInfo: CGImageAlphaInfo.none.rawValue)
        guard let context = c else { return nil }
        context.draw(self, in: CGRect(x: 0, y: 0, width: self.width, height: self.height))
        return context.makeImage()
    }
}
