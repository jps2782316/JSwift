//
//  ContextMenuForTableViewController.swift
//  JSwift
//
//  Created by jps on 2021/4/13.
//

import UIKit

class ContextMenuForTableViewController: UIViewController {
    
    var tableView: UITableView!
    
    var chats = ["hello word", "hello python", "c++ is good", "swift so nice", "build software", "better", "together"]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    

    private func setUI() {
        tableView = UITableView()
        tableView.frame = self.view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(ChatTextCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
    }

}



extension ContextMenuForTableViewController: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ChatTextCell
        cell.set(msg: chats[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let id = indexPath as NSCopying
        let config = UIContextMenuConfiguration(identifier: id) { () -> UIViewController? in
            return nil
        } actionProvider: { (elements) -> UIMenu? in
            let menu = ContextMenuInteractionViewController.getSubMenus()
            return menu
        }
        return config
    }
    
    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        if let indexPath = configuration.identifier as? IndexPath {
            let str = chats[indexPath.row]
            print("聊天消息: \(str)")
        }
    }
    
    //设置 表格视图中的自定义预览
    func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        //TODO: 消息气泡那种效果,仿系统信息的效果
        guard let indexPath = configuration.identifier as? IndexPath else { return nil }
        let cell = tableView.cellForRow(at: indexPath) as! ChatTextCell
        return UITargetedPreview(view: cell.bgImageView)
    }
}
