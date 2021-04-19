//
//  ViewController.swift
//  JSwift
//
//  Created by jps on 2021/3/22.
//

import UIKit

enum DataType: String {
    case generics = "Generics"
    case `protocol` = "Protocol"
    case other = "Other"
    case tableView = "tableView"
}



class ViewController: UIViewController {
    
    private lazy var dataSource: [DataType] = {
        let arr: [DataType] = [.generics, .protocol, .other, .tableView]
        return arr
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableView = UITableView()
        tableView.frame = UIScreen.main.bounds
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        let type = dataSource[indexPath.row]
        cell?.textLabel?.text = type.rawValue
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = dataSource[indexPath.row]
        switch type {
        case .generics:
            //let vc = GenericsViewController()
            //self.navigationController?.pushViewController(vc, animated: true)
            let vc = ContextMenuInteractionViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case .protocol:
            let vc = ProtocolViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case .other:
            let vc = QRCodeViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            //vc.modalPresentationStyle = .fullScreen
            //self.present(vc, animated: true, completion: nil)
        
            //let vc = CommonViewController()
            //self.navigationController?.pushViewController(vc, animated: true)
        case .tableView:
            let vc = TableViewViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
