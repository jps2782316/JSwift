//
//  SearchItemLayer.swift
//  JSwift
//
//  Created by j on 2021/4/24.
//

import Foundation
import UIKit

class SearchItemLayer: CAShapeLayer {
    
    
    override func draw(in ctx: CGContext) {
        let path = searchPath()
        self.path = path.cgPath
    }
    
//    private func createSearchLayer(indexItem: IndexItem) -> CAShapeLayer {
//        let radius = indexItem.height / 4
//        let margin = indexItem.height / 4
//        let start = radius * 2.5 + margin
//        let end = radius + sin(CGFloat.pi/4) * radius + margin
//        //放大镜贝塞尔曲线
//        let path = UIBezierPath()
//        path.move(to: CGPoint(x: start, y: start))
//        path.addLine(to: CGPoint(x: end, y: end))
//        path.addArc(withCenter: CGPoint(x: radius + margin, y: radius + margin), radius: radius, startAngle: CGFloat.pi/4, endAngle: 2*CGFloat.pi + CGFloat.pi/4, clockwise: true)
//        path.close()
//
//        let layer = CAShapeLayer()
//        layer.fillColor = indexItem.bgColor.cgColor
//        layer.strokeColor = indexItem.textColor.cgColor
//        layer.contentsScale = UIScreen.main.scale
//        layer.lineWidth = indexItem.height / 12
//        layer.path = path.cgPath
//        return layer
//    }
    
    
    
    
    private func searchPath() -> UIBezierPath {
        let radius = bounds.height / 4
        let margin = bounds.height / 4
        let start = radius * 2.5 + margin
        let end = radius + sin(CGFloat.pi/4) * radius + margin
        //放大镜贝塞尔曲线
        let path = UIBezierPath()
        path.move(to: CGPoint(x: start, y: start))
        path.addLine(to: CGPoint(x: end, y: end))
        path.addArc(withCenter: CGPoint(x: radius + margin, y: radius + margin), radius: radius, startAngle: CGFloat.pi/4, endAngle: 2*CGFloat.pi + CGFloat.pi/4, clockwise: true)
        path.close()
        return path
    }
}
