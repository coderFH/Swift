//
//  main.swift
//  17-字面量
//
//  Created by wangfh on 2020/3/14.
//  Copyright © 2020 wangfh. All rights reserved.
//

import Foundation

//MARK: - ------------------------------------字面量协议应用 -------------------------------------
//有点类似于C++中的转换构造函数
extension Int : ExpressibleByBooleanLiteral { //我们让Int去遵守ExpressibleByBooleanLiteral协议,可以用true和false去赋值给Int
    public init(booleanLiteral value: Bool) { self = value ? 1 : 0 }
}
var num: Int = true
print(num) // 1

//CustomStringConvertible是description的协议
class Student : ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral, ExpressibleByStringLiteral, CustomStringConvertible {
    var name: String = ""
    var score: Double = 0
    required init(floatLiteral value: Double) { self.score = value } //使用float对Student进行初始化
    required init(integerLiteral value: Int) { self.score = Double(value) }// 使用Int对Student进行初始化
    
    required init(stringLiteral value: String) { self.name = value } //以下三个都是Sting的协议.包括Unicode编码的字符
    required init(unicodeScalarLiteral value: String) { self.name = value }
    required init(extendedGraphemeClusterLiteral value: String) { self.name = value }
    
    var description: String { "name=\(name),score=\(score)" }
}
var stu: Student = 90
print(stu) // name=,score=90.0 stu = 98.5
print(stu) // name=,score=98.5 stu = "Jack"
print(stu) // name=Jack,score=0.0


struct Point {
    var x = 0.0, y = 0.0
}
extension Point : ExpressibleByArrayLiteral, ExpressibleByDictionaryLiteral {
    init(arrayLiteral elements: Double...) {
        guard elements.count > 0 else { return }
        self.x = elements[0]
        guard elements.count > 1 else { return }
        self.y = elements[1]
    }
    init(dictionaryLiteral elements: (String, Double)...) {
        for (k, v) in elements {
            if k == "x" { self.x = v }
            else if k == "y" { self.y = v }
        }
    }
}
var p: Point = [10.5, 20.5] //我们可以以数组的方式去创建一个Point
print(p) // Point(x: 10.5, y: 20.5)
p = ["x" : 11, "y" : 22]  //也可以以字典的方式去创建一个Pint
print(p) // Point(x: 11.0, y: 22.0)
