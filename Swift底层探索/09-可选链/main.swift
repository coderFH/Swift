//
//  main.swift
//  09-可选链
//
//  Created by Ne on 2020/3/1.
//  Copyright © 2020 wangfh. All rights reserved.
//

import Foundation

class Car { var price = 0 }
class Dog { var weight = 0 }
class Person {
    var name : String = ""
    var dog : Dog = Dog()
    var car : Car?  = Car()
    func age() -> Int { 18 }
    func test() -> Int? { 0 }
    func eat() { print("Person eat") }
    subscript(index : Int) -> Int { index }
}

//定义一个可选类型
var person : Person? = Person()
var age = person?.age() //Int?  可以看到age是可选类型
var age1 = person!.age() //如果对person强制解包,就不是可选类型了
var name = person?.name //String?
var index = person?[6] //Int?
var test = person?.test() //Int? 如果结果本来就是可选项,不会进行再次包装(比如不会是 Int??)

//判断eat调用成功
if let _ = person?.eat() { //swift中,虽然eat没有返回值,但其实返回的是Void,Void是一个空元祖,所以调用eat后,可以赋值给一个变量
    print("调用eat成功")
} else {
    print("调用eat失败")
}

//多个?可以链接在一起
//如果链中任何一个节点是nil,那么整个链就会调用失败
var dog = person?.dog //Dog?
var weight = person?.dog.weight //Int?
var price = person?.car?.price //Int?


//-----------------------------------------------
var scores = ["jack" :  [66,55,33],"rose" : [88,11,22]]
scores["jack"]?[0] = 100 // 这里之所以要加? 号是因为字典中key不确定在不在 所以返回的是可选类型
scores["rose"]?[2] += 10

//这两个之所以加?号是因为定义的是可选类型,如果有值我就赋值,如果是nil,就直接返回nil
var num1 : Int? = 5
num1? = 10 //Optianl(10)
var num2 : Int? = nil
num2? = 10 //nil

var dict : [String : (Int,Int) -> Int] = [
    "sum" : (+),
    "difference" : (-)
]
var result = dict["sum"]?(10,20) //Optional(30),Int?



