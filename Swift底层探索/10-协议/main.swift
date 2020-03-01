//
//  main.swift
//  10-协议
//
//  Created by Ne on 2020/3/1.
//  Copyright © 2020 wangfh. All rights reserved.
//

import Foundation
//协议可以用来定义方法,属性,下标的声明,协议可以被枚举,结构体,类遵守(多个协议之间用逗号隔开)
//协议中定义属性时必须用var关键字,因为遵守协议的类我现实协议定义的属性时,可以使用计算属性实现,这样我在计算属性的get方法里可能返回任意值,或者是函数,这样我的值就是不确定的,所以如果我协议里定义属性用let,就明显不合适了
/*实现协议时的属性权限要不小于协议中定义的属性权限. 这句话怎么理解
1.协议中定义了get set,用var存储属性或者get,set计算属性去实现
2.协议定义get,用任何属性都可以实现,意思就是例如y,协议定义为只读.但在具体实现时,不管你用计算属性实现还是存储属性实现,你即可以是只读的,也可以是可读可写的,因为我保证了实现协议的属性权限要不小于协议中定义的属性权限(get set > get)
 */
protocol Drawable {
    //只是声明了量个属性,但是并没有规定遵守他的类必须是用存储属性实现,还是用计算属性实现
    var x : Int { get set }
    var y : Int { get } //只读
    func draw()
    subscript(index : Int) -> Int { get set }
}

class Person: Drawable {
    var x: Int = 0 //满足可读可写
    let y: Int = 0  //满足了y只读
    func draw() {
        print("person draw")
    }
    subscript(index: Int) -> Int {
        set {}
        get { index }
    }
}

class Person1: Drawable {
    var x: Int { //我也可以使用计算属性实现
        get { 0 }
        set {}
    }
    var y:Int { 0 } //也是计算属性实现,满足只读
    func draw() {
        print("person1 draw")
    }
    subscript(index: Int) -> Int {
        set {}
        get { index }
    }
}

//MARK: ------------------------------------- static,class -------------------------------------
//正常情况下,定义类型方法,类型属性,类型下标,我们可以使用static或者class
//但是在协议中,为了保证通用,必须用static,因为如果用class,你枚举和结构体是不能遵守这个协议的

protocol Drawable2 {
    static func draw()
}

class Person2 : Drawable2 {
    class func draw() {
        print("Person2 draw")
    }
}

class Person3: Drawable2 {
    static func draw() {
        print("Person3 draw")
    }
}
//在具体的实现协议时,如果你这个类允许子类重写,就用class(eg:60行),不允许重写就用static(eg:66行)

//MARK: ------------------------------------- mutating -------------------------------------
/*
 只有将协议中的实例方法标记为mutating
    才允许结构体,枚举的具体实现修改自身内存
    类在实现方法时不用加mutating,枚举,结构体才需要加mutating
 */
protocol Drawable3 {
    mutating func draw()
}

class Size1 : Drawable3 {
    var width: Int = 0
    func draw() {
        width = 10
    }
}

struct Point1: Drawable3 {
    var x :Int = 0
    mutating func draw() { //如果协议定义中没有mutating直接在协议实现中写mutating,是会报错的,不允许
        x = 10
    }
}
//MARK: ------------------------------------- init -------------------------------------
/*协议中还可以定义初始化器init
    非final类实现时必须加上required. 什么是final类? 被final修饰的类是不允许被继承的,即没有子类
    为什么非final类必须加required?
        因为既然不是final,说明肯定有子类,那么协议中既然定义了init(),肯定是希望所有遵守他的类都要实现改方法
        所以加上required,就保证了所有的子类必须实现这个方法
 */
protocol Drawable4 {
    init(x : Int,y : Int)
}

class Point4 : Drawable4 {
    required init(x : Int,y : Int) {}
}

final class Size4 : Drawable4 {
    init(x : Int,y : Int) {}
}

/*
 如果从协议中实现的初始化器,刚好是重写了父类的指定初始化器
    那么这个初始化必须同时加required,override
 */
protocol Liveable {
    init(age : Int)
}

class Person5 {
    init(age : Int) {}
}

class Student: Person5,Liveable {
    override required init(age : Int) {
        super.init(age : age)
    }
}


//MARK: ------------------------------------- init、init?、init! -------------------------------------
/*
 协议中定义的init?、init!，可以用init、init?、init!去实现
 协议中定义的init，可以用init、init!去实现
 */
protocol Livable4 {
    init()
    init?(age: Int)
    init!(no: Int)
}

class Person4 : Livable4 {
    //协议中的init()可以用以下两种方式去实现
    required init() {}
    // required init!() {} //为什么这种方式可以实现init(),我也解释不清,记住就行,必须是!哦,?号不行
    
    //协议中的init?()可以用以下三种方式去实现 ,因为这是一个可失败初始化器(即初始化有可能成功或者失败,下边的三种情况满足成功或者失败)
    required init?(age: Int) {} //我是可成功可失败的
    // required init!(age: Int) {} //我是可成功可失败的
    // required init(age: Int) {} //我是成功的情况
    
    //协议中的init!()可以用以下三种方式去实现  跟init?()的解释一样
    required init!(no: Int) {}
    // required init?(no: Int) {}
    // required init(no: Int) {}
}

//MARK: ------------------------------------- 协议的继承 -------------------------------------
//一个协议可以继承其他协议
 protocol Runnable {
    func run()
}
protocol Livable2 : Runnable {
    func breath()
}
class Person6 : Livable2 {
    func breath() {}
    func run() {}
}

//MARK: ------------------------------------- 协议组合 -------------------------------------
protocol Livable7 {}
protocol Runnable7 {}
class Person7 {}

// 接收Person或者其子类的实例
func fn0(obj: Person7) {}

// 接收遵守Livable协议的实例
func fn1(obj: Livable7) {}

// 接收同时遵守Livable、Runnable协议的实例
func fn2(obj: Livable7 & Runnable7) {}

// 接收同时遵守Livable、Runnable协议、并且是Person或者其子类的实例
func fn3(obj: Person7 & Livable7 & Runnable7) {}

//-----------协议组合，可以包含1个类类型(最多1个)
typealias RealPerson = Person7 & Livable7 & Runnable7
// 接收同时遵守Livable、Runnable协议、并且是Person或者其子类的实例
func fn4(obj: RealPerson) {}

//MARK: ------------------------------------- CaseIterable -------------------------------------
//让枚举遵守CaseIterable协议，可以实现遍历枚举值
 enum Season : CaseIterable {
    case spring, summer, autumn, winter
}
let seasons = Season.allCases
print(seasons.count) // 4
for season in seasons {
    print(season)
} // spring summer autumn winter

//MARK: ------------------------------------- CustomStringConvertible -------------------------------------
//遵守CustomStringConvertible、 CustomDebugStringConvertible协议，都可以自定义实例的打印字符串
class Person8 : CustomStringConvertible, CustomDebugStringConvertible {
    var age = 0
    var description: String { "person_\(age)" }
    var debugDescription: String { "debug_person_\(age)" }
}
var person = Person8()
print(person) // person_0
debugPrint(person) // debug_person_0


//MARK: ------------------------------------- Any、AnyObject -------------------------------------
/*Swift提供了2种特殊的类型:Any、AnyObject
    Any:可以代表任意类型(枚举、结构体、类，也包括函数类型)
    AnyObject:可以代表任意类类型(在协议后面写上: AnyObject代表只有类能遵守这个协议)
 在协议后面写上: class也代表只有类能遵守这个协议
 */
var stu: Any = 10
stu = "Jack"
stu = Person()

// 创建1个能存放任意类型的数组
// var data = Array<Any>()
var data = [Any]()
data.append(1)
data.append(3.14)
data.append(Person())
data.append("Jack")
data.append({ 10 }) //还可以添加闭包

protocol testProtocol : AnyObject {}
class testClass: testProtocol {}
//struct testStruct : testProtocol {}  //报错,只有有类能遵守这个协议
