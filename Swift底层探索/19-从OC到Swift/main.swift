//
//  main.swift
//  19-从OC到Swift
//
//  Created by wangfh on 2020/3/15.
//  Copyright © 2020 wangfh. All rights reserved.
//

import Foundation

#warning("我是一个警告")

//MARK: - ------------------------------------条件编译-------------------------------------
//ppt第四页如果是在Active...那里自定义宏 需要加空格 如果是在other...那里添加自定义的宏 前边需要加-D

//MARK: - ------------------------------------打印-------------------------------------
func log<T>(_ msg: T,
            file: NSString = #file, //不传的话就用默认参数,#file是哪个文件
            line: Int = #line, //行号
            fn: String = #function)  { //哪个函数
    #if DEBUG //然后只在debug模式下生效
        let prefix = "\(file.lastPathComponent)_\(line)_\(fn):"
        print(prefix, msg)
    #endif
}

//MARK: - ------------------------------------系统版本检测-------------------------------------
 if #available(iOS 10, macOS 10.12, *) { //不是条件编译哦
    // 对于iOS平台，只在iOS10及以上版本执行
    // 对于macOS平台，只在macOS 10.12及以上版本执行
    // 最后的*表示在其他所有平台都执行
}

//MARK: - ------------------------------------API可用性说明-------------------------------------
@available(iOS 10, macOS 10.15, *) //Person类只在iOS10上有效
class Person {}

struct Student {
    @available(*, unavailable, renamed: "study")
    func study_() {}
    func study() {}
    
    @available(iOS, deprecated: 11) //表示run方法在iOS11已经过期
    @available(macOS, deprecated: 10.12)
    func run() {}
    
    func test() -> Any {
        //比如一个函数你现在先不想写实现,但它又有返回值,为了保证编译通过,可以先用fatalError()占位
        fatalError()
    }
}

var s = Student()
s.run()

//s.study_()不能调用,因为已经改名为study

//更多用法参考:https://docs.swift.org/swift-book/ReferenceManual/Attributes.html

//MARK: - ------------------------------------String-------------------------------------
//Swift的字符串类型String，跟OC的NSString，在API设计上还是有较大差异
// 空字符串
var emptyStr1 = ""
var emptyStr2 = String()

var str: String = "1"

// 拼接，jack_rose
str.append("_2")

// 重载运算符 +
str = str + "_3"

// 重载运算符 +=
str += "_4"

// \()插值
str = "\(str)_5"

// 长度，9，1_2_3_4_5
print(str.count,str)

var str1 = "123456"
print(str1.hasPrefix("123")) // true
print(str1.hasSuffix("456")) // true

//MARK: - ------------------------------------String的插入和删除-------------------------------------
var str2 = "1_2"
print("--------",str2.startIndex,str2.endIndex); //startIndex是从1这个位置开始,也就是1 endIndex是2后边那个位置,所以打印是个很大的数字

// 1_2_
str2.insert("_", at: str2.endIndex) //在2的后边插入一个_

// 1_2_3_4
str2.insert(contentsOf: "3_4", at: str2.endIndex)//在_的后边插入3_4

// 1666_2_3_4
str2.insert(contentsOf: "666", at: str2.index(after: str2.startIndex)) //startIndex是1那个位置,加了个after就是在1之后 所以是1666_2_3_4

// 1666_2_3_8884
str2.insert(contentsOf: "888", at: str2.index(before: str2.endIndex))//endIndex是最后即4的后边那个位置,加了before就是再4的前边那个位置,所以结果就是1666_2_3_8884

// 1666hello_2_3_8884
str2.insert(contentsOf: "hello", at: str2.index(str2.startIndex, offsetBy: 4)) //从开始位置偏移4个位置


// 666hello_2_3_8884
str2.remove(at: str2.firstIndex(of: "1")!) //移除最开始的字符

// hello_2_3_8884
str2.removeAll { $0 == "6" } //移除所有6的字符

var range = str2.index(str2.endIndex, offsetBy: -4)..<str2.index(before: str2.endIndex) // hello_2_3_4
str2.removeSubrange(range) //从3_后边的这个位置到4前边这个位置的三个8移除掉

//MARK: - ------------------------------------Substring-------------------------------------
//String可以通过下标、 prefix、 suffix等截取子串，子串类型不是String，而是Substring
var str3 = "1_2_3_4_5"

// 1_2
var substr1 = str3.prefix(3)
// 4_5
var substr2 = str3.suffix(3)

// 1_2
var range3 = str3.startIndex..<str3.index(str3.startIndex, offsetBy: 3)
var substr3 = str3[range3]

// 最初的String，1_2_3_4_5
print("substr3.base",substr3.base)
print("str3--",str3);//可以看到str3本身是没有改变的

// Substring -> String
var str4 = String(substr3)

//Substring和它的base，共享字符串数据
//Substring发生修改 或者 转为String时，会分配新的内存存储字符串数据

//MARK: - ------------------------------------String 与 Character-------------------------------------
for c in "jack" { // c是Character类型
    print(c)
}

var str5 = "jack"
// c是Character类型
var c = str5[str5.startIndex]

//MARK: - ------------------------------------多行String-------------------------------------
let str6 = """
1
    "2"
3
    '4'
"""
print(str6)

// 如果要显示3引号，至少转义1个引号
let str7 = """
Escaping the first quote \"""
Escaping two quotes \"\""
Escaping all three quotes \"\"\"
"""
print(str7)


// 缩进以结尾的3引号为对齐线
let str8 = """
        1
            2
    3
        4
    """
print(str8)


// 以下2个字符串是等价的
let str9 = "These are the same."
let str10 = """
These are the same.
"""
print(str9)
print(str10)


//String 与 NSString 之间可以随时随地桥接转换
//如果你觉得String的API过于复杂难用，可以考虑将String转为NSString
var str11: String = "jack"
var str12: NSString = "rose"

var str13 = str11 as NSString
var str14 = str12 as String

str11.append("123")
print(str11,str13) //转化后,你修改原来的字符串,不会影响转换后的字符串

var str15 = str13.substring(with: NSRange(location: 0, length: 2))
print(str15)//ja
/*
 比较字符串内容是否等价
     String使用 == 运算符
     NSString使用isEqual方法，也可以使用 == 运算符(本质还是调用了isEqual方法)
 */

//MARK: - ------------------------------------Swift、OC桥接转换表-------------------------------------
/*
 这里的不能转换是指不能通过as进行桥接转换,如果你硬要转,可以通过以下方式重新创建一个全新的NSMutableString
 var str334 = "123"
 var str2ss = NSMutableString(string: str334)
 */
/*
 String ⇌ NSString
 String ← NSMutableString
 
 Array⇌NSArray
 Array←NSMutableArray
 
 Dictionary⇌NSDictionary
 Dictionary←NSMutableDictionary
 
 Set⇌NSSet
 Set←NSMutableSet
*/

//MARK: - ------------------------------------只能被class继承的协议-------------------------------------

protocol Runnable1: AnyObject {} //可以被类,结构体,枚举遵守
protocol Runnable2: class {} //class的写法相当于AnyClass 只能被类遵守
@objc protocol Runnable3 {} // 使用objc和class或者AnyClass的效果是一样的,同时被@objc修饰的协议，还可以暴露给OC去遵守实现

//可以通过@objc 定义可选协议，这种协议只能被class 遵守
@objc protocol Runnable {
    func run1()
    @objc optional func run2() //可以使用这种方式,实现协议的可选
    func run3()
    
}
class Dog: Runnable {
    func run3() { print("Dog run3") }
    func run1() { print("Dog run1") }
}
var d = Dog()
d.run1() // Dog run1
d.run3() // Dog run3

//MARK: - ------------------------------------dynamic-------------------------------------
//被 @objc dynamic 修饰的内容会具有动态性，比如调用方法会走runtime那一套流程
//可见20-Swift调用OC项目里80行的注释
 class Dog1: NSObject {
    @objc dynamic func test1() {}
    func test2() {}
}
var d1 = Dog1()
d1.test1() //他会走objc_msgsend的那套流程
d1.test2()  //他依然是虚表的那一套方式

//MARK: - ------------------------------------KVC\KVO-------------------------------------
//Swift 支持 KVC \ KVO 的条件
//  属性所在的类、监听器最终继承自 NSObject
//  用 @objc dynamic 修饰对应的属性
class Person1: NSObject {
    @objc dynamic var age: Int = 0
    var observer: Observer = Observer()
    override init() {
        super.init()
        self.addObserver(observer,
                         forKeyPath: "age",
                         options: .new,
                         context: nil)
    }
    deinit {
        self.removeObserver(observer, forKeyPath: "age")
    }
}

class Observer: NSObject {
    override func observeValue(forKeyPath keyPath: String?,
                                    of object: Any?,
                                    change: [NSKeyValueChangeKey : Any]?,
                                    context: UnsafeMutableRawPointer?) {
        print("observeValue", change?[.newKey] as Any)
    }
}

var p = Person1()
// observeValue Optional(20)
p.age = 20

// observeValue Optional(25)
p.setValue(25, forKey: "age")

//MARK: - ------------------------------------block方式的KVO-------------------------------------
class Person2: NSObject {
    @objc dynamic var age: Int = 0
    var observation: NSKeyValueObservation?
    override init() {
        super.init()
        observation = observe(\Person2.age, options: .new) {
            (person, change) in
            print(change.newValue as Any)
        }
    }
}
var p2 = Person2()
// Optional(20)
p2.age = 20

// Optional(25)
p2.setValue(25, forKey: "age")

//MARK: - ------------------------------------关联对象(Associated Object)-------------------------------------
// 在Swift中，class依然可以使用关联对象
//默认情况，extension不可以增加存储属性
//借助关联对象，可以实现类似extension为class增加存储属性的效果

class Person3 {}
extension Person3 {
    //类里的类型存储属性,就类似于全局变量,内存地址保证是唯一的,在关联属性中可以用作key
    //为什么要使用Void?
    //因为在关联属性中,我们只是需要用一个唯一的地址值当key,去存储添加的值,所以保证唯一就行,
    //假如我们这是使用Int类型,会多占字节导致不必要的浪费,所以使用Void?类型就可以,这里也可以使用bool类型,只占一个字节,Void?其实也是只占一个字节的
    private static var AGE_KEY: Void?
    var age: Int {
        get {
            //这里的Self其实就是Person3,这里用到了AGE_KEY是类型属性,所以只能用类去调用,跟Person3.AGE_KEY是一个效果
            (objc_getAssociatedObject(self, &Self.AGE_KEY) as? Int) ?? 0
        }
        set {
            objc_setAssociatedObject(self, &Self.AGE_KEY,newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
}

var p3 = Person3()
print(p3.age) // 0
p3.age = 10
print(p3.age) // 10




 
