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


