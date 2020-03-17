//
//  main.swift
//  20-Swift调用OC
//
//  Created by wangfh on 2020/3/16.
//  Copyright © 2020 wangfh. All rights reserved.
//

import Foundation

//MARK: - ------------------------------------Swift调用OC-------------------------------------
var p = FHPerson(age: 10, name: "Jack") //OC中对象初始化和类初始化方法同时存在的话,会优先调用initWithAge....,如果不存在,会调用personWithAge....
p.age = 18
p.name = "Rose"
p.run() //18 Rose -run  Swift调用OC的代码,其实走的还是objc_msgsend那套流程
p.eat("apple", other: "water") //18 Rose -eat apple water

FHPerson.run() //Person +run
FHPerson.eat("Pizza", other: "Banana") //Person +eat Pizza Banana


//也可以直接调用C语言的函数
print(sum(10, 20))

func sum(_ a : Int, _ b : Int) -> Int {
    return a - b
}

//如果C语言暴露给Swift的函数名跟Swift中的其他函数名冲突了
//可以在Swift中使用 @_silgen_name 修改C函数名
@_silgen_name("sum")
func swift_sum(_ v1: Int32, _ v2: Int32) -> Int32

print(swift_sum(10, 20)) // 30 调用的C的sum
print(sum(20, 20)) // 0 调用的swift的sum


//MARK: - ------------------------------------OC调用Swift-------------------------------------
/*
 使用@objc修饰需要暴露给OC的成员
 使用@objcMembers修饰类
    代表默认所有成员都会暴露给OC(包括扩展中定义的成员)
    最终是否成功暴露，还需要考虑成员自身的访问级别
 */

//可以通过@objc 重命名Swift暴露给OC的符号名(类名、属性名、函数名等)
@objc(FHCar)
@objcMembers class Car: NSObject { //Swift暴露给OC的类最终继承自NSObject,因为OC的方法调用还是走的runtime那套流程
    var price: Double
    
    @objc(name)
    var band: String
    
    init(price: Double, band: String) {
        self.price = price
        self.band = band
    }
    
    @objc(drive)
    func run() { //如果想把方法暴露给OC使用,该类必须继承NSObject,然后使用@objc修饰该方法,或者整个类使用@objcMembers修饰,同时也才能用选择器进行包装
        print(price, band, "run")
        
        
        let p = FHPerson(age: 10, name: "Jack")
        p.run() //Swift调用OC的代码,其实走的还是objc_msgsend那套流程
    }
    
    static func run() {
        print("Car run")
    }
}

extension Car {
    func test() {
        print(price, band, "test")
    }
}

var car = Car(price: 1.1, band: "Nike")
car.run() //Car虽然继承了NSObject,并且也可以让OC去调用,但是你在swift里去使用car,走的就是swift虚标那一套了,如果你确实在这种情况下也想走objc_Msgsend,那在run方法前,加上dynamic就可以,可见19-从OC到Swift项目的245行

//调用OC的testSwift()函数,验证OC调用Swift
testSwift()

