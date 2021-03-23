//
//  CommonViewController.swift
//  JSwift
//
//  Created by jps on 2021/3/22.
//

import UIKit

class Student: Codable {
    var name: String = ""
    var age: Int = 0
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    subscript(idx: Int) -> String {
        return "afaef"
    }
    
}
//extension Student: Codable { }




class CommonViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        keyPathsDemo()
        codableDemo()
        subscriptDemo()
    }
    
    
    //---------------- 定义下标脚本 ----------------
    /*
     下标脚本（Subscripts）
     https://wiki.jikexueyuan.com/project/swift-language-guide/subscripts.html
     在Swift中自定义下标（Subscripts）
     https://www.devtalking.com/articles/custom-subscripts-in-swift/
     */
    func subscriptDemo() {
        let stu = Student(name: "小黄", age: 23)
        let val = stu[1]
        print("自定义下标返回值: \(val)")
    }
    
    
    
    //---------------- KeyPaths 取值赋值 ----------------
    func keyPathsDemo() {
        let stu = Student(name: "小黄", age: 23)
        /*
        //使用KVC取值 (Swift3 之前)
        let name = stu.value(forKey: "name")
        //使用KVC赋值
        stu.setValue("哈哈", forKey: "name")
        //使用KVC取值 (Swift3)
        let name = stu.value(forKeyPath: #keyPath(User.name))
        //使用KVC赋值
        stu.setValue("hangge.com", forKeyPath: #keyPath(User.name))
        */
        
        // ------ swift4 KeyPath 语法 ------
        //使用KVC取值
        let name = stu[keyPath: \Student.name]
        //使用KVC赋值
        stu[keyPath: \Student.age] = 10
        
        // ------ keyPath也可以定义在外面 ------
        let keypath1 = \Student.name
        let age = stu[keyPath: keypath1]
        
        print("name: \(name), age: \(age)")
    }
    
    
    
    //---------------- Codable 序列化 ----------------
    /*
     如果要将一个对象持久化，需要把这个对象序列化。过去的做法是实现 NSCoding 协议，但实现 NSCoding 协议的代码写起来很繁琐，尤其是当属性非常多的时候。
     Swift4 中引入了 Codable 协议，可以大大减轻了我们的工作量。我们只需要让需要序列化的对象符合 Codable 协议即可，不用再写任何其他的代码。
     */
    
    func codableDemo() {
        let stu = Student(name: "小张", age: 24)
        // 我们可以直接把符合了 Codable 协议的对象 encode 成 JSON 或者 PropertyList。
        //encoded对象
        guard let encodeData = try? JSONEncoder().encode(stu) else { return }
        //从encoded对象获取String
        let jsonStr = String(data: encodeData, encoding: .utf8)
        print("编码后: \(jsonStr!)")
        
        guard let decodedData = try? JSONDecoder().decode(Student.self, from: encodeData) else { return }
        print("解码后, name: \(decodedData.age), age: \(decodedData.age)")
    }
    
}
