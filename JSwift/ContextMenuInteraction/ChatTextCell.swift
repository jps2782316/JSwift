//
//  ChatTextCell.swift
//  JSwift
//
//  Created by jps on 2021/4/13.
//

import UIKit

class ChatTextCell: UITableViewCell {
    
    lazy var chatContentView = UIView()
    lazy var msgLabel = UILabel()
    
    //聊天气泡
    lazy var bgImageView = UIImageView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.contentView.addSubview(chatContentView)
        
        contentView.addSubview(bgImageView)
        //bgImageView.mask = UIImageView()
        bgImageView.image = stretch(UIImage(named: "bubble_full_tail_v2")!)
        bgImageView.tintColor = .red
        bgImageView.backgroundColor = .clear
        
        msgLabel.backgroundColor = .clear
        msgLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(msgLabel)
        NSLayoutConstraint.activate([msgLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20), msgLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0), msgLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20), msgLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20)])
        
//        NSLayoutConstraint.activate([bgImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20), bgImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0), bgImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20), bgImageView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20)])
    }
    
    
    func set(msg: String) {
        msgLabel.text = msg
        msgLabel.sizeToFit()
        //msgLabel.layoutIfNeeded()
        bgImageView.frame = msgLabel.frame
    }
    
    
    
    private func stretch(_ image: UIImage) -> UIImage {
        let center = CGPoint(x: image.size.width / 2, y: image.size.height / 2)
        let capInsets = UIEdgeInsets(top: center.y, left: center.x, bottom: center.y, right: center.x)
        return image.resizableImage(withCapInsets: capInsets, resizingMode: .stretch)
    }
    
}
