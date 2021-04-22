//
//  IndexBackgroudView.swift
//  JSwift
//
//  Created by jps on 2021/4/22.
//

import UIKit

class IndexBackgroudView: UIView {

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
}
