//
//  main.swift
//  08-初始化
//
//  Created by Ne on 2020/2/29.
//  Copyright © 2020 wangfh. All rights reserved.
//

import Foundation

//MARK: ------------------------------------- 1.初始化器 -------------------------------------
//=============================1. 类,结构体,枚举都可以定义初始化器
// 类定义初始化器
class Size {
    init(age: Int) {
        
    }
}
var s = Size(age: 10)

//枚举自带有一个rawValue的初始化器
enum Season : Int {
    case spring
}
var e = Season(rawValue: 0)

//结构体的初始化器
//所有的结构体都有一个编译器自动生成的初始化器(initializer，初始化方法、构造器、构造方法)
struct Person {
    var age: Int;
}
var p = Person(age: 20);

//=============================2. 类 有两种初始化器:指定初始化器,便捷初始化器

/*为什么苹果需要搞便捷初始化和指定初始化器。
比如现在在一个指定初始化器里边儿做了一系列的操作，比如对属性进行初始化，添加视图等等。
这个时候定义了一个便捷初始化器,它调用这个指定初始化器的时候，保证了用户不管是使用哪个初始化器创建的对,
最终都会走到那个指定的初始化器里边儿去执行那些操作,这样做的话是更安全的。
 */
//每个类至少有一个指定初始化器,指定初始化器是类的主要初始化器
class Size1 {
    var width : Int = 0
    var height : Int = 0
//    init(width :Int,height :Int) {
//        self.width = width
//        self.height = height
//    }
    
    //如果把上边的指定初始化器改成便捷初始化器,那么编译器还是会生成一个默认的指定初始化器init();
    convenience init(width :Int,height :Int) {
        //便捷初始化器,必须从相同的类里调用另一个初始化器(可以是指定初始化器,也可以是便捷初始化器),
        //如果调用的是便捷初始化器,那么那个便捷初始化器必须调用一个指定初始化器
        //其实就是  便捷->便捷->便捷 我不管你中间调用几次便捷 最后的一个便捷一定要调用到 指定初始化器
        self.init();
        self.width = width
        self.height = height
    }

}
//var s = Size1(); //如果不手动的写指定初始化器,编译器会默认的生一个指定初始化器
//如果我们写了一个指定初始化器,例如上边39行的init(width :Int,height :Int) 那编译器就不用帮我们自动生成init()的指定初始化器了
var s1 = Size1(width: 20, height: 10);

//指定初始化器必须从他的直系父类调用指定初始化器(存在继承的情况下)
class Person1 {
    var age : Int
    init(age : Int) {
        self.age = age;
    }
    convenience init() {
        self.init(age : 0)
    }
}

//指定初始化器 只能 调动 父类的 指定初始化器
//便捷初始化器 只能调用 本类的 便捷初始化器 或者 指定初始化器
class Student : Person1 {
    var score : Int
    init(age : Int,score : Int) {
//        self.age = age; //这么写错误,因为指定初始化器必须从他的直系父类调用指定初始化器
        self.score = score;
        super.init(age: age); //必须保证调用父类初始化器之前,其所在类定义的所有存储属性都要初始化完成
        
        //....后边放个性化的定制,比如调用函数,修改属性等,因为这是由swift两段式初始化的特性所决定的
    }
    
//MARK: ------------------------------------- 2.重写初始化器 -------------------------------------
    //把父类的指定初始化器 重写成 指定初始化器
//    override init(age: Int) {
//        self.score = 0
//        super.init(age: age);
//    }
    
    //把父类的指定初始化器 重写成 便捷初始化器
    override convenience init(age: Int) {
        self.init(age : age,score : 0)
    }
    
    //如果子类写了一个匹配父类的便捷初始化器 eg:person的convenience init(),不用加override
    //不论我子类将父类的init重写成指定初始化器还是便捷初始化器,都不用写override
    //因为父类的便捷初始化器永远不会通过子类直接调用(正常来讲,重写是可以通过super.xxxx,调用父类方法的)
    //因此,严格来说,子类无法重写父类的便捷初始化器
//    init() {
//        self.score = 0;
//        super.init(age: 0);
//    }
    
    convenience init() {
        self.init(age : 0,score : 0)
    }
}

var s2 = Student(age: 20, score: 90);

//MARK: ------------------------------------- 3.自动继承  -------------------------------------
//1.如果子类没有自定义任何指定初始化器 ,他会自动继承父类的所有的指定初始化器
class Animal {
    var age : Int
    var name : String
    init(age : Int,name : String) {
        self.age = age
        self.name = name
    }
    init() {
        self.age = 0
        self.name = ""
    }
    convenience init(age : Int) {
        self.init(age : age,name : "")
    }
    convenience init(name : String) {
        self.init(age : 0,name : name)
    }
}

class Dog : Animal {
    
}

//当我们打(括号时,可以看到,虽然Dog没有写任何的初始化器,但它继承了父类的四个初始化方法
var d = Dog();

//2.如果子类提供了父类所有指定初始化器的实现(要么通过继承,要么重写)
// 子类自动继承所有的父类便捷初始化器
class Animal1 {
    var age : Int
    var name : String
    init(age : Int,name : String) {
        self.age = age
        self.name = name
    }
    init() {
        self.age = 0
        self.name = ""
    }
    convenience init(age : Int) {
        self.init(age : age,name : "")
    }
    convenience init(name : String) {
        self.init(age : 0,name : name)
    }
}

class Dog1 : Animal1 {
    override init(age: Int, name: String) {
        super.init(age: age, name: name);
    }
    
    override init() {
        super.init();
    }
}

//根据上边代码可见,子类重写了父类的指定初始化器(既子类提供了父类所有指定初始化器的实现)
//所以子类继承了父类的便捷初始化器
var d1 = Dog1();

//把父类的指定初始化器冲写成便捷初始化器也是一样的
//既 子类一便捷初始化器的形式重写父类的指定初始化器
class Animal2 {
    var age : Int
    var name : String
    init(age : Int,name : String) {
        self.age = age
        self.name = name
    }
    init() {
        self.age = 0
        self.name = ""
    }
    convenience init(age : Int) {
        self.init(age : age,name : "")
    }
    convenience init(name : String) {
        self.init(age : 0,name : name)
    }
}

class Dog2 : Animal2 {
    init(no : Int) {
        super.init()
    }
    override convenience init(age: Int, name: String) {
        self.init(no:0)
    }
    override convenience init() {
        self.init(no:0)
    }
}
var d2 = Dog2()

//就算子类添加了更多的便捷初始化器,这些规则仍然适用
class Animal3 {
    var age : Int
    var name : String
    init(age : Int,name : String) {
        self.age = age
        self.name = name
    }
    init() {
        self.age = 0
        self.name = ""
    }
    convenience init(age : Int) {
        self.init(age : age,name : "")
    }
    convenience init(name : String) {
        self.init(age : 0,name : name)
    }
}

class Dog3 : Animal3 {
    convenience init(no: Int) {
        self.init()
    }
}
var d3 = Dog3()

//MARK: ------------------------------------- 4.@required  -------------------------------------
//用required修饰的指定初始化器,表明其所有子类必须实现该初始化器(通过继承或者重写实现)
//如果子类重写了required初始化器,也必须加上required,不用加override
class Person2 {
    required init() {}
    init(age : Int) {}
}

class Student2: Person2 {
    init(no : Int) {
        super.init(age: 0)
    }
    required init() {
        super.init()
    }
}
var s3 = Student2()

//MARK: ------------------------------------- 5.可失败初始化器 -------------------------------------
//可失败初始化器可以调用非可失败初始化器,非可失败初始化器调用可失败初始化器需要进行解包
class Person3 {
    var name : String
    init?(name : String) {
        if name.isEmpty {
            return nil
        }
        self.name = name
    }
    convenience init() {
        self.init(name : "")!//非可失败初始化器调用可失败初始化器需要进行解包
    }
}

var p3 = Person3(name: "")
print(p3)

var p33 = Person3(name: "Jack")
print(p33)

//可以用一个 非可失败初始化器 重写一个 可失败初始化器, 但反过来不行
class Person4 {
    var name : String
    init?(name : String) {
        if name.isEmpty {
            return nil
        }
        self.name = name
    }
    convenience init?() {
        self.init(name : "")
        self.name = "Jack"
        //.....
    }
}

class Student4: Person4 {
    override init(name: String) {
        super.init(name: name)!
    }
}

//MARK: ------------------------------------- 6.反初始化器(deinit) -------------------------------------
//当类的实例对象被释放内存时,就会调用实例对象的deinit方法
/*
 deinit不接受任何参数,不能写小括号,不能自行调用
 父类的deinit能被子类继承
 子类的deinit实现执行完毕后会调用父类的deinit
 */
class Person5 {
    deinit {
        print("Person对象销毁了")
    }
}

class Student5: Person5 {
    deinit {
        print("Student对象销毁了")
    }
}

func test() {
    var _ = Student5()
}

print("1");
test()
print("2");


