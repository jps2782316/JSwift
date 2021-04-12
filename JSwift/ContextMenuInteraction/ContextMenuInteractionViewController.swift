//
//  ContextMenuInteractionViewController.swift
//  JSwift
//
//  Created by jps on 2021/4/12.
//

import UIKit
/*
 iOS开发之上下文交互菜单（UIContextMenuInteraction）
 https://www.jianshu.com/p/2b3815062e0f
 */

class ContextMenuInteractionViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var containerView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let interaction = UIContextMenuInteraction(delegate: self)
        imageView.addInteraction(interaction)
        imageView.isUserInteractionEnabled = true
        
        let interaction2 = UIContextMenuInteraction(delegate: self)
        containerView.addInteraction(interaction2)
        
    }
    
    
    @IBAction func btnClicked(_ sender: Any) {
        let vc = ContextMenuForCollectionVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnClicked2(_ sender: Any) {
    }
    
    
    @IBAction func switchCliked(_ sender: UISwitch) {
        print("点击了switch开关: \(sender.isOn)")
    }
    
    
    ///创建菜单
    private func getMenus() -> UIMenu {
        let favoriteAction = UIAction(title: "喜欢", image: UIImage(systemName: "heart.fill"), state: .mixed) { (action) in
            print("点击了喜欢..")
        }
        let shareAction = UIAction(title: "分享", image: UIImage(systemName: "square.and.arrow.up.fill"), attributes: .disabled, state: .on) { (action) in
            print("点击了分享..")
        }
        let deleteAction = UIAction(title: "删除", image: UIImage(systemName: "trash.fill"), identifier: nil, discoverabilityTitle: "详细标题", attributes: .destructive, state: .off) { (action) in
            print("点击了删除..")
        }
        let menu = UIMenu(title: "菜单", image: nil, identifier: nil, options: .displayInline, children: [favoriteAction, shareAction, deleteAction])
        return menu
    }
    
    //创建子菜单(二级菜单)
    class func getSubMenus() -> UIMenu {
        //1.创建一个二级菜单
        let renameAction = UIAction(title: "Rename Pupper", image: UIImage(systemName: "square.and.pencil")) { action in
            // Show rename UI
        }
        let deleteAction = UIAction(title: "Delete Photo", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
            // Delete this photo 😢
        }
        // The "title" will show up as an action for opening this menu
        let edit = UIMenu(title: "Edit...", image: UIImage(systemName: "square.and.pencil"), children: [renameAction, deleteAction])
        
        //2.创建一个一级菜单
        let shareAction = UIAction(title: "分享", image: UIImage(systemName: "square.and.arrow.up.fill")) { (action) in
            print("点击了分享..")
        }
        
        //3.创建一个分组菜单。
        //创建一个comentMenu，然后设置options属性为displayInline，并将上面的deleteAction添加进来
        let commentAction = UIAction(title: "评论", image: UIImage(systemName: "trash.fill"), state: .off) { (action) in
            print("点击了评论..")
        }
        let comentMenu = UIMenu(title: "删除菜单", options: .displayInline, children: [commentAction])
        
        //4.创建最终菜单 (menu的image只有用来包装二级菜单时才显示)
        let menu = UIMenu(title: "菜单", image: UIImage(systemName: "trash.fill"), identifier: nil, options: .destructive, children: [edit, shareAction, comentMenu])
        return menu
    }
    
}



extension ContextMenuInteractionViewController: UIContextMenuInteractionDelegate {
    
    ///* 默认预览视图
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (elements) -> UIMenu? in
            let menu = ContextMenuInteractionViewController.getSubMenus()
            return menu
        }
        return config
    }//*/
    
    /*
    //自定义预览视图
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil) {[weak self] () -> UIViewController? in
            let detailVC = ContextMenuDetailViewController()
            detailVC.image = self?.imageView.image
            //设置预览视图大小
            detailVC.preferredContentSize = CGSize(width: 300, height: 200)
            return detailVC
        } actionProvider: { (elements) -> UIMenu? in
            let menu = self.getSubMenus()
            return menu
        }
        return config
    }*/
    
    //当用户点击预览图的时候调用
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        animator.addCompletion {[weak self] in
            //点击预览图后，全屏展示图片
            let detailVC = ContextMenuDetailViewController()
            detailVC.image = self?.imageView.image
            self?.show(detailVC, sender: nil)
            //self?.present(detailVC, animated: true, completion: nil)
        }
    }
    
    
}


