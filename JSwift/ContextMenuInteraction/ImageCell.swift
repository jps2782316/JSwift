//
//  ImageCell.swift
//  JSwift
//
//  Created by jps on 2021/4/12.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    private(set) lazy var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.frame = frame
        self.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
