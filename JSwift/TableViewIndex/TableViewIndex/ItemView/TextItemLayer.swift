//
//  TextItemLayer.swift
//  JSwift
//
//  Created by jps on 2021/4/22.
//

import Foundation
import UIKit

class TextItemLayer: CATextLayer {
    
    var itemFont: UIFont! {
        didSet {
            //self.font = itemFont.fontName as CFTypeRef
            self.font = CGFont(itemFont.fontName as CFString)
            //设置文字大小
            self.fontSize = itemFont.pointSize
        }
    }
    
    override func draw(in ctx: CGContext) {
        let h = bounds.size.height
        let fontSize = itemFont.lineHeight
        let offsetY = (h - fontSize) / 2.0
        
        ctx.saveGState()
        ctx.translateBy(x: 0, y: offsetY)
        super.draw(in: ctx)
        ctx.restoreGState()
    }
    
}

protocol SectionIndexViewDelegate: class {
    ///点击/滑动索引时，会触发这个方法
    func sectionIndexView(_ indexView: UIControl, didSelectSectionAt section: Int)
    ///
    func sectionOfIndexView(_ indexView: UIControl, tableViewDidScroll tableView: UITableView) -> Int
}
