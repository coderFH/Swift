//
//  main.swift
//  枚举在内存中是怎么存的
//
//  Created by wangfh on 2019/6/28.
//  Copyright © 2019 wangfh. All rights reserved.
//

import Foundation
/*
 寄存器
 rax 64   r开头  全是x64的寄存器 64位  8个字节
 eax 32   e开头  全是x86的寄存机 32位  4个字节
 ax bx cx... -> 16
 ah bh ch al bl cl ... -> 8

 1.看地址前,先明白大小端模式
 
 大端模式：低位字节存在高地址上，高位字节存在低地址上
 小端模式：高位字节存在高地址上，低位字节存在低地址上
 
 低地址 --------> 高地址
 0x0A 0x0B 0xo0C 0x0D
 */

//MARK: ----------------------------------------1.枚举(原始值)----------------------------------------
//MARK: --------------------第一种情况--------------------
print("------------------------------------1.枚举(原始值)---------------------------------")
print("-----第一种情况-----")
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

//MARK: --------------------第二种情况--------------------
print("-----第二种情况-----")
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

//MARK: --------------------第三种情况--------------------
// 如果我枚举中只有一个值,又会怎样?
print("-----第三种情况-----")
enum TestEnum2 : String { // 或者写Int
    case test0 = "ceshi0",test1 = "ceshi1"
}

//根据内存地址可以看出 00
var tt1 = TestEnum2.test0
print(Mems.ptr(ofVal: &tt1))

//根据内存地址可以看出 01
var tt2 = TestEnum2.test1
print(Mems.ptr(ofVal: &tt2))

print(MemoryLayout<TestEnum2>.size) //1
print(MemoryLayout<TestEnum2>.stride)// 1
print(MemoryLayout<TestEnum2>.alignment) //1
/*
 当我们使用打印出来的内存地址可以看出,不管原始值型的枚举是Int类型还是String类型,枚举本身只占一个字节
 只是他们关联的值比如ceshi0,ceshi1并不会存在这个枚举中,不会改变改枚举变量的内存地址
 */

//MARK: ----------------------------------------2.枚举(关联值)----------------------------------------
print("------------------------------------2.枚举(关联值)---------------------------------")
//MARK: --------------------第一种情况--------------------
print("-----第一种情况-----")
enum TestEnum3 {
    case test0(Int, Int, Int)
    case test1(Int, Int)
    case test2(Int)
    case test3(Bool)
    case test4
}

/*
 由于高位字节存储在高地址的原因
 打印内存地址中的值可以看到:
 03 00 00 00 00 00 00 00
 04 00 00 00 00 00 00 00
 05 00 00 00 00 00 00 00
 00
 00 00 00 00 00 00 00
 因为是小端存储,实际的值是(由于高位字节存储在高地址的原因,所以先取高字节的值 即结果就是)
 00 00 00 00 00 00 00 03
 00 00 00 00 00 00 00 04
 00 00 00 00 00 00 00 05
 00 00 00 00 00 00 00 00
 可以看到,改枚举值前24个字节用于存储 3,4,5 第25个字节用于存储枚举的标识
 */
var e0 = TestEnum3.test0(3, 4, 5)
print(Mems.ptr(ofVal: &e0))

/*
 内存地址打印出是
 06 00 00 00 00 00 00 06
 07 00 00 00 00 00 00 07
 00 00 00 00 00 00 00 00
 01 00 00 00 00 00 00 00  这里这个01 就是区分哪个枚举值的,就是他的成员值
 直接换算成内存地址为:
 00 00 00 00 00 00 00 06
 00 00 00 00 00 00 00 07
 00 00 00 00 00 00 00 00
 00 00 00 00 00 00 00 01
 */
var e1 = TestEnum3.test1(6, 7)
print(Mems.ptr(ofVal: &e1))

/*
 直接换算成内存地址为:
 00 00 00 00 00 00 00 08
 00 00 00 00 00 00 00 00
 00 00 00 00 00 00 00 00
 00 00 00 00 00 00 00 02
 */
var e2 = TestEnum3.test2(8)
print(Mems.ptr(ofVal: &e2))

/*
 直接换算成内存地址为:
 00 00 00 00 00 00 00 01
 00 00 00 00 00 00 00 00
 00 00 00 00 00 00 00 00
 00 00 00 00 00 00 00 03
 */
var e3 = TestEnum3.test3(true)
print(Mems.ptr(ofVal: &e3))

/*
 直接换算成内存地址为:
 00 00 00 00 00 00 00 00
 00 00 00 00 00 00 00 00
 00 00 00 00 00 00 00 00
 00 00 00 00 00 00 00 04
 */
var e4 = TestEnum3.test4
print(Mems.ptr(ofVal: &e4))

print(MemoryLayout<TestEnum3>.size) //25    实际占用是24+1 因为3个整形占8个字节,1个字节用于标识是哪个枚举值 即 3 * 8 + 1 = 25
print(MemoryLayout<TestEnum3>.stride)// 32  因为对齐参数是8 应该分配32个字节
print(MemoryLayout<TestEnum3>.alignment) //8 对齐参数是8
/*
 通过以上的内存地址不难看出,关联型的枚举,会把关联值存到自己的枚举变量中,这就是与原始值枚举的区别
 */

//MARK: --------------------第2种情况--------------------
print("-----第二种情况-----")
enum TestEnum4 {
    case test0(Int, Int, Int)
}
/*
 直接换算成内存地址为:
 00 00 00 00 00 00 00 0A
 00 00 00 00 00 00 00 0A
 00 00 00 00 00 00 00 0A
 */
var ee0 = TestEnum4.test0(10, 10, 10)
print(Mems.ptr(ofVal: &ee0))
print(Mems.memStr(ofVal: &ee0)) //通过这个方法,能直接打印内存存储的值,不用找到内存地址,再再xcode中查看了,省的麻烦

print(MemoryLayout<TestEnum4>.size) //24    因为只有一个枚举值,没必要花一个字节去存储标识,直接用24个字节存关联值就行了
print(MemoryLayout<TestEnum4>.stride)// 24  因为对齐参数是8 应该分配24个字节
print(MemoryLayout<TestEnum4>.alignment) //8 对齐参数是8

