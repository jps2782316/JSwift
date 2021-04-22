//
//  IndexView.swift
//  JSwift
//
//  Created by jps on 2021/4/22.
//

import UIKit

class IndexView: UIView {

    var items: [TextItemLayer]?
    
    var layout: Layout?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
    
    private func setUI() {
        self.isUserInteractionEnabled = false
    }
    
    
    
    func addItmes(_ items: [TextItemLayer]) {
        self.items = items
        //移除旧的
        //添加新的
        for (_, item) in items.enumerated() {
            self.layer.addSublayer(item)
        }
        
    }
    
    /*
    private func removeItem(_ item: TextItemLayer) {
        self.layer.addSublayer(item)
        
        // Make the item appear with a nice fade in animation when performed inside an animation block
        // (e.g. when the keyboard shows up)
        UIView.performWithoutAnimation {
            item.frame = frame
            item.alpha = 0
        }
        item.alpha = 1
    }
    
    private func removeItem(_ item: TextItemLayer) {
//        CATransaction.setCompletionBlock {
//            item.alpha = 1
//            item.removeFromSuperview()
//        }
//        item.alpha = 0
    }*/

}
