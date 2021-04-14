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
    
    
    init(image: UIImage?) {
        super.init(nibName: nil, bundle: nil)
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        view = imageView
        
        // By setting the preferredContentSize to the image size,
        // the preview will have the same aspect ratio as the image
        if let size = image?.size {
            preferredContentSize = size
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.textAlignment = .center
        label.text = "这是一个自定义的预览视图"
        self.view.addSubview(label)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        label.frame = CGRect(x: 0, y: self.view.bounds.height - 30, width: self.view.bounds.width, height: 30)
    }
    
    
    
}
