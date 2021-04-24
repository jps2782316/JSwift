//
//  TableCustomIndexViewController.swift
//  JSwift
//
//  Created by jps on 2021/4/20.
//

import UIKit

class TableCustomIndexViewController: UIViewController {

    var tableView: UITableView!
    
    var indexView: TableViewIndex22!
    
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
        //indexs.insert(searchStr, at: 0)
    }
    
    private func setUI() {
        self.view.backgroundColor = .red
        navigationController?.navigationBar.isTranslucent = false
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.autoresizingMask = .flexibleHeight
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UISearchBar(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 60))
        view.addSubview(tableView)
        
        
        //索引
        let config = IndexConfig(indexItem: .defualt, indicator: .defualt(style: .defualt))
        indexView = TableViewIndex22(config: config, tableView: tableView)
        //indexView.delegate = self
        indexView.frame = CGRect(x: view.bounds.width - 44, y: 0, width: 44, height: view.bounds.height)
        self.view.addSubview(indexView)
        indexView.indexs = indexs
        
        
        let isTranslucent = navigationController?.navigationBar.isTranslucent
        indexView.isTranslucentNavi = isTranslucent ?? false
        
        
    }

}




//extension TableCustomIndexViewController: SectionIndexViewDelegate {
//    func sectionIndexView(_ indexView: SectionIndexView, didSelectSectionAt section: Int) {
//
//    }
//
//    func sectionOfIndexView(_ indexView: SectionIndexView, tableViewDidScroll tableView: UITableView) -> Int {
//        return 0
//    }
//
//
//}




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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        indexView.refreshCurrentSection()
        let rect = tableView.rect(forSection: 2)
        print("\(rect)")
    }
}
