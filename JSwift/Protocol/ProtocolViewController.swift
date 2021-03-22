//
//  ProtocolViewController.swift
//  JSwift
//
//  Created by jps on 2021/3/22.
//

import UIKit

class ProtocolViewController: UIViewController {
    /*
     https://swiftgg.gitbook.io/swift/swift-jiao-cheng/21_protocols
     注意
     实现协议中的 mutating 方法时，若是类类型，则不用写 mutating 关键字。而对于结构体和枚举，则必须写 mutating 关键字。
     */

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        enum SkillLevel: Comparable {
            case beginner
            case intermediate
            case expert(stars: Int)
        }
        var levels = [SkillLevel.intermediate, SkillLevel.beginner,
                      SkillLevel.expert(stars: 5), SkillLevel.expert(stars: 3)]
        for level in levels.sorted() {
            print(level)
        }
    }
    

    

}
