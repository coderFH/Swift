//: [上一页](@previous)

import Foundation

//: #### 1.可选项
var name : String? = "Jack"
name = nil

var age : Int? //默认就是nil
age = 10
age = nil

var array = [1,15,40,29]
func get(_ index : Int) ->Int? {
    if index < 0 || index >= array.count {
        return nil
    }
    return array[index]
}
print(get(1))
print(get(-1))
print(get(4))

//: #### 2.强制解包
//: - 如果要从可选项中取出被包装的数据,需要使用感叹号!,进行强制解包
var age1 : Int? = 10
var ageInt : Int = age1!
ageInt += 10

//: - 如果对值为nil的可选项进行强制解包,将会产生运行时错误
var age2 : Int?
//age2!   //会崩溃

//: #### 3.判断可选项是否包含值
let number = Int("123")
if number != nil {
    print("字符串转换整数成功:\(number!)")
} else {
    print("字符串转换整数失败")
}

//: #### 4.可选项绑定
if let number1 = Int("123") {
    print("字符串转换整数成功:\(number1)")
} else {
    print("字符串转换整数失败")
}

enum Season : Int {
    case spring = 1,summer,autumn,winter
}
if let season = Season(rawValue: 6) {
    switch season {
    case .spring:
        print("the season is spring")
    default:
        print("the season is other")
    }
} else {
    print("no such season")
}

//: - 等价写法
if let first = Int("4") {
    if let second = Int("42") {
        if first < second && second < 100 {
            print("\(first) < \(second) < 100")
        }
    }
}

if let first1 = Int("4"),
    let second1 = Int("42"),
    first1 < second1 && second1 < 100 {
        print("\(first1) < \(second1) < 100")
    }


//: #### 5.while循环中使用可选绑定
var strs = ["10","20","30","abc","-10"]
var index = 0
var sum = 0
//for i in strs {
//    guard let tmp = Int(i) else {
//        break
//    }
//    sum += tmp
//}
while let num = Int(strs[index]),num > 0 {
    sum += num
    index += 1
}
print(sum)

//: #### 6.空合运算符
let a : Int? = 1
let b : Int? = 2
let c = a ?? b

let d : Int? = nil
let e : Int? = 2
let f = d ?? e

let g : Int? = nil
let h : Int? = nil
let i = g ?? h

let aa : Int? = 1
let bb : Int? = 2
let cc =  aa ?? bb

let dd : Int? = nil
let ee : Int? = 2
let ff = dd ?? ee

//: - 如果不使用??运算符
let a1 : Int? = nil
let b1 : Int = 2
let c1 : Int
if let tmp = a1 {
    c1 = tmp
} else {
    c1 = b1
}

//: #### 7.多个??一起使用
let a2 : Int? = 1
let b2 : Int? = 2
let c2 = a2 ?? b2 ?? 3

let a3 : Int? = nil
let b3 : Int? = 2
let c3 = a3 ?? b3 ?? 3

let a4 : Int? = nil
let b4 : Int? = nil
let c4 = a4 ?? b4 ?? 3

//: #### 8.跟if let配合使用
let a5 : Int? = nil
let b5 : Int? = 2
if let c5 = a5 ?? b5 {
    print(c5)
}

//: #### 9.if语句实现登录
func login(_ info : [String : String]) {
    let username : String
    if let tmp = info["username"] {
        username = tmp
    } else {
        print("请输入用户名")
        return
    }
    let password : String
    if let tmp = info["password"] {
        password = tmp;
    } else {
        print("请输入密码")
        return
    }
    print("用户名:\(username),密码\(password)")
}
login(["username": "jack","password": "123456"])
login(["password": "123456"])
login(["username": "jack"])

//: #### 10.guard语句
func login1(_ info : [String : String]) {
    guard let username = info["username"] else {
        print("请输入用户名")
        return
    }
    guard let password = info["password"] else {
        print("请输入密码")
        return
    }
     print("用户名:\(username),密码\(password)")
}
login1(["username": "jack","password": "123456"])
login1(["password": "123456"])
login1(["username": "jack"])

//: #### 11.隐式解包
//: - 隐式解包要慎用,必须保证不为nil,如果一旦为nil,就会崩溃
let num1 : Int! = 10
let num2 : Int = num1
if num1 != nil {
    print(num1 + 6)
}
if let num3 = num1 {
    print(num3)
}

//: #### 12.字符串插值
//: - 可选项在字符串插值或者直接打印时，编译器会发出警告
var age5 : Int? = 10
print("My age is \(age5)")

//: - 至少有3种方法消除警告
print("My age is \(age5!)")
print("My age is \(String(describing: age5))")
print("My age is \(age5 ?? 0)")


//: #### 13.多重可选项
var num11: Int? = 10
var num22: Int?? = num11
var num33: Int?? = 10
print(num22 == num33) // true


var number1: Int? = nil
var number2: Int?? = number1
var number3: Int?? = nil
print(number2 == number3) // false
(number2 ?? 1) ?? 2 // 2
(number3 ?? 1) ?? 2 // 1

//: [下一页](@next)
