//
//  TableViewViewController.swift
//  JSwift
//
//  Created by jps on 2021/4/19.
//

import UIKit

/*
 超简单实现iOS列表的索引功能
 https://juejin.cn/post/6844903550506500104
 */

class TableViewViewController: UIViewController {
    
    var tableView: UITableView!
    
    
    var indexs: [String] = []
    var dataSource: [[String]] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchdata()
        setUI()
    }
    
    
    private func fetchdata() {
        indexs = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
        for index in indexs {
            var arr: [String] = []
            let num = arc4random() % 10 + 1
            for i in 0...num {
                let str = index + "\(i)"
                arr.append(str)
            }
            dataSource.append(arr)
        }
    }
    
    ///根据数据源获得索引    实现索引数组的自动更新
    private func getIndexs(dataSource: [String]) -> [String] {
        var arr: [String] = []
        for str in dataSource {
            if let c = str.first {
                let s = String(c)
                if !arr.contains(s) {
                    arr.append(s)
                }
            }
        }
        return arr
    }
    
    private func setUI() {
        self.view.backgroundColor = .red
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.autoresizingMask = .flexibleHeight
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        
        tableView.sectionIndexMinimumDisplayRowCount = 1
        //索引颜色
        tableView.sectionIndexColor = .blue
        //索引选中时的颜色
        tableView.sectionIndexTrackingBackgroundColor = .yellow
        //索引背景色
        tableView.sectionIndexBackgroundColor = .cyan
        view.addSubview(tableView)
    }
    
}


extension TableViewViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        let str = dataSource[indexPath.section][indexPath.row]
        cell?.textLabel?.text = str
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return indexs[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    // 索引目录
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return indexs
    }
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        print("index: \(index), title: \(title)")
        return index
    }
    
    
    
}


extension TableViewViewController: UITableViewDelegate {
    
}
