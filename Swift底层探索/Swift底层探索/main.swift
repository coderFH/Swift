//
//  main.swift
//  Swift底层探索
//
//  Created by wangfh on 2019/6/28.
//  Copyright © 2019 wangfh. All rights reserved.
//

import Foundation
/*
 1.看地址前,先明白大小端模式
 
 大端模式：低位字节存在高地址上，高位字节存在低地址上
 小端模式：高位字节存在高地址上，低位字节存在低地址上
 
 低地址 --------> 高地址
 0x0A 0x0B 0xo0C 0x0D
 */

//MARK: ----------枚举(原始值)----------
//MARK: -----第一种情况-----
enum TestEnum {
    case test0,test1,test2,test3,test4,test5
}

//程序是如何知道使用的具体是哪个枚举值?

//查看内存存储的值是: 05 (16进制的05, 即二进制的 0000 0101)
var t5 = TestEnum.test5
print(Mems.ptr(ofVal: &t5));//使用这个方法去打印内存地址

//查看内存存储的值是: 04
var t4 = TestEnum.test4
print(Mems.ptr(ofVal: &t4));

//查看内存存储的值是:03
var t3 = TestEnum.test3
print(Mems.ptr(ofVal: &t3)); //使用这个方法去打印内存地址

//查看内存存储的值是:02
var t2 = TestEnum.test2
print(Mems.ptr(ofVal: &t2));

//查看内存存储的值是:01
var t1 = TestEnum.test1
print(Mems.ptr(ofVal: &t1));

//查看内存存储的值是:00
var t0 = TestEnum.test0
print(Mems.ptr(ofVal: &t0));

print(MemoryLayout<TestEnum>.size) //1
print(MemoryLayout<TestEnum>.stride)// 1
print(MemoryLayout<TestEnum>.alignment) //1
/*
 所以根据上边t1-t6内存中的值就可以知道,对于原始值型的枚举变量,内存会用一个字节去存储这个枚举值,就能够区分用户到底具体使用的是哪个值
 因为这一个字节有8位,存储的范围从00000000 - 11111111  十进制的范围就是0 - 255
 通过MemoryLayout也能验证枚举实际占用1个字节,应该分配1,对齐是1
*/

//MARK: -----第一种情况-----
// 如果我枚举中只有一个值,又会怎样?
enum TestEnum1 {
    case test0
}
var tt0 = TestEnum1.test0
print(Mems.ptr(ofVal: &tt0))

print(MemoryLayout<TestEnum1>.size) //0
print(MemoryLayout<TestEnum1>.stride)// 1
print(MemoryLayout<TestEnum1>.alignment) //1
/*
 当我们使用打印出来的内存地址去看存储的值时,发现并取不到任何东西,原因就是你这个枚举只有一个值,程序就没必要去开辟一个字节的内存去存储
 通过MemoryLayout.size = 0 也能看出 并没有占用内存, 而MemoryLayout.stride = 1 是应该分配1个字节,但实际可以不分配
 */

//MARK: ----------枚举(关联值)----------
enum TestEnum2 {
    case test1(Int, Int, Int)
    case test2(Int, Int)
    case test3(Int)
    case test4(Bool)
    case test5
}

//由于高位字节存储在高地址的原因

//内存是如何知道使用的具体是哪个枚举值?
//t3读取到内存地址的值是:      02  由于高位字节存储在高地址的原因
//所以先取高字节的值 即结果就是 20
//var t3 = TestEnum.test3
print(Mems.ptr(ofVal: &t3)); //使用这个方法去打印内存地址
