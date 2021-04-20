//
//  TableCustomIndexViewController.swift
//  JSwift
//
//  Created by jps on 2021/4/20.
//

import UIKit

class TableCustomIndexViewController: UIViewController {

    var tableView: UITableView!
    
    var indexView: SectionIndexView!
    
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
        let searchStr = UITableView.indexSearch
        indexs.insert(contentsOf: [searchStr, "1", "2", "3"], at: 0)
    }
    
    private func setUI() {
        self.view.backgroundColor = .red
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.autoresizingMask = .flexibleHeight
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        
        let config = SectionIndexConfig(indexItem: .defualt, indicator: .defualt)
        indexView = SectionIndexView(config: config, tableView: tableView)
        indexView.frame = self.view.bounds
        self.view.addSubview(indexView)
        indexView.indexs = indexs
    }

}



extension TableCustomIndexViewController: UITableViewDataSource, UITableViewDelegate {
    
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
    
}
