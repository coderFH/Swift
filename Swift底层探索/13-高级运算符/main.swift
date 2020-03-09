//
//  main.swift
//  13-高级运算符
//
//  Created by wangfh on 2020/3/9.
//  Copyright © 2020 wangfh. All rights reserved.
//

import Foundation

//MARK: ------------------------------------- 溢出运算符 -------------------------------------
//swift的算数运算符出现溢出时会抛出运行时错误
//Swift有溢出运算符(&+、&-、&*)，用来支持溢出运算
print(Int8.min) //-128
print(Int8.max) //127

print(UInt8.min) //0
print(UInt8.max) //255

//正常情况下,UInt8最大是255,如果我们加1,程序会直接崩溃
var v1 = UInt8.max
//var v2 = v1 + 1; //崩溃了

//这个时候可以使用溢出运算符解决
var v3 = v1 &+ 1;
print(v3) //0  溢出运算符,底层其实是最高为进位了,剩下的八位为0,给人的感觉就是一个循环,超过了255,就从0开始

var min = UInt8.min
print(min &- 1) // 255

var max = UInt8.max
print(max &* 2) // 254, 等价于 max &+ max 即255 + 255,刚可以看到255+1=0,所以相当于0+254=254

//MARK: ------------------------------------- 运算符重载(Operator Overload) -------------------------------------
//类、结构体、枚举可以为现有的运算符提供自定义的实现，这个操作叫做:运算符重载
struct Point {
    var x: Int, y: Int
}

func + (p1: Point, p2: Point) -> Point {
    Point(x: p1.x + p2.x, y: p1.y + p2.y)
}

let p = Point(x: 10, y: 20) + Point(x: 11, y: 22)
print(p) // Point(x: 21, y: 42)

//但是一般情况下,属于哪个类的运算符一般放到类的里边
struct Point1 {
    var x: Int, y: Int
    static func + (p1: Point1, p2: Point1) -> Point1 { //用static修饰表示类型方法,可以通过类型调用
        Point1(x: p1.x + p2.x, y: p1.y + p2.y)
    }
    
    static func - (p1: Point1, p2: Point1) -> Point1 {
        Point1(x: p1.x - p2.x, y: p1.y - p2.y)
    }
    
    static prefix func - (p: Point1) -> Point1 { //prefix 表示前缀 比如 -Point1(x: 1, y: 1) 的时候,会调用这个方法
        Point1(x: -p.x, y: -p.y)
    }
    
    static func += (p1: inout Point1, p2: Point1) {
        p1 = p1 + p2
    }
    
    static prefix func ++ (p: inout Point1) -> Point1 { //前++
        p += Point1(x: 1, y: 1)
        return p
    }
    
    static postfix func ++ (p: inout Point1) -> Point1 { //后++
        let tmp = p
        p += Point1(x: 1, y: 1)
        return tmp
    }
    
    static func == (p1: Point1, p2: Point1) -> Bool {
        (p1.x == p2.x) && (p1.y == p2.y)
    }
}

let p1 = Point1(x: 10, y: 20) + Point1(x: 11, y: 22)
print(p1) // Point(x: 21, y: 42)

var p2 = Point1(x: 1, y: 1)
var p3 = Point1(x: 2, y: 2)
print(p2+p3) //结构体是值类型用p2+p3 其实就相当于Point1(x: 1, y: 1) + Point1(x: 2, y: 2)

print("-",p3-p2);
print("取负数",-p3)
p2 += p3
print("+=",p2)
print("前++",++p2)
print("后++",p3++)
print(p2==p3)

//MARK: ------------------------------------- Equatable -------------------------------------
/*
 要想得知2个实例是否等价，一般做法是遵守Equatable 协议，重载== 运算符
    与此同时，等价于重载了 != 运算符
 */

class Animal: Equatable {
    var age : Int
    init(age : Int) {
        self.age = age
    }
    static func == (lhs : Animal,rhs : Animal) -> Bool {
        lhs.age == rhs.age
    }
}

var a1 = Animal(age: 10)
var a2 = Animal(age: 10)
print(a1 == a2)
print(a1 != a2) //如果我们遵守了Equatable协议,相当于也重载了!=运算符

/*
 根据前边的运算符重载我们知道,即使我不遵守Equatable协议,也是可以进行==运算符重载,那为啥还要遵守这个协议
 1.首先我们遵守Equatable这个协议,别人使用的时候可以马上知道我们这个类是支持比较的
 2.请看下边的例子,我有一个equls方法,泛型是遵守Equatable,这样我Animal这个类,就能使用下边的这个方法判读,如果是单纯的运算符重载
 不遵守Equatable很明显不能使用下面这个方法
*/
func equls<T : Equatable>(_ t1 : T,_ t2 : T) {
    t1 == t2
}

equls(a1,a2)

//引用类型比较存储的地址值是否相等(是否引用着同一个对象)，使用恒等运算符=== 、!==
print("是否指向同一对象",a1 === a2)
a1 = a2
print("是否指向同一对象",a1 === a2)

/*
 Swift为以下类型提供默认的Equatable 实现
    没有关联类型的枚举
    只拥有遵守 Equatable 协议关联类型的枚举
    只拥有遵守 Equatable 协议存储属性的结构体
 */
//Swift发现你是没有关联类型的枚举,提供默认的Equatable 实现
enum Answer {
    case wrong
    case right
}

var r = Answer.right
var w = Answer.wrong

print(r == w)

// 只拥有遵守Equatable协议关联类型的枚举,因为你关联的值Int,其实也是遵守Equatable协议的,编译器知道如何比较,所以也是可以的
enum Answer1 : Equatable { //首先我是个关联类型的枚举,然后我关联的Int也是遵守Equatable协议的
    case wrong(Int)
    case right
}

var r1 = Answer1.wrong(10)
var w1 = Answer1.wrong(10)

print(r1 == w1)

//只拥有遵守 Equatable 协议存储属性的结构体
struct Point2 : Equatable {
    var x: Int, y: Int //存储属性的Int也是遵守Equatable协议的
}
var o1 = Point2(x: 10, y: 20)
var o2 = Point2(x: 11, y: 22)
print(o1 == o2) // false
print(o1 != o2) // true

//MARK: ------------------------------------- Comparable -------------------------------------
// score大的比较大，若score相等，age小的比较大
struct Student : Comparable {
    var age: Int
    var score: Int
    init(score: Int, age: Int) {
        self.score = score
        self.age = age
    }
    static func < (lhs: Student, rhs: Student) -> Bool {
        (lhs.score < rhs.score)
        || (lhs.score == rhs.score && lhs.age > rhs.age)
    }
    static func > (lhs: Student, rhs: Student) -> Bool {
        (lhs.score > rhs.score)
            || (lhs.score == rhs.score && lhs.age < rhs.age)
    }
    static func <= (lhs: Student, rhs: Student) -> Bool {
        !(lhs > rhs)
    }
    static func >= (lhs: Student, rhs: Student) -> Bool {
        !(lhs < rhs)
    }
}
/*
要想比较2个实例的大小，一般做法是:
 遵守 Comparable 协议
 重载相应的运算符
 */
var stu1 = Student(score: 100, age: 20)
var stu2 = Student(score: 98, age: 18)
var stu3 = Student(score: 100, age: 20)
print(stu1 > stu2) // true
print(stu1 >= stu2) // true
print(stu1 >= stu3) // true
print(stu1 <= stu3) // true
print(stu2 < stu1) // true
print(stu2 <= stu1) // true


//MARK: ------------------------------------- 自定义运算符(Custom Operator) -------------------------------------
/*
可以自定义新的运算符:在全局作用域使用operator进行声明
prefix operator 前缀运算符
postfix operator 后缀运算符
infix operator 中缀运算符 : 优先级组
 
precedencegroup 优先级组 {
 associativity: 结合性(left\right\none)
 higherThan: 比谁的优先级高
 lowerThan: 比谁的优先级低
 assignment: true代表在可选链操作中拥有跟赋值运算符一样的优先级
}
 */

prefix operator +++ //自定义一个前+++的运算符

infix operator +- : PlusMinusPrecedence //自定义一个+-运算符

precedencegroup PlusMinusPrecedence {
    associativity: none  //不支持连着+-
    higherThan: AdditionPrecedence //比+号优先级高
    lowerThan: MultiplicationPrecedence //比*号优先级低
    assignment: true
}

struct Point3 {
    var x: Int, y: Int
    static prefix func +++ (point: inout Point3) -> Point3 {
        point = Point3(x: point.x + point.x, y: point.y + point.y)
        return point
    }
//    static func +- (left: Point3, right: Point3) -> Point3 {
//        return Point3(x: left.x + right.x, y: left.y - right.y)
//    }
    static func +- (left: Point3?, right: Point3) -> Point3 {
        print("+-+-+-+-+-+-+-+-+-")
        return Point3(x: left?.x ?? 0 + right.x, y: left?.y ?? 0 - right.y)
    }
}

var t = Point3(x: 1, y: 1)
print(+++t)

var t1 = Point3(x: 10, y: 10)
var t2 = Point3(x: 10, y: 10)
print(t1 +- t2)


struct Person {
    var point : Point3
}

//var person: Person? = Person(point: t1)
var person: Person? = nil
var t3 = person?.point +- Point3(x: 10, y: 20)  //assignment: true 会像可选链一样,如果person返回的是nil,就不执行右边的Point3(x: 10, y: 20)初始化操作
if let t4 = t3 {
    print(t4)
} else {
    print("为nil,并且没有走+-方法")
}



