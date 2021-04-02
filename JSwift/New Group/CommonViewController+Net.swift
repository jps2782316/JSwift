//
//  CommonViewController+Net.swift
//  JSwift
//
//  Created by jps on 2021/4/1.
//

import Foundation
import Network

extension CommonViewController {
    //iOS App Extension 介绍
    //https://blog.csdn.net/LOLITA0164/article/details/79006272
    
    //Swift - UserNotifications框架使用详解7（自定义通知详情视图）
    //https://www.hangge.com/blog/cache/detail_1855.html
    //https://www.jianshu.com/p/b74e52e866fc
    
    func f() {
        let connection = NWConnection(host: "", port: 999, using: .tcp)
        connection.stateUpdateHandler = { state in
            switch state {
            case .ready:
                print("链接成功")
            case .waiting(let error):
                print("等待连接: \(error)")
            case .failed(let error):
                print("连接失败: \(error)")
            default:
                break
            }
        }
        connection.start(queue: .global())
        //connection.send(content: <#T##Data?#>, contentContext: <#T##NWConnection.ContentContext#>, isComplete: <#T##Bool#>, completion: NWConnection.SendCompletion)
        connection.receiveMessage { (data, context, b, error) in
            
        }
    }
    
}
