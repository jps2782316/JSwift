//
//  FoldLabelCell.swift
//  JSwift
//
//  Created by jps on 2021/5/14.
//

import UIKit

class FoldLabelCell: UITableViewCell {
    var label: FoldLabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        label = FoldLabel()
        label.numberOfLines = 0
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        let constraints: [NSLayoutConstraint] = [
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20)
        ]
        NSLayoutConstraint.activate(constraints)
        
        let model = Fold()
        model.foldText = "更多"
        model.foldTextColor = .blue
        model.foldFont = UIFont.systemFont(ofSize: 18)
        model.packupText = "收起"
        model.packupTextColor = .blue
        model.packupFont = UIFont.systemFont(ofSize: 18)
        
        model.textFont = UIFont.systemFont(ofSize: 10)
        label.model = model
    }
}
