//
//  main.swift
//  24-函数式编程
//
//  Created by wangfh on 2020/3/18.
//  Copyright © 2020 wangfh. All rights reserved.
//

import Foundation

//MARK: - ------------------------------------传统写法-------------------------------------
// 假设要实现以下功能:[(num + 3) * 5 - 1] % 10 / 2
var num = 1
func add(_ v1: Int, _ v2: Int) -> Int { v1 + v2 }
func sub(_ v1: Int, _ v2: Int) -> Int { v1 - v2 }
func multiple(_ v1: Int, _ v2: Int) -> Int { v1 * v2 }
func divide(_ v1: Int, _ v2: Int) -> Int { v1 / v2 }
func mod(_ v1: Int, _ v2: Int) -> Int { v1 % v2 }

//调用这么写,显然看着很不爽
print(divide(mod(sub(multiple(add(num, 3), 5), 1), 10), 2))

//MARK: - ------------------------------------函数式写法-------------------------------------
//func fadd(_ v1 : Int) -> (Int) -> Int {
//    return {
//        (value) in
//        return value + v1
//    }
//}
func fadd(_ v : Int) -> (Int) -> Int {{ $0 + v }}
func fsub(_ v : Int) -> (Int) -> Int {{ $0 - v }}
func fmul(_ v : Int) -> (Int) -> Int {{ $0 * v }}
func fdiv(_ v : Int) -> (Int) -> Int {{ $0 / v }}
func fmod(_ v : Int) -> (Int) -> Int {{ $0 % v }}

let fn1 = fadd(3)
let fn2 = fmul(5)
let fn3 = fsub(1)
let fn4 = fmod(10)
let fn5 = fdiv(2)
//这种写法明显也是不好的,我们可以重载一个运算符
print(fn5(fn4(fn3(fn2(fn1(num))))))


infix operator >>> : AdditionPrecedence
func >>><A,B,C>(_ f1 : @escaping (A) -> B,
                _ f2 : @escaping (B)-> C) -> (A) -> C {
//    {
//        f2(f1($0))
//    }
    
    return {
        (num) in
        return f2(f1(num))
    }
}
var fn = fadd(3) >>> fmul(5) >>> fsub(1) >>> fmod(10) >>> fdiv(2)
print(fn(num)) //其实就是num传递给了f1 f1执行了+3的结果 作为参数传递给fn2 fn2执行了-5后的结果的类型 其实 就是返回这个函数的返回类型 相当于传进去A类型 返回一个B类型 然后这个B类型当参数返回一个C类型 ,最后的返回就是传递一个A类型,返回一个C类型


//MARK: - ------------------------------------柯里化-------------------------------------
// 什么是柯里化?
// 将一个接受多参数的函数变换为一系列只接受单个参数的函数
func padd(_ v1: Int, _ v2: Int) -> Int { v1 + v2 }
print(padd(10, 20))
//padd的柯里化版本
func kadd(_ v: Int) -> (Int) -> Int { { $0 + v } }
print(kadd(10)(20))


func add2(_ v1: Int, _ v2: Int, _ v3: Int) -> Int { v1 + v2 + v3 }
print(add2(10, 20, 30))
//add2的柯里化版本
//其实就是一个从右到左往里深入的过程  你看参数 依次是v3 v2 v1
func kadd2(_ v : Int) -> (Int) -> ((Int) -> Int) {
//    return {
//        v2 == 20
//        v2 in
//        return {
//            v1 == 10
//            v1 in
//            return v1 + v2 + v
//        }
//    }
    
    //简化写法 去掉return
    { v2 in {  v1 in v1 + v2 + v } }
}

print(kadd2(30)(20)(10))

//MARK: - ------------------------------------利用泛型,快速的将padd函数柯里化-------------------------------------
func currying<A, B, C>(_ fn: @escaping (A, B) -> C) -> (B) -> (A) -> C {
    { b in
        { a in
            fn(a, b)
        }
    }
}
print(currying(padd)(5)(2)) //其实对照kadd2

//MARK: - ------------------------------------利用泛型,快速的将add2函数柯里化-------------------------------------
//如果有三个参数,同理
func currying1<A, B, C, D>(_ fn: @escaping (A, B, C) -> D) -> (C) -> (B) -> (A) -> D {
    {
        c in {
            b in {
                a in fn(a, b, c)
            }
        }
    }
}

print(currying1(add2)(10)(20)(30))

