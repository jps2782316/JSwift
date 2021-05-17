//
//  FoldLabelViewController.swift
//  JSwift
//
//  Created by jps on 2021/5/13.
//

import UIKit
/*
 如何实现一个 AttributedLabel
 http://hawk0620.github.io/blog/2017/11/27/attributed-label/
 
 YYText 中的 CoreText
 https://blog.jonyfang.com/2019/11/07/2019-11-07-yytext/
 
 swift判断 UILabel文字是否被折叠 是否有省略号 是否没显示全
 https://www.cnblogs.com/huangzhenwei/p/9760863.html
 
 创建一个UITextView，选中一部分range，然后查看视图层级，研究系统类是怎么实现的。自己早轮子。
 */

class FoldLabelViewController: UIViewController {
    private var tableView: UITableView!
    
    lazy var dataSource: [String] = {
        let arr = ["新浪科技讯北京时间7月31日凌晨消息，苹果公司股价在纳斯达克常规交易中下跌0.90美元，报收于208.78美元，跌幅为0.43%，财报发布后，在随后截至美国东部时间周二下午5点01分（北京时间周三凌晨5点01分）为止的盘后交易中，苹果股价上涨4.13%。过去52周，苹果公司的最高价为233.47美元，最低价为142.00美元。",
            "NSDecimalNumber可以定制四种精度的取正类型分别是：向上取正、向下取正、四舍五入和特殊的四舍五入（碰到保留位数后一位的数字为5时，根据前一位的奇偶性决定。为偶时向下取正，为奇数时向上取正如：1.25保留1为小数。5之前是2偶数向下取正1.2；1.35保留1位小数时。5之前为3奇数，向上取正1.4）。",
            "5月28日消息，昨日比特币创下价格新高，突破8845美元，市值达到1568亿美元，创下了比特币价格和市值12个月来的最高纪录。",
            "hello word hi good morning we have has a test hello word hi good morning we have has a test hello word hi good morning we have has a test hello word hi good morning we have has a test"]
        return arr
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FoldLabelCell.self, forCellReuseIdentifier: "cell")
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        view.addSubview(tableView)
        
//        let label = FoldView()
//        label.frame = CGRect(x: 0, y: 100, width: 340, height: 100)
//        self.view.addSubview(label)
    }
    
    
    private func setUI2() {
        let truncationToken = NSAttributedString(string: "查看更多", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.blue])
    }
}


extension FoldLabelViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FoldLabelCell
        let str = dataSource[indexPath.row]
        cell.label.setFoldText(str, width: UIScreen.main.bounds.width) {[weak self] (isfold, currentHeight) in
            self?.tableView.reloadData()
        }
        return cell
    }
}
