//
//  main.swift
//  18-模式匹配
//
//  Created by wangfh on 2020/3/14.
//  Copyright © 2020 wangfh. All rights reserved.
//

import Foundation

//MARK: - ------------------------------------通配符模式(Wildcard Pattern)-------------------------------------
//_ 匹配任何值
//_? 匹配非nil
enum Life {
    case human(name: String, age: Int?)
    case animal(name: String, age: Int?)
}

func check(_ life: Life) {
    switch life {
    case .human(let name, _):
        print("human", name)
    case .animal(let name, _?):
        print("animal", name)
    default:
        print("other")
    }
}
check(.human(name: "Rose", age: 20)) // human Rose
check(.human(name: "Jack", age: nil)) // human Jack
check(.animal(name: "Dog", age: 5)) // animal Dog
check(.animal(name: "Cat", age: nil)) // other _?匹配非空,所以当age是nil的时候,会进入到default里

//MARK: - ------------------------------------值绑定模式(Value-Binding Pattern)-------------------------------------
let point = (3, 2)
switch point {
case let (x, y):
    print("The point is at (\(x), \(y)).")
}

var num : Int? = 10
switch num {
case let v?: //要求非空,并且解包后赋值给v
    print(v)
case nil:
    print("nil")
}

//MARK: - ------------------------------------元组模式(Tuple Pattern)-------------------------------------
let points = [(0, 0), (1, 0), (2, 0)]
for (x, _) in points {
    print(x)
}

let name: String? = "jack"
let age = 18
let info: Any = [1, 2]
switch (name, age, info) {
case (_?, _ , _ as String): //_?, _ , _ as String 第一个非空 第二个可以试试任何值 第三个需要是字符串 所以会进入到default
    print("case")
default:
    print("default")
} // default

var scores = ["jack" : 98, "rose" : 100, "kate" : 86]
for (name, score) in scores {
    print(name, score)
}

//MARK: - ------------------------------------枚举Case模式(Enumeration Case Pattern)-------------------------------------
//if case语句等价于只有1个case的switch语句
let age1 = 2
// 原来的写法
if age1 >= 0 && age1 <= 9 {
    print("原来的写法-[0, 9]")
}

// 枚举Case模式
if case 0...9 = age1 {
    print("枚举Case模式-[0, 9]")
}

func test() {
    guard case 0...9 = age1 else {
        return
    }
    print("guard--[0, 9]")
}
//以上三种写法等效,本质上就是  if case语句等价于只有1个case的switch语句 (看下边注释的例子)
/*
switch age1{
case 0...9:
    print("[0,9]")
default:
    break
}*/
test()

switch age1 {
    case 0...9:
        print("[0, 9]")
    default: break
}

let ages: [Int?] = [2, 3, nil, 5]
for case nil in ages {
    print("有nil值")
    break
} // 有nil值

let points1 = [(1, 0), (2, 1), (3, 0)]
for case let (x, 0) in points {//去除y为0的点
    print(x)
} // 1 3
 
//MARK: - ------------------------------------可选模式(Optional Pattern)-------------------------------------
let age2: Int? = 42
//以下这两种写法是一样的,age2不能为nil,会执行print
if case .some(let x) = age2 { print(x) } //枚举本质就是.some .none
if case let x? = age2 { print(x) }


let ages1: [Int?] = [nil, 2, 3, nil, 5]
for case let age? in ages1 {
    print(age)
} // 2 3 5

let ages2: [Int?] = [nil, 2, 3, nil, 5]
for item in ages2 {
    if let age = item {
        print(age)
    }
} // 跟上面的for，效果是等价的,如果不懂上边的写法,是不是很麻烦

func check(_ num: Int?) {
    switch num {
    case 2?: print("2")
    case 4?: print("4")
    case 6?: print("6")
    case _?: print("other")
    case _: print("nil")
} }
check(4) // 4
check(8) // other
check(nil) // nil

//MARK: - ------------------------------------类型转换模式(Type-Casting Pattern)-------------------------------------
let num1: Any = 6
switch num1 {
    case is Int: //is 只是判断你是不是Int,并不会帮你强转,num1还是类型Any
        // 编译器依然认为num是Any类型
        print("is Int", num)
//    case let n as Int: //as 是看num1能不能强转成Int,如果能,就赋值给n(is是不能这么用的哦), 其实 不管你是用as还是is  都不会影响你num1的类型,你都是Any类型
//        print("as Int", n + 1)
    default:
        break
}

class Animal { func eat() { print(type(of: self), "eat") } } //type(of: self)会最终看到底是谁调用的,所以check(Cat())会打印 Cat eat
class Dog : Animal { func run() { print(type(of: self), "run") } }
class Cat : Animal { func jump() { print(type(of: self), "jump") } }

func check(_ animal: Animal) {
    switch animal {
    case let dog as Dog://将animal强转成dog,dog就是Dog类型
        dog.eat()
        dog.run()
    case is Cat://虽然check(Cat())调用的时候,是Cat类型,但是没有赋值给一个变量,编译器就认为你是animal类型,所以只能用animal去调用eat,Cat中的Jump是不能调的
        animal.eat()
    default: break
    }
}
// Dog eat
// Dog run
check(Dog())

// Cat eat
check(Cat())

//MARK: - ------------------------------------表达式模式(Expression Pattern)-------------------------------------
//表达式模式用在case中
let point1 = (1, 2)
switch point1 {
    case (0, 0):
        print("(0, 0) is at the origin.")
    case (-2...2, -2...2):
        print("(\(point.0), \(point.1)) is near the origin.")
    default:
        print("The point is at (\(point.0), \(point.1)).")
} // (1, 2) is near the origin.

//MARK: - ------------------------------------自定义表达式模式-------------------------------------
//可以通过重载运算符，自定义表达式模式的匹配规则
struct Student {
    var score = 0, name = ""
    //static func ~= (pattern: Int, value: Student) -> Bool这是固定格式
    //pattern:case的类型  value:switch后的内容类型
    static func ~= (pattern: Int, value: Student) -> Bool { value.score >= pattern }
    static func ~= (pattern: ClosedRange<Int>, value: Student) -> Bool { pattern.contains(value.score) }
    static func ~= (pattern: Range<Int>, value: Student) -> Bool { pattern.contains(value.score) }
}

var stu = Student(score: 75, name: "Jack")
switch stu {
    case 100: print(">= 100")
    case 90: print(">= 90")
    case 80..<90: print("[80, 90)") case 60...79: print("[60, 79]") case 0: print(">= 0")
    default: break
} // [60, 79]

if case 60 = stu {
    print(">= 60")
} // >= 60

var info1 = (Student(score: 70, name: "Jack"), "及格")
switch info1 {
    case let (60, text): print(text)
    default: break
} // 及格


//例子2:
//pattern:是 参数为String返回值是Bool 的函数
//value: switch之后的内容的类型,241行switch后边是str,所以value是String类型
extension String {
    static func ~= (pattern: (String) -> Bool, value: String) -> Bool {
        pattern(value)
    }
}

func hasPrefix(_ prefix: String) -> ((String) -> Bool) { { $0.hasPrefix(prefix) } } //这么写的效果写完整的话就是下面的hasPrefix1函数
func hasPrefix1(_ prefix: String) -> ((String) -> Bool) {
    return { //返回一个函数出去,这个函数的作用是接受一个字符串,判断一下这个字符串是不是以prefix这个东西开头的
        (str : String) -> Bool in
        str.hasPrefix(prefix)
    }
}
func hasSuffix(_ suffix: String) -> ((String) -> Bool) { { $0.hasSuffix(suffix) } }

var str = "jack"
//其实就是字符串和函数进行匹配
switch str {
    case hasPrefix("j"), //调用hasPrefix后,返回一个函数,再调用这个函数把jack传进去,其实就是227行的代码,然后去执行这个函数,就是233行的代码  就相当于 jack.hasPrefix('j')
         hasSuffix("k"): //case后是一个 参数是string返回值是bool类型的函数 ,所以217行 pattern参数 就是这种类型的
        print("以j开头，以k结尾")
    default: break
} // 以j开头，以k结尾

//例子3:
func isEven(_ i: Int) -> Bool { i % 2 == 0 }
func isOdd(_ i: Int) -> Bool { i % 2 != 0 }
extension Int {
    static func ~= (pattern: (Int) -> Bool, value: Int) -> Bool {
        pattern(value)
    }
}
var age3 = 9
switch age3 {
case isEven:
    print("偶数")
case isOdd:
    print("奇数")
default:
    print("其他")
}

//例子4:我们自定义一个运算符,判断一个数是 >, >= , < , <= 某个数
/*
 因为
 extension Int {
     static func ~= (pattern: (Int) -> Bool, value: Int) -> Bool {
         pattern(value)
     }
 }
 例子3已经写了,所以例子4就不写了
 */
prefix operator ~>
prefix operator ~>=
prefix operator ~<
prefix operator ~<=
prefix func ~> (_ i: Int) -> ((Int) -> Bool) { { $0 > i } }
prefix func ~>= (_ i: Int) -> ((Int) -> Bool) { { $0 >= i } }
prefix func ~< (_ i: Int) -> ((Int) -> Bool) { { $0 < i } }
prefix func ~<= (_ i: Int) -> ((Int) -> Bool) { { $0 <= i } }

var age4 = 9
switch age4 {
case ~>=0,~<=10: //大于等于=或者<=10
    print("1")
case ~>10,~<20:
    print("2")
default:
    break
} // 1

//MARK: - ------------------------------------where-------------------------------------
//where能用到的地方,case,for循环,关联类型中(协议),函数的返回值后边对泛型类型进行一些约束,带条件的扩展
//可以使用where为模式匹配增加匹配条件
var data = (10, "Jack")
switch data {
    case let (age, _) where age > 10:
        print(data.1, "age>10")
    case let (age, _) where age > 0:
        print(data.1, "age>0")
    default: break
}

var ages5 = [10, 20, 44, 23, 55]
for age in ages5 where age > 30 {
    print(age)
} // 44 55

//where也可以用到协议里
protocol Stackable { associatedtype Element }
protocol Container { //关联类型的Stack要遵守Stackable协议,既然你遵守Stackable协议,证明了Stack里边也有个关联类型Element,这个Element的关联类型也要遵守Equatable协议
    associatedtype Stack : Stackable where Stack.Element : Equatable
}

func equal<S1: Stackable, S2: Stackable>(_ s1: S1, _ s2: S2) -> Bool
    where S1.Element == S2.Element, S1.Element : Hashable {
    return false
}

extension Container where Self.Stack.Element : Hashable { }

