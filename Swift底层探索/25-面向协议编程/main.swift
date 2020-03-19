//
//  main.swift
//  25-面向协议编程
//
//  Created by wangfh on 2020/3/19.
//  Copyright © 2020 wangfh. All rights reserved.
//

import Foundation

//================================ 现在有个一个需求,需要计算字符串中有多少的数字

func numberCount(_ str : String) -> Int {
//    var count = 0
//    for c in str {
//        if ("0"..."9").contains(c) { //这么写不优雅,可以用where过滤
//             count += 1
//        }
//    }
    
//    for c in str where ("0"..."9").contains(c) {
//        count += 1
//    }
    
    //或者使用高阶函数
//    var temStr : String?
//    temStr = str.filter { (c) -> Bool in
//        ("0"..."9").contains(c)
//    }
    
    var temStr : String?
    temStr = str.filter { ("0"..."9").contains($0) }
    return temStr?.count ?? 0
}
print(numberCount("123kkkfff333"))

//================================ 以上的做法是一个全局函数,调用起来还是很不方便的,我们可以给String扩展一个
extension String {
    func numberCount() -> Int {
        var temStr : String?
        temStr = self.filter { ("0"..."9").contains($0) }
        return temStr?.count ?? 0
    }
}
print("123kkkfff333".numberCount())

//甚至可以扩展成计算属性
extension String {
    var numberCount1 : Int {
        var temStr : String?
        temStr = self.filter { ("0"..."9").contains($0) }
        return temStr?.count ?? 0
    }
}
print("123kkkfff333".numberCount1)
print("123".numberCount1)

//================================ 但是上边的方法这么做,还是不太好,因为直接给字符串添加了属性,有可能会和系统的重名,导致冲突,我们可以封装到一个包里
struct FH {
    var string : String
    init(_ string : String) {
        self.string = string;
    }
    
    var numberCount1 : Int {
        var temStr : String?
        temStr = string.filter { ("0"..."9").contains($0) }
        return temStr?.count ?? 0
    }
}
extension String {
    var fh : FH { return FH(self)}
}
print("123kkkfff333".fh.numberCount1)

//================================ 但是上边的FH结构体非常的不够通用,就写死了必须是字符串,如果我想给数组也扩展这样的一个方法,甚至是对象呢,可以用泛型解决
class  Person {}

struct FH1<Base> {
    var base : Base
    init(_ base : Base) {
        self.base = base
    }
}

extension String {
    var fh1 : FH1<String> { FH1(self) } //实例属性
    static var fh1 : FH1<String>.Type {FH1<String>.self}
}

extension Person {
    var fh1 : FH1<Person> { FH1(self) }
}

//扩展FH1
/*
 这里Base == String只是对Sting扩展了一个numberCount属性,但如果我想让NSString 和 NSMutableString也有这个属性
 我们这里的Base == String 可以改成 Base : ExpressibleByStringLiteral 因为 Strnig,NSString,NSMutableString都遵守这个协议
 然后104行的base换成(base as! String)
 这样就可以了
 (前提是NSString现有fh1这个前缀属性,可以让NSSrting遵守下边FHCompatible的协议就可以)
 */
extension FH1 where Base == String { //当Base是String类型的,注意是结构体,所以用 ==.  如果用: 就相当于Base要遵守这个String协议,或者继承String,很明显不对
    var numberCount : Int {
        var temStr : String?
        temStr = base.filter { ("0"..."9").contains($0) }
        return temStr?.count ?? 0
    }
    
    static func test() {}
}
print("333222".fh1.numberCount) //调用对象属性
String.fh1.test() //调用类型方法

extension FH1 where Base : Person { //这里用 : 是因为他希望Person的子类都受关联,如果是== 就表示只能有Person有
    func run() {}
}

var person = Person()
person.fh1.run()


//================================ 以上的代码有一个缺点就是,我们每扩充一个类型,比如Dog,或者任意其他的 都需要写 添加一个 fh1的实例属性和类型属性(eg86行到93行),如果扩充的一多,代码就会很冗余,此时就可以使用面向协议
protocol FHCompatible {} //协议只能声明东西,你要想扩充,就使用扩展
extension FHCompatible {
    var fh1 : FH1<Self> {
        set {}
        get { FH1(self) }
    } //实例属性
    static var fh1 : FH1<Self>.Type {
        set {}
        get { FH1<Self>.self }
    }
}

//然后一个新的Dog类,只需要遵守这个协议
class Dog {}
extension Dog :FHCompatible {} //让Dog拥有fh1的前缀属性

extension FH1 where Base : Dog {
    func test() {}
    static func test1() {}
    mutating func test2() {} //我这个方法可能会修改实例属性,所以120行设计的时候,最好加上set 使其可读可选,更具通用性
}
var dog = Dog()
dog.fh1.test()
Dog.fh1.test1()
dog.fh1.test2()

//MARK: - ------------------------------------利用协议实现类型判断-------------------------------------
//判断是不是数组
func isArray(_ value: Any) -> Bool {
    value is [Any]
}
print(isArray([1, 2] ))
print(isArray(["1", 2] ))
print(isArray(NSArray() as Array))
print(isArray(NSMutableArray() as Array))

print("-----------")

//判断是不是数组类型,可以巧妙的借助协议去实现
protocol ArrayType {}
extension Array: ArrayType {}
extension NSArray: ArrayType {}

func isArrayType(_ type: Any.Type) -> Bool {
    type is ArrayType.Type
}
print(isArrayType([Int].self))
print(isArrayType([Any].self))
print(isArrayType(NSArray.self))
print(isArrayType(NSMutableArray.self))



