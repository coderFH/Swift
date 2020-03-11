//
//  main.swift
//  15-访问控制
//
//  Created by wangfh on 2020/3/10.
//  Copyright © 2020 wangfh. All rights reserved.
//

import Foundation
//MARK: --------------------------------------------------------------------------
//下面代码能否编译通过?
/*
 private class Person {}
 fileprivate class Student : Person {}
 代码是否正确,分为两种情况
 */
//第一种情况:就这么写,是不报错的,因为private class Person {}放在全局,对应的访问权限也就是这个文件,和fileprivate的访问权限是一致的,所以正确
private class Person {} //直接在全局作用域下定义的private等价于fileprivate
fileprivate class Student : Person {}

//第一种情况:报错,因为Person1的访问权限只在test函数里有效,而Student1的权限对这个文件有效,子类的权限比父类还大,所以错误
//func test {
//    private class Person1 {}
//    fileprivate class Student1 : Person1 {}
//}


//下面之所以正确,解释和上边是一样的
private struct Dog {
    var age: Int = 0
    func run() {}
}
fileprivate struct Person2 {
    var dog: Dog = Dog()
    mutating func walk() {
        dog.run()
        dog.age = 1
    }
}

//把上边Dog的属性都加上private,就会报错.因为Dog的age和run的作用域只在Dog3里边,如果是fileprivate就没问题
//private struct Dog3 {
//    private var age: Int = 0
//    private func run() {}
//}
//fileprivate struct Person3 {
//    var dog3 : Dog3 = Dog3()
//    mutating func walk() {
//        dog3.run()
//        dog3.age = 1
//    }
//}

//细节补充
/*
 看以下代码,所有Cat类定义成private,但在People类中也能访问Cat的属性
 原因就是因为,当Cat类的属性和方法没有明显的写private时,他其实继承Cat类的访问控制,即private,但Cat类在整个Test2函数中都可以访问,所以Cat的属性在People中就都能访问
 如果把Cat类中的属性和方法显示的用private声明一下,就表示我只在我定义的类中访问,即整个Cat类,这样在People中访问就会报错
 */
class Test2 {
    private struct Cat {
        var age : Int = 0 //加上private就报错
        func run() {}
    }
    
    private struct People {
        var cat : Cat = Cat()
        mutating func walk() {
            cat.run()
            cat.age = 1
        }
    }
}

//MARK: -------------------------------------getter、setter -------------------------------------
//这里的getter、setter只表示读和写,并不一定是计算属性
// getter、setter默认自动接收它们所属环境的访问级别
// 可以给setter单独设置一个比getter更低的访问级别，用以限制写的权限

fileprivate(set) public var num = 10 //单独设置这个全局变量的set权限,其他文件可以随意访问,但只有这个文件可以改

class Postman {
    private(set) var age = 0 //private(set)表示set方法的权限是私有的,外界不能写,如果不加这个,默认是internal,外界可读可写
    fileprivate(set) public var weight: Int { //给计算属性的set单独设定级别
        set {}
        get { 10 }
    }
    internal(set) public subscript(index: Int) -> Int {
        set {}
        get { index }
    }
}

var m = Postman()
//m.age = 10 //set 报错
print(m.age) //get



//MARK: -------------------------------------协议 -------------------------------------
//协议中定义的要求自动接收协议的访问级别，不能单独设置访问级别 ppublic协议定义的要求也是public
protocol Runable {
    func run() // 不能单独设置访问级别,默认接受该协议的访问级别,即Runable的级别
}

//协议实现的访问级别必须 ≥ 类型的访问级别，或者 ≥ 协议的访问级别
internal protocol Swimable {
    func swiming()
}

fileprivate class Finsh : Swimable {
    func swiming() { //协议实现的访问级别 我只要比Finsh(类型的访问级别)的访问级别级别高,或者大于协议的访问级别都是可以的,比如我这里写private,就会报错
        print("游泳")
    }
}

//MARK: -------------------------------------将方法赋值给var\let -------------------------------------
struct Cat {
    var age: Int
    func run(_ v: Int) { print("func run", age, v) } //实例方法
}

var d1 = Cat.run //他的类型是(Cat) ->(Int) -> () 所以d1的实际类型就是传一个Cat对象进去,返回你一个参数是Int类型无返回值的方法
var d2 = d1(Cat(age: 10)) // d2的类型就是 (Int)->()  参数是Int类型无返回值的方法
d2(20)  //直接调用d2,就相当于调用了run方法


//方法也可以像函数那样，赋值给一个let或者var
struct Person1 {
    var age: Int
    func run(_ v: Int) { print("func run", age, v) } //实例方法
    static func run(_ v: Int) { print("static func run", v) } //类方法
}

let fn1 = Person1.run
fn1(10) // static func run 10   默认的就会调用类方法

let fn2: (Int) -> () = Person1.run //也可以声明的时候指定类型
fn2(20) // static func run 20

let fn3: (Person1) -> ((Int) -> ()) = Person1.run //如果我就想调用实例方法 就显示的指定类型,看不懂(Person1) -> ((Int) -> ())这个类型,就看上边Cat的那个例子
fn3(Person1(age: 18))(30) // func run 18 30


