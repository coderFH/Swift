//
//  main.swift
//  结构体和类
//
//  Created by Ne on 2019/6/29.
//  Copyright © 2019 wangfh. All rights reserved.
//

import Foundation

//MARK: ------------------------------------- 1.结构体 -------------------------------------
struct Date {
    var year : Int //存储属性
    var month : Int
    var day : Int
}

//所有的结构体都有一个编译器自动生成的初始化器(initializer，初始化方法、构造器、构造方法)
//在第6行调用的，可以传入所有成员值，用以初始化所有成员(存储属性，Stored Property)
var date = Date(year: 2019, month: 6, day: 23)

//MARK: ------------------------------------- 2.结构体的初始化器 -------------------------------------
//编译器会根据情况，可能会为结构体生成多个初始化器，宗旨是:保证所有成员都有初始值
struct Point {
    var x : Int
    var y : Int
}

var p1 = Point(x: 10, y: 10)
//var p2 = Point(y: 10) 报错 没有保证所有的成员都有初始值
//var p3 = Point(x: 10) 报错
//var p4 = Point() 报错


struct Point1 {
    var x : Int = 0
    var y : Int = 0
}
var pp1 = Point1(x: 10, y: 10)
//var pp2 = Point1(y: 10)  //按说不应该报错,是不是swift版本的问题
//var pp3 = Point1(x: 10)  //按说不应该报错,是不是swift版本的问题
var pp4 = Point1()

//MARK: ------------------------------------- 3.自定义初始化器 -------------------------------------
struct Point2 {
    var x : Int = 0
    var y : Int = 0
    init(x : Int,y : Int) {
        self.x = x
        self.y = y
    }
}
var ppp1 = Point2(x: 10, y: 10)
//var ppp2 = Point2(y: 10) //报错 一旦在定义结构体时自定义了初始化器，编译器就不会再帮它自动生成其他初始化器
//var ppp3 = Point2(x: 10) //报错
//var ppp4 = Point2() //报错

//MARK: ------------------------------------- 4.结构体内存结构 -------------------------------------
struct Point3 {
    var x : Int = 0
    var y : Int = 0
    var origin : Bool = false
}
print(MemoryLayout<Point3>.size) //17
print(MemoryLayout<Point3>.stride) //24
print(MemoryLayout<Point3>.alignment) //8

//MARK: ------------------------------------- 5.类 -------------------------------------
//类的定义和结构体类似，但编译器并没有为类自动生成可以传入成员值的初始化器
class Point4 {
    var x : Int = 0
    var y : Int = 0
}
let o1 = Point4() //如果类的所有成员都在定义的时候指定了初始值，编译器会为类生成无参的初始化器  成员的初始化是在这个初始化器中完成的
//let o2 = Point4(x:10,y:20) //报错 编译器并没有为类自动生成 可以传入成员值 的 初始化器
//let o3 = Point4(x:10) //报错
//let o4 = Point4(y:20) //报错

//对比下结构体
class Point5 {
    var x : Int = 0
    var y : Int = 0
}
let oo1 = Point4()
//let oo2 = Point5(x:10,y:20) //按说不应该报错,是不是swift版本的问题
//let oo3 = Point5(x:10) //按说不应该报错,是不是swift版本的问题
//let oo4 = Point5(y:20) //按说不应该报错,是不是swift版本的问题

//以下代码还是会报错,因为无参构造器在构造完毕后,不能保证所有的成员都有值x,y都是没有值的,所有直接编译器报错
//class Point6 {
//    var x : Int
//    var y : Int
//}
//let i = Point6()

//MARK: ------------------------------------- 6.值类型 -------------------------------------
//值类型赋值给var、let或者给函数传参，是直接将所有内容拷贝一份
//类似于对文件进行copy、paste操作，产生了全新的文件副本。属于深拷贝(deep copy)
struct Point7 {
    var x : Int
    var y : Int
}
var v1 = Point7(x: 10, y: 20)
var v2 = v1
v2.x = 11
v2.y = 22
print(v1.x,v1.y)

//MARK: ------------------------------------- 7.值类型的赋值操作 -------------------------------------
var s1 = "Jack"
var s2 = s1
s2.append("_Rose")
print(s1) //Jack
print(s2) //Jack_Rose

var a1 = [1,2,3]
var a2 = a1
a2.append(4)
a1[0] = 2
print(a1) //[2,2,3]
print(a2) //[1,2,3,4]

var d1 = ["max":10,"min":2]
var d2 = d1
d1["other"] = 7
d2["max"] = 12
print(d1) //["max": 10, "min": 2, "other": 7]
print(d2) //["max": 12, "min": 2]

/*
 
 在Swift标准库中，为了提升性能，String、Array、Dictionary、Set采取了Copy On Write的技术
 比如仅当有“写”操作时，才会真正执行拷贝操作
 对于标准库值类型的赋值操作，Swift 能确保最佳性能，所有没必要为了保证最佳性能来避免赋值
 建议:不需要修改的，尽量定义成let
 */

//MARK: ------------------------------------- 7.引用类型 -------------------------------------
//引用赋值给var、let或者给函数传参，是将内存地址拷贝一份
//类似于制作一个文件的替身(快捷方式、链接)，指向的是同一个文件。属于浅拷贝(shallow copy)
class Size {
    var width : Int
    var height : Int
    init(width : Int,height : Int) {
        self.width = width
        self.height = height;
    }
}

var z1 = Size(width: 10, height: 20)
var z2 = z1
z2.width = 11
z2.height = 22
print(z1.width,z1.height)

//MARK: ------------------------------------- 8.值类型、引用类型的let-------------------------------------
struct Point11 {
    var x: Int
    var y: Int
}
class Size11 {
    var width: Int
    var height: Int
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
}

//声明为let,因为struct是值类型,所以都不能进行修改
let pp = Point11(x: 10, y: 20)
//pp = Point11(x: 11, y: 22)
//pp.x = 33
//pp.y = 44

//类声明为let,相当于 void * const,ss指向的内存地址不能改,但指向的这个内存中的值是可以进行修改的
let ss = Size11(width: 10, height: 20)
//ss = Size11(width: 11, height: 22)
ss.width = 33
ss.height = 44

//MARK: ------------------------------------- 9.嵌套类型-------------------------------------
struct Poker {
    enum Suit : Character {
        case spades = "♠️",hearts = "♥️",diamonds = "🐶",clubs = "♣️"
    }
    enum Rank : Int {
        case two = 2,three,four,five,size,seven,eight,nine,ten
        case jack,queue,king,ace
    }
}
print(Poker.Suit.hearts.rawValue)
var suit = Poker.Suit.spades
suit = .diamonds

var rank = Poker.Rank.five
rank = .king

//MARK: ------------------------------------- 10.枚举、结构体、类都可以定义方法-------------------------------------
class SizeT {
    var width = 10
    var height = 10
    func show() {
        print("width = \(width),height=\(height)")
    }
}
let size = SizeT()
size.show()

struct PointT {
    var x = 10
    var y = 10
    func show() {
        print("x=\(x),y=\(y)")
    }
}

let p = PointT()
p.show()

enum PokerFace : Character {
    case spades = "♠️",hearts = "♥️",diamonds = "🐶",clubs = "♣️"
    func show() {
        print("face is \(rawValue)")
    }
}

let pf = PokerFace.hearts
pf.show()
