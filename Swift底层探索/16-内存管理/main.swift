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
    deinit { print("Person1 deinit") }
}
func test() {
    let p1 = Person1() //p1里有个fn对闭包进行着强引用
    //这样写会产生循环引用
//    p1.fn = {
//        p1.run() //闭包对外部的p1有个强引用
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
        [weak wp = p1,unowned up = p1, a = 10 + 20] in //捕获列表声明中可以进行重命名,甚至还可以写其他变量
        wp?.run()
        up.run()
    }
    
    p1.fn!() //调用闭包
}

test()

//如果想在定义闭包属性的同时引用self，这个闭包必须是lazy的(因为在实例初始化完毕之后才能引用self)
 class Person2 {
    //左边的闭包fn内部如果用到了实例成员(属性、方法)
    //编译器会强制要求明确写出self,以提醒你是否注意到了循环引用的问题
    lazy var fn: (() -> ()) = {
        [weak self] in
        /*
         为什么加上lazy后,就不报错了?
         因为self只有在实例初始化完成之后才能使用,swfit的两段式初始化,先要保证所有的存储属性都有值,即我们先把这个闭包表达式赋值给fn变量,使其有值,才能使用self
         而不加lazy,你初始化就完成不了,如何使用self,使用lazy就是延迟加载
         */
        self?.run() //这里其实如果不写self,直接run,其实也是self在调用
    }
    func run() { print("Person2 run") }
    deinit { print("Person2 deinit") }
}

func test2() {
    let pp = Person2()
    pp.fn() //假如我们不调用fn,Person2也是能销毁的,因为你压根就没用到fn,他也就不会加载,也就不会存在所谓的循环引用问题,因为它压根就没有
}
test2()

let pp = Person2()

//如果lazy属性是闭包调用的结果，那么不用考虑循环引用的问题(因为闭包调用后，闭包的生命周期就结束了)
 class Person3 {
    var age: Int = 0
    lazy var getAge: Int = {
        self.age //这里我虽然对age有个强引用,但我是立即执行的,闭包执行完,生命周期就结束了,注意理解  如果lazy属性是闭包调用的结果 这几个字,他跟上边fn的区别就是,fn是对闭包有个强引用,并没有立即执行,至于你什么时候执行,我是不知道的,所以会循环引用!而p3.getAge在调用的时候,马上执行闭包,把结果赋值给getAge属性,闭包的生命周期就结束了,所以没有造成循环引用,看两个属性的类型也能知道区别
    }()
    deinit { print("Person3 deinit") }
}
func test3() {
    let p3 = Person3()
    print(p3.getAge)
}
test3()

//MARK: - ------------------------------------@escaping -------------------------------------
//非逃逸闭包、逃逸闭包，一般都是当做参数传递给函数
//非逃逸闭包:闭包调用发生在函数结束前，闭包调用在函数作用域内
//逃逸闭包:闭包有可能在函数结束后调用，闭包调用逃离了函数的作用域，需要通过@escaping声明

import Dispatch
typealias Fn = () -> ()

// fn是非逃逸闭包
func test1(_ fn: Fn) {
    fn()
}

// fn是逃逸闭包
var gFn: Fn?
func test2(_ fn: @escaping Fn) {
    gFn = fn //把fn赋值给了全局的gFn,gFn的调用在哪不清楚,但肯定不在test2的作用域内,所以是逃逸闭包
}

 // fn是逃逸闭包
func test3(_ fn: @escaping Fn) {//因为开启了异步,fn的执行不在test3函数作用域内了
    DispatchQueue.global().async {
        fn()
    }
}

class Person4 {
    var fn: Fn
    // fn是逃逸闭包
    init(fn: @escaping Fn) {
        self.fn = fn
    }
    func run() {
        // DispatchQueue.global().async也是一个逃逸闭包
        // 它用到了实例成员(属性、方法)，编译器会强制要求明确写出self
        DispatchQueue.global().async {
            self.fn()
        }
    }
}

//MARK: - ------------------------------------逃逸闭包的注意点 -------------------------------------
//逃逸闭包不可以捕获inout参数
func other1(_ fn: Fn) { fn() }

func other2(_ fn: @escaping Fn) { fn() } //其实fn不算是逃逸闭包,但是我们可以强制声明成逃逸闭包

func test4(value: inout Int) {
    other1 { //other1 接受一个无参数无返回值的闭包,这么写就是尾随闭包
        value += 1
        print(value)
    }
}
var a = 10
test4(value: &a);

func test5(value: inout Int) {
//    other2 { // 由此可见逃逸闭包不可以捕获inout参数,因为你是逃逸闭包,就会不确定在什么时候调用,当你调用的时候,value 可能已经释放了, 不安全
//        value += 1
//        print(value)
//    }
}

//func test6(value: inout Int) -> Fn {
//    func plus() { value += 1 }
//    // error: 逃逸闭包不能捕获inout参数
//    return plus //返回一个函数,本质上也是逃逸闭包,因为返回的这个函数,在哪调用也不确定
//}
