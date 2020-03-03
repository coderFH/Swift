//
//  main.swift
//  12-泛型
//
//  Created by wangfh on 2020/3/2.
//  Copyright © 2020 wangfh. All rights reserved.
//

import Foundation

//MARK: ------------------------------------- 泛型(Generics) -------------------------------------
//泛型可以将类型参数化，提高代码复用率，减少代码量
func swapValues<T>(_ a: inout T, _ b: inout T) { // <T>里边可以写多个,来表示多种类型,比如<T1,T2,T3>
    (a, b) = (b, a)
}

var i1 = 10
var i2 = 20
swapValues(&i1, &i2)

var d1 = 10.0
var d2 = 20.0
swapValues(&d1, &d2)

struct Date {
    var year = 0, month = 0, day = 0
}
var dd1 = Date(year: 2011, month: 9, day: 10)
var dd2 = Date(year: 2012, month: 10, day: 11)
swapValues(&dd1, &dd2)

//泛型函数赋值给变量
func test<T1, T2>(_ t1: T1, _ t2: T2) {}
var fn: (Int, Double) -> () = test  // 一定要注意写 (Int, Double) -> ()明确告诉fn是什么类型,要不会报错,因为是泛型,我不知道你的类型


//MARK: ------------------------------------- 泛型 -------------------------------------
class Stack<E> {
    var elements = [E]()
    func push(_ element: E) { elements.append(element) }
    func pop() -> E { elements.removeLast() }
    func top() -> E { elements.last! }
    func size() -> Int { elements.count }
}
//如果存在继承就这么写
class SubStack<E> : Stack<E> {}

var stack = Stack<Int>()
stack.push(11)
stack.push(22)
stack.push(33)
print(stack.top()) // 33
print(stack.pop()) // 33
print(stack.pop()) // 22
print(stack.pop()) // 11
print(stack.size()) // 0

struct Stack1<E> {
    var elements = [E]()
    mutating func push(_ element: E) { elements.append(element) }
    mutating func pop() -> E { elements.removeLast() }
    func top() -> E { elements.last! }
    func size() -> Int { elements.count }
}

enum Score<T> {
    case point(T)
    case grade(String)
}
let score0 = Score<Int>.point(100)
let score1 = Score.point(99) //如果你传去的99,明确知道是int,所以<Int>可以省略
let score2 = Score.point(99.5)
let score3 = Score<Int>.grade("A") //这里虽然你调用的是grade,但是Score这个泛型T我是不知道什么类型的,所以需要加上<Int>,告诉他这个泛型是Int


//MARK: ------------------------------------- 关联类型(Associated Type) -------------------------------------
//关联类型的作用:给协议中用到的类型定义一个占位名称
//协议中可以拥有多个关联类型
protocol Stackable {
    associatedtype Element // 关联类型 注意: 在协议中,不能像在类,结构体,枚举中那样,使用<T>来表示泛型,就应该这么表示
    mutating func push(_ element: Element) //为了保证通用,加了mutating,因为结构体也可能遵守这个协议
    mutating func pop() -> Element
    func top() -> Element
    func size() -> Int
}

class StringStack : Stackable {
    // 给关联类型设定真实类型
    // typealias Element = String //要给协议的关联类型赋值,可以这么写,但其实不写也行,因为下边的var elements = [String]() 也能确定Element是什么类型
    var elements = [String]()
    func push(_ element: String) { elements.append(element) }
    func pop() -> String { elements.removeLast() }
    func top() -> String { elements.last! }
    func size() -> Int { elements.count }
}
var ss = StringStack()
ss.push("Jack")
ss.push("Rose")

//遵守协议的类依然支持泛型就这么写
class Stack2<E> : Stackable {
    // typealias Element = E //跟StringStack同理
    var elements = [E]()
    func push(_ element: E) {
        elements.append(element)
    }
    func pop() -> E { elements.removeLast() }
    func top() -> E { elements.last! }
    func size() -> Int { elements.count }
}

//MARK: ------------------------------------- 类型约束 -------------------------------------
protocol Runnable1 { }
class Person {}
func swapValues<T : Person & Runnable1>(_ a: inout T, _ b: inout T) { //这种约束说明我的这个泛型是person类或其子类,并且遵守Runnable1协议
    (a, b) = (b, a)
}

//---------------
protocol Stackable1 {
    associatedtype Element: Equatable //要求关联的类型遵守Equatable协议
}
class Stack4<E : Equatable> : Stackable1 { typealias Element = E } //<E : Equatable> 要求Stack4的泛型也遵守Equatable协议

//---------------
//泛型S1和S2都遵守Stackable1协议,并且S1和S2的关联类型是一样的,比如都是Int或者Double,并且S1的关联类型遵守Hashable协议
func equal<S1: Stackable1, S2: Stackable1>(_ s1: S1, _ s2: S2) -> Bool where S1.Element == S2.Element, S1.Element : Hashable {
    return false
}

var stack0 = Stack4<Int>()
var stack1 = Stack4<Int>()
var stack2 = Stack4<String>()
equal(stack0, stack1)
//equal(stack1, stack2) // 报错,关联类型不是同一种类型  error: requires the types 'Int' and 'String' be equivalent


//MARK: ------------------------------------- 协议类型的注意点 -------------------------------------
protocol Run {}
class Student : Run {}
class Car : Run {}
/*这种返回一个协议的用处是什么?
 我只希望你知道我返回给你的对象是遵守Run协议的就可以,你想调方法,只能调我协议里暴露的方法.
 假如我这里直接返回一个明确的对象,比如返回Student或者Car,而Student或者Car里有其他方法,我是不是就能调用了
 但我不想你去调用这些类里的方法,只允许你调用我协议里规定的方法,所以这里返回一个遵守协议的就可以实现了,我里边具体给你返回什么对象你不用管
 */
func get(_ type: Int) -> Run {
    if type == 0 {
        return Student()
    }
    return Car()
}
var r1 = get(0) //r1是Run类型的,只有程序在运行过程中,才能知道你具体传过来的是什么对象
var r2 = get(1)


//如果协议中有associatedtype
 protocol Run2 {
    associatedtype Speed
    var speed: Speed { get } //只读
}
class Dog : Run2 {
    var speed: Double { 0.0 }
}
class Pig : Run2 {
    var speed: Int { 0 }
}

/*
 就会报错
 Protocol 'Run2' can only be used as a generic constraint because it has Self or associated type requirements
 为什么关联里类型,再这么写就报错呢?
 我们前边说过,这么写的时候,当调用getDp()这个函数时,在编译器,编译器只知道你是Run2类型的,不知道你具体是Dog类型还是Pig类型
 只有在运行期间才能确定,这就导致了你的关联类型speed在编译期间也是不确定是什么类型的(比如Dog和pig里返回的double和int,编译器是不知道的),所以就报错了
 */
//func getDp(_ type: Int) -> Run2 {
//    if type == 0 {
//        return Dog()
//    }
//    return Pig()
//}

//MARK: ------------------------------------- 泛型解决 -------------------------------------
//那以上问题怎么解决呢?
//解决方案1:使用泛型
 func getNewDp<T : Run2>(_ type: Int) -> T {
    if type == 0 {
        return Dog() as! T
    }
    return Pig() as! T
}
var r3: Dog = getNewDp(0) //这里定义必须写 : Dog 表明是什么类型的,这样你181行返回的泛型T就能确定类型
var r4: Pig = getNewDp(1)



//MARK: ------------------------------------- 不透明类型-------------------------------------
//解决方案2:使用some关键字声明一个不透明类型 some只能返回一种类型,编译器自然知道你的关联类型返回的是哪个,就肯定不报错了
//为什么叫不透明的?其实跟上边的解释类似,你外部只知道我返回给你的是遵守Run2协议的对象,但具体是哪个对象你是不知道的,并且你能调用的方法,也只有Run2协议里规定的方法,所以叫不透明类型
func getSome(_ type: Int) -> some Run2 {
    return Pig()
}
var s1 = getSome(0)
var s2 = getSome(1)

//some只能返回一种类型 以下代码报错
//func getSome(_ type: Int) -> some Run2 {
//   if type == 0 {
//        return Dog()
//    }
//    return Pig()
//}

//MARK: ------------------------------------- some -------------------------------------
//some除了用在返回值类型上，一般还可以用在属性类型上
protocol Runn3 { associatedtype Speed }
class Panda : Runn3 { typealias Speed = Double }
class People {
    var pet: some Runn3 { //这里的意思是我想养一只宠物,但我又不想让外界知道我养的是什么宠物,只知道这个宠物是遵守Runn3协议的
        return Panda()
    }
}

//MARK: ------------------------------------- 可选项的本质 -------------------------------------
enum Scores {
    case point(Int)
    case grade(String)
    case other
}
var cc : Scores = Scores.other
cc = Scores.point(10)
cc = Scores.grade("A")

//可选项的本质是enum类型,以下是可选类型的定义
/*
public enum Optional<Wrapped> : ExpressibleByNilLiteral {
    case none
    case some(Wrapped)
    public init(_ some: Wrapped)
}*/

var age: Int? = 10  //这种定义其实就是语法糖,他跟下边的各种写法是一样的
var age0: Optional<Int> = Optional<Int>.some(10)
var age1: Optional = .some(10)
var age2 = Optional.some(10)
var age3 = Optional(10) //调用init的指定初始化器创建的
age = nil
age3 = .none

var age4: Int? = nil
var age5 = Optional<Int>.none //注意Optional<Int> 这里的<Int>不能省,因为你虽然取值是.none,但是你Optional定义的有个泛型,case some(Wrapped),需要明确的告诉泛型的类型,即泛型的类型一定要明确
var age6: Optional<Int> = .none

//定义是可以混着使用的,怎么混着使用? 像左边是var age7: Int? 但你又边不一定非得是10(或者其他值),可以是.none 因为本质都是语法糖
var age7: Int? = .none
age7 = 10
age7 = .some(20)
age7 = nil

//switch case问题
//正常的使用比如
var age8 = 10
switch age8 {
case 10:
    print("1")
case 20:
    print("2")
default:
   break
}

//当然我们还可以进行值绑定
var age9 = 10
switch age9 {
case let a: //这么写的意思是无条件绑定,就是把age9的值给a,可以加条件,在后边写上where age9 > 20即可
    print(a)
case 20:
    print("2")
default:
   break
}

//下面就看看可选类型的绑定问题
switch age {
    case let v?: //这里的?号意思就是,如果age不nil,会进行解包后赋值给v,我们可以看到v已经不是可选类型了
        print("some", v)
    case nil:
        print("none")
}

//或者下边的这种方式,两种完全等价
switch age {
    case let .some(v):
        print("some", v)
    case .none:
        print("none")
}


//多重可选项
var height_: Int? = 10
var height: Int?? = height_
height = nil

//以下这两种写法,跟上边的是一个意思
var h1 = Optional.some(Optional.some(10))
h1 = .none
var h2: Optional<Optional> = .some(.some(10))
h2 = .none


var h3: Int?? = 10
var h4: Optional<Optional> = 10
