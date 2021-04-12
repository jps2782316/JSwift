//
//  ContextMenuForCollectionVC.swift
//  JSwift
//
//  Created by jps on 2021/4/12.
//

import UIKit

class ContextMenuForCollectionVC: UIViewController {
    
    var collectionView: UICollectionView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }

    private func setUI() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 50, height: 50)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.frame = self.view.bounds
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "cell")
        self.view.addSubview(collectionView)
    }
    
    
}


extension ContextMenuForCollectionVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCell
        cell.imageView.image = UIImage(named: "Miku")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
}


extension ContextMenuForCollectionVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil) {[weak self] () -> UIViewController? in
            return nil
        } actionProvider: { (elements) -> UIMenu? in
            let menu = ContextMenuInteractionViewController.getSubMenus()
            return menu
        }
        return config
    }
    
}
