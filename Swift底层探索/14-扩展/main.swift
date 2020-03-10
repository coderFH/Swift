//
//  main.swift
//  14-扩展
//
//  Created by wangfh on 2020/3/10.
//  Copyright © 2020 wangfh. All rights reserved.
//

import Foundation

//MARK: ------------------------------------- 扩展(Extension) -------------------------------------
/*
 Swift中的扩展，有点类似于OC中的分类(Category)
 
 扩展可以为枚举、结构体、类、协议添加新功能
    可以添加方法、计算属性、下标、(便捷)初始化器、嵌套类型、协议等等
 
 扩展不能办到的事情
    不能覆盖原有的功能
    不能添加存储属性，不能向已有的属性添加属性观察器
    不能添加父类
    不能添加指定初始化器，不能添加反初始化器(deinit)
 */

extension Double { //可以为系统的类添加计算属性
    var km: Double { self * 1_000.0 } //只读的计算属性
    var m: Double { self }
    var dm: Double { self / 10.0 }
    var cm: Double { self / 100.0 }
    var mm: Double { self / 1_000.0 }
}

var d = 100.0
print(d.km)
print(d.m)
print(d.dm)
print(d.cm)
print(d.mm)

//为array添加一个下标的方法,当越界时返回nil,没有返回正常的元素,
extension Array {
    subscript(nullable idx: Int) -> Element? { // Element? 表明原有类的泛型在扩展依然好使
        if (startIndex..<endIndex).contains(idx) {//startIndex..<endIndex 如果数组是空,其实就是0到小于0,其实不包括0,如果此时你传入的idx是0,同样不会进入if,所以是安全的
            return self[idx]
        }
        return nil
    }
}

var array = [1,2,3,4,5]
print(array.startIndex) //0
print(array.endIndex) //5
print(array[nullable: 7] as Any)
print(array[nullable: 8] ?? 0)


extension Int {
    func repetitions(task: () -> Void) { //为Int扩展一个重复的方法
        for _ in 0..<self { task() }
    }
    mutating func square() -> Int { //求平方
        self = self * self
        return self
    }
    enum Kind { //嵌套类型,判断是什么类型的
        case negative, zero, positive
    }
    var kind: Kind {
        switch self {
            case 0: return .zero
            case let x where x > 0: return .positive
            default: return .negative
        }
    }

    subscript(digitIndex: Int) -> Int { //快速获取个位十位百位各是什么数字
        var decimalBase = 1
        for _ in 0..<digitIndex {
            decimalBase *= 10
        }
        return (self / decimalBase) % 10
    }
}

3.repetitions {
    print("111")
}

var age = 10
age = age.square()
print(age)

print(10.kind)

print(123[0])
print(123[1])
print(123[2])

//MARK: ------------------------------------- 协议、初始化器 -------------------------------------
/*
 如果希望自定义初始化器的同时，编译器也能够生成默认初始化器
    可以在扩展中编写自定义初始化器
    required初始化器也不能写在扩展中
 */
class Person {
    var age: Int
    var name: String
    init(age: Int, name: String) {
        self.age = age
        self.name = name
    }
}

extension Person : Equatable { //为类扩展一个协议
    static func == (left: Person, right: Person) -> Bool {
        left.age == right.age && left.name == right.name
    }
    convenience init() { //扩展中只能添加便捷初始化器
        self.init(age: 0, name: "")
    }
}


struct Point {
    var x: Int = 0
    var y: Int = 0
}

extension Point {//如果希望自定义初始化器的同时，编译器也能够生成默认初始化器,因为当我们在结构体中自定义了初始化器,那么系统就不会帮我们生成默认的初始化器
    init(_ point: Point) { //这个是结构体的初始化器,在结构体中不存在指定初始化器和便捷初始化器的说法,只有类才有这种说法
        self.init(x: point.x, y: point.y)
    }
}

var p1 = Point()
var p2 = Point(x: 10)
var p3 = Point(y: 20)
var p4 = Point(x: 10, y: 20) //以上四个默认的初始化器还是会有
var p5 = Point(p4) //调用扩展的初始化器


//MARK: ------------------------------------- 协议 -------------------------------------
/*
 如果一个类型已经实现了协议的所有要求，但是还没有声明它遵守了这个协议
    可以通过扩展来让它遵守这个协议
 */
protocol TestProtocol {
    func test()
}
class TestClass {
    func test() {
        print("test")
} }
extension TestClass : TestProtocol {}

//编写一个函数，判断一个整数是否为奇数?
//所有的整数(UInt,UInt8,UInt32.....)都会遵守BinaryInteger协议,所以使用泛型的时候限定遵守BinaryInteger协议的整数才能调用
func isOdd<T: BinaryInteger>(_ i: T) -> Bool {
    i % 2 != 0
}

//或者为BinaryInteger协议扩展一个方法(上边的额方式我需要时一个全局函数才能谁都调用,所以明显这种方法好)
extension BinaryInteger {
    func isOdd() -> Bool { self % 2 != 0 }
}


//MARK: ------------------------------------- 协议 -------------------------------------
/*
 扩展可以给协议提供默认实现，也间接实现『可选协议』的效果
 扩展可以给协议扩充『协议中从未声明过的方法』
 */
protocol TestProtocol1 { //协议中定义了一个方法,默认遵守该协议的必须实现这些方法
    func test1()
}

extension TestProtocol1 {
    func test1() { // 通过扩展,可以给协议提供默认实现，也间接实现『可选协议』的效果
        print("TestProtocol1 test1")
    }
    func test2() {// 扩展可以给协议扩充『协议中从未声明过的方法』
        print("TestProtocol1 test2")
    }
}


class TestClass1 : TestProtocol1 {} //TestClass遵守了TestProtocol1协议,但并未实现协议中的方法,也没有报错
var cls = TestClass1()
cls.test1() // TestProtocol1 test1
cls.test2() // TestProtocol1 test2

var cls2: TestProtocol1 = TestClass1()
cls2.test1() // TestProtocol1 test1
cls2.test2() // TestProtocol1 test2

class TestClass2 : TestProtocol1 {
    func test1() {
        print("TestClass test1")
    }
    func test2() {
        print("TestClass test2")
    }
}
var cl = TestClass2()
cl.test1() // TestClass test1
cl.test2() // TestClass test2

var cl2: TestProtocol1 = TestClass2()
cl2.test1() // TestClass test1
cl2.test2() // TestProtocol test2
//调用了协议里的test2,之所以是这个结果是因为,你的协议中没有test2这个方法,所以编译器认为遵守协议的这个类也未必会实现test2方法,所以就从扩展的协议中去找这个方法并且调用

//MARK: ------------------------------------- 泛型 -------------------------------------
 class Stack<E> {
    var elements = [E]()
    func push(_ element: E) {
        elements.append(element)
    }
    func pop() -> E {
        elements.removeLast()
    }
    func size() -> Int {
        elements.count
    }
}
// 扩展中依然可以使用原类型中的泛型类型
extension Stack {
    func top() -> E {
        elements.last!
    }
}

// 符合条件才扩展  泛型的类型也需要遵守Equatable这个扩展才会生效,否则就不存在
extension Stack : Equatable where E : Equatable {
    static func == (left: Stack, right: Stack) -> Bool {
        left.elements == right.elements
    }
}
