//
//  ContextMenuForCollectionVC.swift
//  JSwift
//
//  Created by jps on 2021/4/12.
//

import UIKit

class ContextMenuForCollectionVC: UIViewController {
    
    var collectionView: UICollectionView!
    
    lazy var dataSource: [String] = ["image_0.jpg", "image_1.jpg", "image_2.jpg", "image_3.jpg", "image_4.jpg", "image_5.jpg", "Miku.jpg", "Pikachu.png"]
        
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }

    private func setUI() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 0
        let w = kScreenW - 5 * 2
        flowLayout.itemSize = CGSize(width: w/3.0, height: w/3.0 + 50)
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "cell")
        self.view.addSubview(collectionView)
    }
    
    
}


extension ContextMenuForCollectionVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCell
        cell.set(image: UIImage(named: dataSource[indexPath.item]), index: indexPath.item)
        return cell
    }
    
}


extension ContextMenuForCollectionVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let cell = collectionView.cellForItem(at: indexPath) as! ImageCell
        let image = cell.imageView.image
        let id = indexPath as NSCopying
        
        let config = UIContextMenuConfiguration(identifier: id) { () -> UIViewController? in
            return ContextMenuDetailViewController(image: image)
        } actionProvider: { (elements) -> UIMenu? in
            let menu = ContextMenuInteractionViewController.getSubMenus()
            return menu
        }
        return config
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        var image: UIImage?
        if let indexPath = configuration.identifier as? IndexPath {
            let cell = collectionView.cellForItem(at: indexPath) as! ImageCell
            image = cell.imageView.image
        }
        
        animator.addCompletion {
            let detailVC = ContextMenuDetailViewController(image: image)
            self.show(detailVC, sender: nil)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let indexPath = configuration.identifier as? IndexPath else { return nil }
        let cell = collectionView.cellForItem(at: indexPath) as! ImageCell
        return UITargetedPreview(view: cell.imageView)
    }
    
}
