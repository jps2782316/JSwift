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
        assertDemo()
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
        
        //存沙盒。有嵌套自定义对象时，会怎样?
    }
    
    
    
    //---------------- assert 断言 ----------------
    /*
     https://swifter.tips/assert/
     断言的另一个优点是它是一个开发时的特性，只有在 Debug 编译的时候有效，而在运行时是不被编译执行的，因此断言并不会消耗运行时的性能。这些特点使得断言成为面向程序员的在调试开发阶段非常合适的调试判断，而在代码发布的时候，我们也不需要刻意去将这些断言手动清理掉，非常方便。

     虽然默认情况下只在 Release 的情况下断言才会被禁用，但是有时候我们可能出于某些目的希望断言在调试开发时也暂时停止工作，或者是在发布版本中也继续有效。我们可以通过显式地添加编译标记达到这个目的。在对应 target 的 Build Settings 中，我们在 Swift Compiler - Custom Flags 中的 Other Swift Flags 中添加 -assert-config Debug 来强制启用断言，或者 -assert-config Release 来强制禁用断言。当然，除非有充足的理由，否则并不建议做这样的改动。如果我们需要在 Release 发布时在无法继续时将程序强行终止的话，应该选择使用 fatalError。
     */
    //断言: 如果条件为false，那么会发生运行时错误程序停止执行。只有在true的情况下才可以继续运行代码。
    //https://blog.qianchia.com/articles/616b8408.html
    func assertDemo() {
        ///摄氏温度转化为开尔文温度，因为绝对零度永远不能达到，所以我们不可能接受一个小于 -273.15 摄氏度的温度作为输入
        func kelvin(from celsius: Double) -> Double {
            let absoluteZero = -273.15 //摄氏温度中绝对零度为: -273.15
            assert(celsius > absoluteZero, "摄氏温度不能低于绝对零度")
            let kelvin = celsius - absoluteZero
            return kelvin
        }
        
        /*
         如果输入-300，则会出发断言，精准停在了assert这一行，并提示了错误信息:
         Assertion failed: 摄氏温度不能低于绝对零度: file JSwift/CommonViewController.swift, line 117
         
         如何不想触发断言?
         断言只在Debug生效，如果是Release就不会触发断言。
         点击Xcode上的项目名，选择`Edit Scheme...`，弹出菜单中选择侧边的`Run`，再选择`Info`，把`Build Configration`的值改为Release，这时再运行，就不会触发断言，直接输出了-26.85这个开尔文温度(这个温度是不合法的，低于觉得温度了)。
         */
        let k = kelvin(from: -300)
        print("摄氏度转化为开尔文温度为: \(k)")
    }
    
    
    //---------------- assert 断言 ----------------
    //如何在 Swift 5 中使用 Result
    //https://juejin.cn/post/6844903805184638990
    
    
    //---------------- 关键字 ----------------
    //https://www.cnswift.org/attributes
    
    
    //---------------- 。。 ----------------
    //view设置isHidden，取alpha是否为0。或者设置alpha为0，取isHidden是否为true
    
    
    //---------------- runtime原理、运用场景，Swizzle Method ----------------
    //objc_getAssociatedObject
}
