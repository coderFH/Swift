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
        return num }
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
        return num }
}
var cs1 = Closure()
var cs2 = Closure()
print(cs1.plus(1))  // 1
print(cs2.plus(2)) // 2
print(cs1.plus(3)) // 4
print(cs2.plus(4)) // 6
print(cs1.plus(5)) // 9
print(cs2.plus(6)) // 12

