//
//  Layout.swift
//  JSwift
//
//  Created by jps on 2021/4/22.
//

import UIKit

class Layout: NSObject {
    
    var contentFrame: CGRect
    
    var backgroundFrame: CGRect
    
    var itemFrames: [CGRect] = []
    
    
    init(items: [TextItemLayer], config: IndexConfig, bounds: CGRect) {
        //let itemSize = CGSize(width: config.indexItem.textFont.lineHeight, height: config.indexItem.textFont.lineHeight)
        let itemSize = CGSize(width: config.indexItem.height, height: config.indexItem.height)
        var itemFrames: [CGRect] = []
        let x: CGFloat = 0
        var y: CGFloat = 0
        for (_, layer) in items.enumerated() {
            let frame = CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)
            itemFrames.append(frame)
            layer.frame = frame
            y = frame.maxY + config.indexItem.spacing
        }
        self.itemFrames = itemFrames
        
        //height应该是要减掉一个indexItem.spacing才对
        let size = CGSize(width: itemSize.width, height: y)
        let x1 = bounds.width - config.indexItem.height - config.contentInset.right - config.contentOffset.horizontal
        let y1 = (bounds.height - size.height) / 2.0 + config.contentOffset.vertical
        contentFrame = CGRect(x: x1, y: y1, width: size.width, height: size.height)
        
        let top = (config.contentInset.top == CGFloat.greatestFiniteMagnitude) ? 0 : config.contentInset.top
        let bottom = (config.contentInset.bottom == CGFloat.greatestFiniteMagnitude) ? bounds.height : config.contentInset.bottom
        let inset = UIEdgeInsets(top: -top, left: -config.contentInset.left, bottom: -bottom, right: -config.contentInset.right)
        backgroundFrame = contentFrame.inset(by: inset)
    }

}
