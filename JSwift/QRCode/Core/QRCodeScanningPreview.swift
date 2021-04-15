//
//  QRCodeScanningPreview.swift
//  JSwift
//
//  Created by jps on 2021/4/15.
//

import UIKit

class QRCodeScanningPreview: UIView {
    
    //扫码框
    var rectLayer: CAShapeLayer!
    var cornerLayer: CAShapeLayer!
    
    //扫描动画
    private var lineLayer: CAShapeLayer!
    private var animation: CABasicAnimation!
    
    ///扫描范围
    lazy var scanRect: CGRect = {
        //添加中间的探测区域绿框
        let w = kScreenW*(3/4)
        let h = kScreenW*(3/4)
        let scanRect = CGRect(x: (kScreenW - w)/2.0, y: (kScreenH - h)/2.0, width: w, height: h)
        return scanRect
    }()
    
    ///遮罩背景色
    lazy var maskColor = UIColor.black.withAlphaComponent(0.6)
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
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
        let maskLayer = CAShapeLayer()
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
    }
    
    
    
    
    
    
}
