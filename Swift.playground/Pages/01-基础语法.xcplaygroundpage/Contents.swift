import Foundation

//: #### 1. 常量
let age1 = 10

let age2 : Int
age2 = 20

func getAge() -> Int {
    return 30
}
let age3 = getAge()


//: - 错误的写法
/*
 let age  //常量这样写,必须指定类型
 age = 20
 */

//: - 常量.变量在初始化之前,都不能使用
 /*
 let age : Int
 var height : Int
 print(age)  //直接报错
 print(height) //直接报错
 */

//: #### 2. 标识符
let 🐂 = "牛"
let 🥛 = "milk"
print(🐂,🥛)

//: #### 3. 字面量
//: - 布尔
let bool = true
//: - 字符串
let string = "wfh"
//: - 字符(可存储ASCII字符,Unicode字符)
let character = "🐶"
//: - 整数
let intDec = 17 //十进制
let intBin = 0b10001 // 二进制
let intOct = 0o21 //八进制
let intHex = 0x11 //十六进制
//: - 浮点数
let doubleDec = 125.0 //十进制
let doubleHex1 = 0xFp2 //十六进制,意味着15*2^2,相当于十进制的60.0
let doubleHex2 = 0xFp-2 //十六进制,意味着15*2^-2 相当于十进制的3.75
//: - 数组
let array = [1,3,5,7,9]
//: - 字典
let dic = ["age":18,"height":175]

//: #### 4. 类型转换
//: - 整型转换
let int1 : UInt16 = 2_000 //swift可以添加下划线增加可读性
let int2 : UInt8  = 1
let int3 = int1 + UInt16(int2)

//: - 整数.浮点数转换
let int = 3
let double = 0.14159
let pi = Double(int) + double
let intPi = Int(pi)

//: - 字面量可以直接相加,因为字面量本身没有明确的类型
let result = 3 + 0.1415926


//: #### 5. 元组
let http404Error = (404,"Not Found")
print("The status code is \(http404Error.0)")

let (statusCode,statusMessage) = http404Error
print("The status code is \(statusCode)")

let (statusCode1,_) = http404Error

let http200Status = (statusCode:200,des:"OK")
print("code is \(http200Status.statusCode),des is \(http200Status.des)")

//: [上一页](@previous)

//: [下一页](@next)
