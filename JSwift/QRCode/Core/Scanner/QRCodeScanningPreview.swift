//
//  QRCodeScanningPreview.swift
//  JSwift
//
//  Created by jps on 2021/4/15.
//

import UIKit

class QRCodeScanningPreview: UIView {
    
    //扫码框
    var rectImageView: UIImageView!
    
    //扫描动画
    private var lineLayer: CAShapeLayer!
    private var animation: CABasicAnimation!
    
    //遮罩
    private var maskLayer: CAShapeLayer!
    lazy var maskColor = UIColor.black.withAlphaComponent(0.6) {
        didSet {
            maskLayer.fillColor = maskColor.cgColor
        }
    }
    
    ///扫描范围
    var scanRect: CGRect
    
    
    
    
    
    init(frame: CGRect, scanRect: CGRect) {
        self.scanRect = scanRect
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    ///开始扫描动画
    func startAnimation() {
        lineLayer.isHidden = false
        lineLayer.add(animation, forKey: "lineAnimation")
    }
    
    ///停止扫描动画
    func stopAnimation() {
        lineLayer.isHidden = true
        lineLayer.removeAnimation(forKey: "lineAnimation")
    }
    
    
    
    private func setUI() {
        //遮罩
        let maskPath = UIBezierPath(rect: self.bounds)
        let subPath = UIBezierPath(rect: scanRect).reversing()
        maskPath.append(subPath)
        maskLayer = CAShapeLayer()
        maskLayer.fillColor = maskColor.cgColor
        maskLayer.path = maskPath.cgPath
        self.layer.addSublayer(maskLayer)
        
        //扫描线
        let lineFrame = CGRect(x: scanRect.origin.x, y: scanRect.origin.y, width: scanRect.width, height: 1.5)
        let linePath = UIBezierPath(ovalIn: CGRect(origin: .zero, size: lineFrame.size))
        lineLayer = CAShapeLayer()
        lineLayer.frame = lineFrame
        lineLayer.path = linePath.cgPath
        lineLayer.fillColor = UIColor.white.cgColor
        lineLayer.shadowColor = UIColor.white.cgColor
        lineLayer.shadowRadius = 5
        lineLayer.shadowOffset = CGSize.zero
        lineLayer.shadowOpacity = 1.0
        lineLayer.isHidden = false
        self.layer.addSublayer(lineLayer)
        //扫描动画
        animation = CABasicAnimation(keyPath: "position.y")
        animation.fromValue = lineFrame.origin.y
        animation.toValue = lineFrame.origin.y + scanRect.height
        animation.repeatCount = 100
        animation.autoreverses = true
        animation.duration = 2.0
        
        //扫描框
        rectImageView = UIImageView()
        rectImageView.frame = scanRect
        self.addSubview(rectImageView)
        let layer = getCornerLayer(strokeColor: UIColor.white.cgColor)
        layer.frame = rectImageView.bounds
        rectImageView.layer.insertSublayer(layer, at: 0)
    }
    
    
    //扫描框图层
    private func getCornerLayer(strokeColor: CGColor) -> CAShapeLayer {
        let cornerW: CGFloat = 2.0
        let cornerLength = min(scanRect.size.width, scanRect.size.height) / 12
        let cornerPath = UIBezierPath()
        //左上
        cornerPath.move(to: CGPoint(x: cornerW/2.0, y: 0))
        cornerPath.addLine(to: CGPoint(x: cornerW/2.0, y: cornerLength))
        cornerPath.move(to: CGPoint(x: 0, y: cornerW/2.0))
        cornerPath.addLine(to: CGPoint(x: cornerLength, y: cornerW/2.0))
        //左下
        cornerPath.move(to: CGPoint(x: 0, y: scanRect.height-cornerW/2.0))
        cornerPath.addLine(to: CGPoint(x: cornerLength, y: scanRect.height-cornerW/2.0))
        cornerPath.move(to: CGPoint(x: cornerW/2.0, y: scanRect.height))
        cornerPath.addLine(to: CGPoint(x: cornerW/2.0, y: scanRect.height-cornerLength))
        //右上
        cornerPath.move(to: CGPoint(x: scanRect.width, y: cornerW/2.0))
        cornerPath.addLine(to: CGPoint(x: scanRect.width-cornerLength, y: cornerW/2.0))
        cornerPath.move(to: CGPoint(x: scanRect.width-cornerW/2.0, y: 0))
        cornerPath.addLine(to: CGPoint(x: scanRect.width-cornerW/2.0, y: cornerLength))
        //右下
        cornerPath.move(to: CGPoint(x: scanRect.width-cornerW/2.0, y: scanRect.height))
        cornerPath.addLine(to: CGPoint(x: scanRect.width-cornerW/2.0, y: scanRect.height-cornerLength))
        cornerPath.move(to: CGPoint(x: scanRect.width, y: scanRect.height-cornerW/2.0))
        cornerPath.addLine(to: CGPoint(x: scanRect.width-cornerLength, y: scanRect.height-cornerW/2.0))
        
        let cornerLayer = CAShapeLayer()
        cornerLayer.frame = scanRect
        cornerLayer.path = cornerPath.cgPath
        cornerLayer.lineWidth = cornerW // cornerPath.lineWidth
        cornerLayer.strokeColor = strokeColor
        return cornerLayer
    }
    
    
    
    
    
}
