//
//  ContextMenuDetailViewController.swift
//  JSwift
//
//  Created by jps on 2021/4/12.
//

import UIKit

class ContextMenuDetailViewController: UIViewController {
    
    var image: UIImage? {
        didSet { imageView.image = image }
    }
    private lazy var imageView = UIImageView()
    
    private lazy var label = UILabel()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.contentMode = .scaleAspectFill
        self.view.addSubview(imageView)
        
        label.textAlignment = .center
        label.text = "这是一个自定义的预览视图"
        self.view.addSubview(label)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.frame = self.view.bounds
        label.frame = CGRect(x: 0, y: self.view.bounds.height - 30, width: self.view.bounds.width, height: 30)
    }
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        
    }
    
    
}
