//
//  main.swift
//  23-Array的常见操作
//
//  Created by wangfh on 2020/3/18.
//  Copyright © 2020 wangfh. All rights reserved.
//

import Foundation

//MARK: - ------------------------------------Array的常见操作-------------------------------------
var arr = [1, 2, 3, 4]
/*
 var arr0 = arr.map { (number) -> Int in
     number * 2
 }
 */
/*
arr.reduce(Result) { (<#Result#>, <#Int#>) -> Result in
    <#code#>
}
var arr44 = arr.reduce(0) {
    (res, value) -> Int in
    return res + value  //这个函数的用法: 第一个参数是你要的结果的初始值,第二个参数是一个闭包 闭包里传的第一个参数是你上次计算返回的结果,第二个参数是每遍历的一个数组的值
}
*/
var arr2 = arr.map { $0 * 2 } // [2, 4, 6, 8]  arr0的简化写法
var arr3 = arr.filter { $0 % 2 == 0 } // [2, 4]
var arr4 = arr.reduce(0) { $0 + $1 } // 10    arr44的简化写法  $0 上一次遍历返回的结果(初始值是0) $1:每次遍历到的数组元素
var arr5 = arr.reduce(0, +) // 10


func double(_ i: Int) -> Int { i * 2 }
var arr6 = [1, 2, 3, 4]
print(arr6.map(double)) // [2, 4, 6, 8] map可以接受一个函数


var arr7 = [1, 2, 3]
var arr8 = arr.map { Array.init(repeating: $0, count: $0) } // [[1], [2, 2], [3, 3, 3]] map返回的是一个泛型的数组,你每次初始化相当于都是创建一个数组,而arr7本来就是个数组,所以最后就是一个二维数组
var arr9 = arr.flatMap { Array.init(repeating: $0, count: $0) }// [1, 2, 2, 3, 3, 3]  他会摊开数组,看源码会发现他返回的是数组的元素SegmentOfResult.Element


var arr10 = ["123", "test", "jack", "-30"]
var arr11 = arr.map { Int($0) } // [Optional(123), nil, nil, Optional(-30)]  将数组中可以转为Int的转化为Int类型
var arr12 = arr.compactMap { Int($0) } // [123, -30]


// 使用reduce实现map、filter的功能
var arr13 = [1, 2, 3, 4]
print(arr13.map { $0 * 2 }) // [2, 4, 6, 8]
var arr113 = arr13.reduce([]) { //[]是初始值,也就是一个空数组,然后数组中每个元素*2之后 添加到arr里,最后返回这个数组
    (arr : Array, value : Int) -> Array<Int> in
    return arr + [value * 2]
}
print("11111",arr113,arr13.reduce([]) { $0 + [$1 * 2] })  //上边arr113的简化写法


print(arr13.filter { $0 % 2 == 0 }) // [2, 4]
print(arr13.reduce([]) { $1 % 2 == 0 ? $0 + [$1] : $0 })

//MARK: - ------------------------------------lazy的优化-------------------------------------
//默认情况下,使用map后,就会马上执行map里闭包的代码,这么做可能影响性能,我们希望在调用到具体某个值的时候再调用
let arr14 = [1, 2, 3]
let result = arr14.lazy.map {
    (i: Int) -> Int in
    print("mapping \(i)")
    return i * 2
}

print("begin-----")
print("mapped", result[0])
print("mapped", result[1])
print("mapped", result[2])
print("end----")
/*
    begin-----
    mapping 1
    mapped 2
    mapping 2
    mapped 4
    mapping 3
    mapped 6
    end----
 */

//MARK: - ------------------------------------Optional的map和flatMap-------------------------------------
var num1: Int? = 10
var num2 = num1.map { $0 * 2 } // Optional(20)
var num3: Int? = nil
var num4 = num3.map { $0 * 2 } // nil


var num5: Int? = 10
var num6 = num1.map { Optional.some($0 * 2) } // Optional(Optional(20))
var num7 = num1.flatMap { Optional.some($0 * 2) }// Optional(20) flatMap如果发现你已经是可选类型了,他不会再包装一层


// num9、num10是等价的
var num8: Int? = 10
var num9 = (num1 != nil) ? (num1! + 10) : nil
var num10 = num1.map { $0 + 10 }

var fmt = DateFormatter()
fmt.dateFormat = "yyyy-MM-dd"
var str: String? = "2011-09-10"

// old
var date1 = str != nil ? fmt.date(from: str!) : nil
// new
var date2 = str.flatMap(fmt.date)


var score: Int? = 98
// old
var str1 = score != nil ? "socre is \(score!)" : "No score"
// new
var str2 = score.map { "score is \($0)" } ?? "No score"

//MARK: - ------------------------------------Optional的map和flatMap的应用-------------------------------------
struct Person {
    var name: String
    var age: Int
}

var items = [
    Person(name: "jack", age: 20),
    Person(name: "rose", age: 21),
    Person(name: "kate", age: 22)
]

// old
func getPerson1(_ name: String) -> Person? {
//    items.firstIndex { (person) -> Bool in
//        person.name == name
//    }
    let index = items.firstIndex { $0.name == name }
    return index != nil ? items[index!] : nil
}

// new
func getPerson2(_ name: String) -> Person? {
    return items.firstIndex { $0.name == name }.map { items[$0] }
}
 

struct Person1 {
    var name: String
    var age: Int
    init?(_ json: [String : Any]) {
        guard let name = json["name"] as? String,
            let age = json["age"] as? Int else { //,号表示条件必须同时成立,跟&&一样
                return nil
        }
        self.name = name
        self.age = age
    }
}

var json: Dictionary? = ["name" : "Jack", "age" : 10]
// old
var p1 = json != nil ? Person1(json!) : nil
// new
var p2 = json.flatMap(Person1.init)




