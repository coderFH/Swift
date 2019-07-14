//
//  main.swift
//  05-方法
//
//  Created by Ne on 2019/7/14.
//  Copyright © 2019 wangfh. All rights reserved.
//

import Foundation

//汇编分析类属性(static)是全局变量
/*
 通过汇编可以得出:
 num1的内存地址:0x1000011A8  ( $0xa, 0x605(%rip))
 count的内存地址是:0x1000011b0
 num2的内存地址:0x1000011B8  ( $0xc, 0x5ca(%rip))
 
 由此可知 类中加static修饰的属性是一个全局变量 ,只不过可以加上一个访问控制,比如private,public等
 
 但我们分析汇编的时候 为什么count不像num1和num2那样直观,count还有一个call的调用,因为类属性本质其实是懒加载的
 可以 一步步的跟踪汇编 最后调用dispatch_once
 */
var num1 = 10

class Car1 {
    static var count = 1;
}
Car1.count = 11;

var num = 12;

//MARK: ------------------------------------- 1.方法 -------------------------------------
/*
 枚举、结构体、类都可以定义实例方法、类型方法
    实例方法(Instance Method):通过实例对象调用
    类型方法(Type Method):通过类型调用，用static或者class关键字定义
*/

class Car {
    static var cout = 0
    init() {
        Car.cout += 1
    }
    static func getCount() -> Int {  return cout }
}
let c0 = Car()
let c1 = Car()
let c2 = Car()
print(Car.getCount()) // 3

/*
 self
    在实例方法中代表实例对象
    在类型方法中代表类型
 在类型方法 static func getCount中
    cout 等价于 self.cout == Car.self.cout == Car.cout
 */

//MARK: ------------------------------------- 2.mutating -------------------------------------
/*
 结构体和枚举是值类型，默认情况下，值类型的属性不能被自身的实例方法修改
 在func关键字前加mutating可以允许这种修改行为
 */
struct Point {
    var x = 0.0, y = 0.0
    mutating func moveBy(deltaX: Double, deltaY: Double) {
        x += deltaX
        y += deltaY
        // self = Point(x: x + deltaX, y: y + deltaY)   等价于以上两句
    }
}

enum StateSwitch {
    case low, middle, high
    mutating func next() {
        switch self {
        case .low:
            self = .middle
        case .middle:
            self = .high
        case .high:
            self = .low
        }
    }
}

//MARK: ------------------------------ 3.@discardableResult -------------------------------------
//在func前面加个@discardableResult，可以消除:函数调用后返回值未被使用的警告
struct Point1 {
    var x = 0.0, y = 0.0
    @discardableResult mutating
    func moveX(deltaX: Double) -> Double {
        x += deltaX
        return x
    }
}

var p1 = Point1()
p1.moveX(deltaX: 10)


@discardableResult
func get() -> Int {
    return 10
}
get()
