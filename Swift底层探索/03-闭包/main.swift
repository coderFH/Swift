//
//  main.swift
//  03-闭包
//
//  Created by wangfh on 2019/7/1.
//  Copyright © 2019 wangfh. All rights reserved.
//

import Foundation

//MARK: ------------------------------------- 1.闭包表达式-------------------------------------
// 在swift中,可以通过func定义一个函数,也可以通过闭包表达式定义一个函数
func sum(_ v1 : Int,_ v2 : Int) -> Int {
    return v1 + v2
}

/*
 {
    (参数列表) -> 返回值类型 in
        函数体代码
 }
 */
var fn = {
    (v1 : Int,v2 : Int) -> Int in
        return v1 + v2
}
print(fn(10,20))


print({ (v1 : Int,v2 : Int) -> Int in
            return v1 + v2
    }(10,20))

//MARK: ------------------------------------- 2.闭包表达式的简写-------------------------------------
func exec(v1 : Int,v2 : Int,fn : (Int,Int) -> Int) {
    print(fn(v1,v2))
}

exec(v1: 10, v2: 20) {
    (v1 : Int, v2 : Int) -> Int in
    return v1 + v2
}

exec(v1: 10, v2: 20,fn: {
    v1, v2 in
    return v1 + v2
})

exec(v1: 10, v2: 20, fn: {
    v1,v2 in v1 + v2
})

exec(v1: 10, v2: 20, fn: {$0 + $1})
exec(v1: 10, v2: 20, fn: +)

//MARK: ------------------------------------- 3.尾随闭包-------------------------------------
//如果将一个很长的闭包表达式作为函数的最后一个实参，使用尾随闭包可以增强函数的可读性
    //尾随闭包是一个被书写在函数调用括号外面(后面)的闭包表达式
func exec1(v1 : Int,v2 : Int,fn : (Int,Int) -> Int) {
    print(fn(v1,v2))
}

exec1(v1: 10, v2: 20) {
    $0 + $1
}

//如果闭包表达式是函数的唯一实参,而且使用了尾随闭包的语法,那么就不需要再函数后边写圆括号
func exec2(fn : (Int,Int) -> Int) {
    print(fn(1,2))
}
exec2(fn: {$0 + $1})
exec2(){$0 + $1}
exec2 {$0 + $1}

//MARK: ------------------------------------- 4.示例-数组的排序-------------------------------------
var nums = [11,2,18,6,5,68,45]
//
//func cmp(i1 : Int,i2 : Int) -> Bool {
//    return i1 > i2
//}
//nums.sort(by: cmp)

nums.sort(by: {
    (i1 : Int,i2 : Int) -> Bool in
    return i1 < i2
})
nums.sort(by: { i1,i2 in return i1 < i2 })
nums.sort(by: { i1,i2 in i1 < i2 })
nums.sort(by: { $0 < $1 })
nums.sort() { $0 < $1 }
nums.sort { $0 < $1 }
print(nums)

//MARK: ------------------------------------- 5.忽略参数-------------------------------------
func exec3(fn : (Int,Int)-> Int) {
    print(fn(1,2))
}
exec3 {_,_ in 10}

//MARK: ------------------------------------- 6.闭包-------------------------------------
/*
 网上有各种关于闭包的定义，个人觉得比较严谨的定义是
    一个函数和它所捕获的变量\常量环境组合起来，称为闭包
        一般指定义在函数内部的函数
        一般它捕获的是外层函数的局部变量\常量
*/
typealias Fn = (Int) -> Int
func getFn() -> Fn {
    var num = 0
    func plus(_ i: Int) -> Int {
        num += i //函数内部捕获了外部变量num,分析汇编可以发现底层是在堆空间开辟了一个num去存数值的
        return num
    }
    return plus
} // 返回的plus和num形成了闭包

//也可以这么写
/*
func getFn() -> Fn {
    var num = 0
    return {
        num += $0
        return num
    }
}
*/

var fn1 = getFn()
var fn2 = getFn()
print(fn1(1))  // 1
print(fn1(2))
print(fn1(3))
print(fn1(4))
print(fn1(5))
print(fn1(16))

/*
可以把闭包想象成是一个类的实例对象
内存在堆空间
捕获的局部变量\常量就是对象的成员(存储属性)
组成闭包的函数就是类内部定义的方法
 */
class Closure {
    var num = 0
    func plus(_ i: Int) -> Int {
        num += i
        return num
    }
}
var cs1 = Closure()
var cs2 = Closure()
print(cs1.plus(1))  // 1
print(cs2.plus(2)) // 2
print(cs1.plus(3)) // 4
print(cs2.plus(4)) // 6
print(cs1.plus(5)) // 9
print(cs2.plus(6)) // 12

//MARK: ------------------------------------- 7.练习 -------------------------------------
print("=========练习1==========");
typealias Fnf = (Int) -> (Int,Int)
func getFns() -> (Fnf,Fnf) {
    var num1 = 0
    var num2 = 0
    func plus(_ i : Int) -> (Int,Int) {
        num1 += i
        num2 += i << 1
        return (num1,num2)
    }
    func minus(_ i : Int) -> (Int,Int) {
        num1 -= i
        num2 -= i << 1
        return (num1,num2)
    }
    return (plus,minus)
}
let (p,m) = getFns() //返回一个元组,元组里是两个方法
print(p(5)) //(5,10)  0 + 5 = 5   0  + 5 * 2 = 10
print(m(4)) //(1,2)   5 - 4 = 1   10 - 4 * 2 = 2
print(p(3)) //(4,8)   1 + 3 = 4   2  + 3 * 2 = 8
print(m(2)) //(2,4)   4 - 2 = 2   8 -  2 * 2 = 4

print("===================");
//使用类实现,底层也是一样,会捕获局部变量
class Closuref {
    var num1 = 0
    var num2 = 0
    func plus(_ i : Int) -> (Int,Int) {
        num1 += i
        num2 += i << 1
        return (num1,num2)
    }
    func minus(_ i : Int) -> (Int,Int) {
        num1 -= i
        num2 -= i << 1
        return (num1,num2)
    }
}
var cs = Closuref()
print(cs.plus(5))
print(cs.minus(4))
print(cs.plus(3))
print(cs.minus(2))

print("=========练习2==========");
var functions : [()->Int] = []
for i in 1...3 {
    functions.append { i }
}
for f in functions {
    print(f())
}
print("===================");
//使用类实现,也是一样的
class Closure1 {
    var i : Int
    init(_ i : Int) {
        self.i = i
    }
    func get() -> Int {
        return i
    }
}

var clses : [Closure1] = []
for i in 1...3 {
    clses.append(Closure1(i))
}
for cls in clses {
    print(cls.get())
}

//MARK: ------------------------------------- 8.注意 -------------------------------------
//如果返回值是函数类型,那么参数的修饰要保持统一
func add(_ num : Int) -> (inout Int) -> Void {
    func plus(v : inout Int) {
        v += num
    }
    return plus;
}

var num = 5
add(20)(&num)
print(num)

//MARK: ------------------------------------- 9.自动闭包 -------------------------------------
//如果第一个数大于0,返回第一个数,否者返回第二个数
func getFirstPossitive(_ v1 : Int,_ v2 : Int) -> Int {
    return v1 > 0 ? v1 : v2
}
print(getFirstPossitive(10, 20)) //10
print(getFirstPossitive(-2, 20)) //20
print(getFirstPossitive(0, -4))  //-4

//改成函数类型的参数,可以让v2延迟加载
func getFirst1(_ v1 : Int,_ v2 : ()->Int) -> Int? {
    return v1 > 0 ? v1 : v2()
}
print( getFirst1(-4){ 20 })

/*
 autoclosure 会自动将20 封装成闭包{20}
 autoclosure 只支持()->T格式的参数
 autoclosure 并非只支持最后1个参数
 空合运算符 ?? 使用了@autoclosure技术
 有autoclosure,无autoclosure 构成了函数重载
 */
func getFirst2(_ v1 : Int,_ v2 : @autoclosure ()->Int) -> Int? {
    return v1 > 0 ? v1 : v2()
}
print(getFirst2(-4, 20))
