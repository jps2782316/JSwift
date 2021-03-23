//
//  GenericsViewController.swift
//  JSwift
//
//  Created by jps on 2021/3/22.
//

import UIKit

class User {
    var id: Int = 0
    var name: String = ""
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        if lhs.id == rhs.id &&
            lhs.name == rhs.name {
            return true
        }
        return false
    }
}

/*
 Equatable协议:
 自定义类实现Equatable，可以使用==比较是否相等
 lhs: left-hand side    rhs: right-hand side
 扩展:
 https://juejin.cn/post/6844903705456672782
 ==：它默认比较基本类型的值，比如：Int，String等，它不可以比较引用类型(reference type)或值类型(value type)，除非该类实现了Equatable
 ===:它是检查两个对象是否完全一致(它会检测对象的指针是否指向同一地址)，它只能比较引用类型(reference type)，不可以比较基本类型和值类型(type value)
 
 Comparable协议:
 如果你遵守了Comparable协议，你能重载和使用 <，>，<= 和 >= 操作符
 */


//https://swift.gg/2018/08/28/swift-generics/
class GenericsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        
        genericsFuncDemo()
        genericsSubscriptDemo()
        genericsProtocolDemo()
        
    }
    
    
    ///泛型函数
    func genericsFuncDemo() {
        let intArr: [Int] = [1, 2, 3, 4]
        let b1 = isContain(inta: 1, in: intArr)
        let b_1 = isContain(item: 1, in: intArr)
        print("普通函数: \(b1), 泛型函数: \(b_1)")
        
        let strArr: [String] = ["1", "2", "3", "4"]
        let b2 = isContain(str: "1", in: strArr)
        let b_2 = isContain(item: "1", in: strArr)
        print("普通函数: \(b2), 泛型函数: \(b_2)")
        
        let current = User(id: 1, name: "a")
        let userArr: [User] = [User(id: 1, name: "a"), User(id: 2, name: "b")]
        let b_3 = isContain(item: current, in: userArr)
        print("普通函数: 略, 泛型函数: \(b_3)")
    }
    
    ///泛型下标
    func genericsSubscriptDemo() {
        let dic = GenericDictionary(values: ["name": "Merry", "uid": 666, "age": 20])
        
        // -------- 下标返回值支持泛型 --------
        //自动转换类型，不需要在写 "as? String"，"as? Int"
        let name: String? = dic["name"] //Merry
        let uid: Int? = dic["age"]  //20
        print("name: \(name!), age: \(uid!)")
        
        // -------- 下标支持泛型 --------
        // Array下标  [Optional("Merry"), Optional(20)]
        let nameAndAge = dic[["name", "age"]]
        //Set下标   [Optional("Merry"), Optional(20), nil]
        let nameAndAge2 = dic[Set(["name", "age", "weight"])]
        print("\(nameAndAge), \(nameAndAge2)")
    }
    
    ///泛型协议
    func genericsProtocolDemo() {
        
    }

}


/*
 需求: 假设Swift的数组内置的函数contains不存在，现在需要提供一个函数，判断一个字符串数组是否包含某个特定字符串。
 方案一: 使用普通函数
 方案二: 使用泛型函数
 */



/*
 方案一: 使用普通函数
 实现一个字符串查找函数，遍历查找是否有包含的字符串，有就返回true，没有返回false。
 缺点: 要是后面还需要判断Int、Float、Double甚至一些自定义类数组，是否包含某个对象时，需要不断的实现不同类型的查找函数。要是以后查找方法需要优化，还得每个查找函数都一一改一遍，这简直就是代码维护的地狱。
 */
extension GenericsViewController {
    func isContain(inta: Int, in arr: [Int]) -> Bool {
        for s in arr {
            if s == inta {
                return true
            }
        }
        return false
    }
    
    func isContain(str: String, in arr: [String]) -> Bool {
        for s in arr {
            if s == str {
                return true
            }
        }
        return false
    }
}



/*
 方案二: 使用泛型函数
 优点: 只需写一个方法，任何遵循了Equatable协议的对象数组，都可调用。代码清晰简单，灵活，复用性高，方便维护。
 */
extension GenericsViewController {
    /*
     函数使用一个占位符类型名字(名叫T)而不是真正的类型名，占位符类型名没有指定T必须是什么，但他说明了item和 arr必须是相同的类型T，无论T代表什么，每当isContain(:_:) 函数被调用时，真实的类型用于替代T被确定下来。
     函数中的占位符类型T被称为类型参数，它指定和命名了占位符的类型，直接写在函数名称的后面，在一对尖括号之间。
     */
    func isContain<T: Equatable>(item: T, in arr: [T]) -> Bool {
        for obj in arr {
            if obj == item {
                return true
            }
        }
        return false
    }
    
}


/*
 //协议、泛型
 let intArr: [Int] = [1, 2, 3, 4]
 intArr.contains(1) //true
 intArr.contains { (a) -> Bool in
     return a == 1
 }
 
 
 let strArr: [String] = ["1", "2", "3", "4"]
 strArr.contains("1") //true
 strArr.joined(separator: ",") //"1,2,3,4"
 
 
 let current = User(id: 1, name: "a")
 let userArr: [User] = [User(id: 1, name: "a"), User(id: 2, name: "b")]
 userArr.contains { (u) -> Bool in
     return u.id == current.id
 }
 userArr.contains(current) //true
 /*
  由上可见，intArr、strArr都可以直接调用系统的contains和firstIndex(of:)方法，当然你也可以自己调用闭包去实现。而userArr只能回调一个闭包，自己去实现查找逻辑。点进去看就知道:
  extension Array where Self.Element : Equatable {}
  只有数组元素实现了Equatable协议，才能调用系统实现的contains方法。
  如果要让User数组也能调用系统实现的contains，只需要User实现Equatable协议即可。
  我们再看strArr，它还有其他类型数组没有的方法joined(separator:)，为什么只有String类型的数组才能调用呢，跳进去看一下:
  extension Array where Self.Element == String {
      public func joined(separator: String = "") -> String
  }
  苹果设计的时候就判断了，只有数组原属为String类型时，才可用这个方法。
  借鉴苹果的思路，自己在项目中封装、设计代码时，也能写出水平比较高的代码。
  */
 */
