//
//  WatermarkMode.swift
//  JSwift
//
//  Created by jps on 2021/4/6.
//

import Foundation
import CoreGraphics

/// Options to specify how watermark position and size for QR code.
@objc public enum EFWatermarkMode: Int {
    /// The option to scale the watermark to fit the size of QR code by changing the aspect ratio of the watermark if necessary.
    case scaleToFill        = 0
    /// The option to scale the watermark to fit the size of the QR code by maintaining the aspect ratio. Any remaining area of the QR code uses the background color.
    case scaleAspectFit     = 1
    /// The option to scale the watermark to fill the size of the QR code. Some portion of the watermark may be clipped to fill the QR code.
    case scaleAspectFill    = 2
    /// The option to center the watermark in the QR code, keeping the proportions the same.
    case center             = 3
    /// The option to center the watermark aligned at the top in the QR code.
    case top                = 4
    /// The option to center the watermark aligned at the bottom in the QR code.
    case bottom             = 5
    /// The option to align the watermark on the left of the QR code.
    case left               = 6
    /// The option to align the watermark on the right of the QR code.
    case right              = 7
    /// The option to align the watermark in the top-left corner of the QR code.
    case topLeft            = 8
    /// The option to align the watermark in the top-right corner of the QR code.
    case topRight           = 9
    /// The option to align the watermark in the bottom-left corner of the QR code.
    case bottomLeft         = 10
    /// The option to align the watermark in the bottom-right corner of the QR code.
    case bottomRight        = 11
    
    /// Calculate the image rect in canvas when using given mode
    public func calculateRectInCanvas(canvasSize size: CGSize, imageSize: CGSize) -> CGRect {
        var finalSize: CGSize = size
        var finalOrigin: CGPoint = CGPoint.zero
        let imageSize: CGSize = imageSize
        switch self {
        case .bottom:
            finalSize = imageSize
            finalOrigin = CGPoint(x: (size.width - imageSize.width) / 2.0, y: 0)
        case .bottomLeft:
            finalSize = imageSize
            finalOrigin = .zero
        case .bottomRight:
            finalSize = imageSize
            finalOrigin = CGPoint(x: size.width - imageSize.width, y: 0)
        case .center:
            finalSize = imageSize
            finalOrigin = CGPoint(x: (size.width - imageSize.width) / 2.0,
                                  y: (size.height - imageSize.height) / 2.0)
        case .left:
            finalSize = imageSize
            finalOrigin = CGPoint(x: 0, y: (size.height - imageSize.height) / 2.0)
        case .right:
            finalSize = imageSize
            finalOrigin = CGPoint(x: size.width - imageSize.width,
                                  y: (size.height - imageSize.height) / 2.0)
        case .top:
            finalSize = imageSize
            finalOrigin = CGPoint(x: (size.width - imageSize.width) / 2.0,
                                  y: size.height - imageSize.height)
        case .topLeft:
            finalSize = imageSize
            finalOrigin = CGPoint(x: 0, y: size.height - imageSize.height)
        case .topRight:
            finalSize = imageSize
            finalOrigin = CGPoint(x: size.width - imageSize.width,
                                  y: size.height - imageSize.height)
        case .scaleAspectFill:
            let scale = max(size.width / imageSize.width,
                            size.height / imageSize.height)
            finalSize = CGSize(width: imageSize.width * scale,
                               height: imageSize.height * scale)
            finalOrigin = CGPoint(x: (size.width - finalSize.width) / 2.0,
                                  y: (size.height - finalSize.height) / 2.0)
        case .scaleAspectFit:
            let scale = max(imageSize.width / size.width,
                            imageSize.height / size.height)
            finalSize = CGSize(width: imageSize.width / scale,
                               height: imageSize.height / scale)
            finalOrigin = CGPoint(x: (size.width - finalSize.width) / 2.0,
                                  y: (size.height - finalSize.height) / 2.0)
        case .scaleToFill:
            break
        }
        return CGRect(origin: finalOrigin, size: finalSize)
    }
}
