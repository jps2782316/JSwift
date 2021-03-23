//
//  GenericDictionary.swift
//  JSwift
//
//  Created by jps on 2021/3/23.
//

import Foundation
/*
 总结: 你要用什么占位符作为泛型，你就在尖括号里写这个站位符就行了。
 1. 如果在calss、truct、enum内使用，那么在其类名后加个尖括号，括号中写上你需要的占位符就行了。如果有多个占位符，用逗号隔开。如果占位符需要遵循协议(比如字典的key，需要遵循Hashable协议)，在占位符后面遵循就好了。
 2. 如果在func是用，那么在函数名后面加个尖括号，里面申明占位符就行。
 */

///定义一个泛型字典
struct GenericDictionary<Key: Hashable, Value> {
    private var data: [Key: Value]
    
    init(values: [Key: Value]) {
        self.data = values
    }
    
    //下标用法可看CommonViewController这个类
    
    ///下标的返回类型支持泛型
    subscript<T>(key: Key) -> T? {
        return data[key] as? T
    }
    
    
    /*
     Keys遵循Sequence，就可以用for循环遍历
     where语句申明了Keys里面的每个元素都是Key类型，因为data的键就只能是Key类型，其他类型会报错。
     */
    ///下标类型同样支持泛型
    subscript<Keys: Sequence>(keys: Keys) -> [Value?] where Keys.Iterator.Element == Key {
        var values: [Value?] = []
        for k in keys {
            values.append(data[k])
        }
        return values
    }
}

/*
 常用的系统协议:
 Equatable
 Comparable
 Codable
 
 Sequence
 Hashable
 */



/*写一篇泛型相关文章:
 泛型是什么
 泛型的用法
 运用场景
 优点
 */
