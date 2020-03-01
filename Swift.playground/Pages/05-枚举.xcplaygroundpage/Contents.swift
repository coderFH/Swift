//: [上一页](@previous)

import Foundation

//: #### 1.枚举的基本用法
enum Direction {
    case north
    case south
    case east
    case west
}

var dir = Direction.west
dir = Direction.east
dir = .north
print(dir)

//: - 这种写法和上边的效果一样
enum Directon1 {
    case north,south,east,west
}

switch dir {
case .north:
    print("norht");
case .south:
    print("south");
case .east:
    print("east");
case .west:
    print("west");
}

//: #### 2.关联值
//: - 有时会将枚举的成员值跟他类型的关联存储在一起,会非常有用
enum Score {
    case point(Int)
    case grate(Character)
}

var score = Score.point(96)
score = .grate("A")

switch score {
case let .point(i):
    print(i,"points")
case let .grate(i):
    print("grade",i)
}

enum Date {
    case digit(year : Int,month : Int,day : Int)
    case string(String)
}

var date = Date.digit(year: 2011, month: 9, day: 10)
date = .string("2011-09-10")
switch date {
case .digit(let year, let month, let day):
    print(year,month,day)
case let .string(value):
    print(value)
}

//: #### 3.关联值举例
enum Password {
    case number(Int,Int,Int,Int)
    case gesture(String)
}

var pwd = Password.number(3, 5, 7, 8)
pwd = .gesture("12369")

switch pwd {
case let .number(n1, n2, n3, n4):
    print("number is",n1,n2,n3,n4)
case let .gesture(str):
    print("gesture is",str)
}

//: #### 4.原始值
//: - 枚举成员可以使用相同类型的默认值预先关联,这个默认值叫做:原始值
enum PokerSuit : Character {
    case spade = "♠️"
    case heart = "♥️"
    case diamond = "🐶"
    case clue = "♣️"
}

var suit = PokerSuit.spade
print(suit)
print(suit.rawValue)
print(PokerSuit.clue.rawValue)

enum Grade : String {
    case perfect = "A"
    case great = "B"
    case good = "C"
    case bad = "D"
}

print(Grade.perfect.rawValue)
print(Grade.great.rawValue)
print(Grade.good.rawValue)
print(Grade.bad.rawValue)


//: #### 5.隐式原始值
//: - 如果枚举的原始值是Int,String,Swift会自动分配原始值
enum Direction2 : String {
    case north,south,east,west
}

print(Direction2.north)
print(Direction2.north.rawValue)

enum Season : Int {
    case spring,summmer,autumn,winter
}
print(Season.spring.rawValue)
print(Season.summmer.rawValue)
print(Season.autumn.rawValue)
print(Season.winter.rawValue)

enum Season1 : Int {
    case spring = 1,summmer,autumn = 4 ,winter
}
print(Season1.spring.rawValue)
print(Season1.summmer.rawValue)
print(Season1.autumn.rawValue)
print(Season1.winter.rawValue)

//: #### 6.递归枚举
//递归枚举必须加关键字indirect,否则编译器会报错
indirect enum ArithExpr {
    case number(Int)
    case sum(ArithExpr,ArithExpr)
    case difference(ArithExpr,ArithExpr)
}

//或者
//enum ArithExpr1 {
//    case number(Int)
//    indirect case sum(ArithExpr1,ArithExpr1)
//    indirect case difference(ArithExpr1,ArithExpr1)
//}

let five = ArithExpr.number(5)
let four = ArithExpr.number(4)
let two = ArithExpr.number(2)
let sum = ArithExpr.sum(five, four)
let difference = ArithExpr.difference(sum, two)

func calculate(_ expr : ArithExpr) -> Int {
    switch expr {
    case let .number(value):
        return value
    case let .sum(left,right):
        return calculate(left) + calculate(right)
    case let .difference(left, right):
        return calculate(left) - calculate(right)
    }
}
calculate(difference)

//: #### 7.MemoryLayout
//: #### - 可以使用MemoryLayout获取数据类型占用的内存大小
enum Password1 {
    case number(Int,Int,Int,Int)
    case other
}
MemoryLayout<Password1>.stride //分配占用的空间打下 8的倍数
MemoryLayout<Password1>.size //实际用到的内存大小 4*8=32 + 1 = 33
MemoryLayout<Password1>.alignment //对齐参数


//var pwd1 = Password1.number(8, 8, 6, 5)
//pwd1 = .other
//MemoryLayout<pwd1>.stride
//MemoryLayout<pwd1>.size
//MemoryLayout<pwd1>.alignment


enum Test : Int {
    case One,two,three
}
MemoryLayout<Test>.stride
MemoryLayout<Test>.size
MemoryLayout<Test>.alignment

enum Test1 : String {
    case One,two,three
}
MemoryLayout<Test1>.stride
MemoryLayout<Test1>.size
MemoryLayout<Test1>.alignment


//: [下一页](@next)
