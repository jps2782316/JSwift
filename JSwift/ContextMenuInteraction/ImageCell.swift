//
//  ImageCell.swift
//  JSwift
//
//  Created by jps on 2021/4/12.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    private(set) lazy var imageView = UIImageView()
    
    private lazy var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("\(frame) \n")
        let w = frame.size.width
        let h = frame.size.height
        self.backgroundColor = .yellow
        imageView.frame = CGRect(x: 0, y: 0, width: w, height: h-50)
        self.addSubview(imageView)
        
        label.textAlignment = .center
        label.frame = CGRect(x: 0, y: h - 50, width: w, height: 50)
        self.addSubview(label)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(image: UIImage?, index: Int) {
        imageView.image = image
        label.text = "\(index)"
    }
    
    
}
