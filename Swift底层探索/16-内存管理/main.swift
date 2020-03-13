//
//  main.swift
//  16-内存管理
//
//  Created by wangfh on 2020/3/13.
//  Copyright © 2020 wangfh. All rights reserved.
//

import Foundation

//MARK: - ------------------------------------内存管理 -------------------------------------
/*
 跟OC一样，Swift也是采取基于引用计数的ARC内存管理方案(针对堆空间)
 
 Swift的ARC中有3种引用
    强引用(strong reference):默认情况下，引用都是强引用
 
    弱引用(weak reference):通过weak定义弱引用
        必须是可选类型的var，因为实例销毁后，ARC会自动将弱引用设置为nil
        ARC自动给弱引用设置nil时，不会触发属性观察器
 
    无主引用(unowned reference):通过unowned定义无主引用
        不会产生强引用，实例销毁后仍然存储着实例的内存地址(类似于OC中的unsafe_unretained)
        试图在实例销毁后访问无主引用，会产生运行时错误(野指针)
        • Fatal error: Attempted to read an unowned reference but object 0x0 was already deallocated
 */
//MARK: - ------------------------------------weak、unowned的使用限制 -------------------------------------
//weak、unowned只能用在类实例上面

protocol Livable : AnyObject {} //遵守这个协议的必须是类
class Person {
    var age : Int
    var name : String
    init(age : Int, name : String) {
        self.age = age
        self.name = name
    }
    func run() {
        print("人跑")
    }
    deinit {
        print("销毁了")
    }
}

weak var p0: Person?
weak var p1: AnyObject?
weak var p2: Livable?

unowned var p10: Person?
unowned var p11: AnyObject?
unowned var p12: Livable?

//MARK: - ------------------------------------Autoreleasepool -------------------------------------
autoreleasepool {
    let p = Person(age: 20, name: "Jack")
    p.run()
}

//MARK: - ------------------------------------循环引用(Reference Cycle) -------------------------------------
/*
 weak、unowned 都能解决循环引用的问题，unowned 要比weak 少一些性能消耗
    在生命周期中可能会变为 nil 的使用 weak
    初始化赋值后再也不会变为 nil 的使用 unowned
 */

//MARK: - ------------------------------------闭包的循环引用 -------------------------------------
/*
 闭包表达式默认会对用到的外层对象产生额外的强引用(对外层对象进行了retain操作)
 */
//下面代码会产生循环引用，导致Person对象无法释放(看不到Person的deinit被调用)
//只所以会产生循环引用,就是Person1中有个属性引用着一个闭包,然后闭包在调用时又因为这Person1对象,就产生了循环引用
class Person1 {
    var fn: (() -> ())?
    func run() { print("run") }
    deinit { print("deinit") }
}
func test() {
    let p1 = Person1()
    //这样写会产生循环引用
//    p1.fn = {
//        p1.run()
//    }
    
   //在闭包表达式的捕获列表声明weak或unowned引用，解决循环引用问题
//    p1.fn = {
//        [weak p1] in
//        p1?.run()
//    }
//    p1.fn = {
//        [unowned p1] in
//        p1.run()
//    }
    
    p1.fn = {
        [weak wp = p1,unowned up = p1, a = 10 + 20] in //捕获列表声明中可以进行重命名,甚至还能进行计算
        wp?.run()
        up.run()
    }
}

test()
