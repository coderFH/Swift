//
//  main.swift
//  07-继承
//
//  Created by wangfh on 2019/7/15.
//  Copyright © 2019 wangfh. All rights reserved.
//

import Foundation

//MARK: ------------------------------------- 1.继承 -------------------------------------
/*
 值类型(枚举、结构体)不支持继承，只有类支持继承

 没有父类的类，称为:基类
    Swift并没有像OC、Java那样的规定:任何类最终都要继承自某个基类
 
 子类可以重写父类的下标、方法、属性，重写必须加上override关键字
 */

//MARK: ------------------------------------- 2.内存结构 -------------------------------------
func memoryStructure() {
    class Animal {
        var age = 0
    }
    
    class Dog: Animal {
        var weight = 0
    }
    
    class ErHa: Dog {
        var iq = 0
    }
    
    /*
     0x00000001000073e0
     0x0000000000000002
     0x000000000000000a
     0x0000000000000000
     */
    
    let a = Animal()
    a.age = 10
    print(Mems.size(ofRef: a)) // 32
    print(Mems.memStr(ofRef: a))
    
    /*
     0x00000001000073e0
     0x0000000000000002
     0x000000000000000a
     0x0000000000000014
     */
    let d = Dog()
    d.age = 10
    d.weight = 20
    print(Mems.size(ofRef: d)) // 32
    print(Mems.memStr(ofRef: d))
    
    
    /*
     0x00000001000067e8
     0x0000000000000002
     0x000000000000000a
     0x0000000000000014
     0x000000000000001e
     0x0000000000000000
     */
    let e = ErHa()
    e.age = 10
    e.weight = 20
    e.iq = 30
    print(Mems.size(ofRef: e)) // 32
    print(Mems.memStr(ofRef: e))
}

//MARK: ------------------------------------- 3.重写实例方法.下标 -------------------------------------
func overrideSubsctipt() {
    class Animal {
        func speak() {
            print("Animal speak")
        }
        subscript(index : Int) -> Int {
            return index
        }
    }
    
    var anim : Animal
    anim = Animal()
    anim.speak()
    print(anim[6])
}

