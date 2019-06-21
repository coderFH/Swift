//: [上一页](@previous)

import Foundation

//: #### 1. 函数的定义
//: - 有返回值
func pi() -> Double {
    return 3.14
}
func sum(v1 : Int,v2 : Int) -> Int {
    return v1 + v2
}

sum(v1:10,v2:20)
//: - 无返回值
func sayHello() -> Void {
    print("Hello")
}
func sayHello1() -> Void {
    print("Hello1")
}
func sayHello2() -> Void {
    print("Hello2")
}

//: #### 2. 隐式返回(Implicit Return)
func sum1(v1 : Int,v2 : Int) -> Int {
    return v1 + v2  //不return不行,不知道为啥
}
sum1(v1: 10, v2: 20)

//: #### 3. 返回元组:实现多返回值
func calculate(v1 : Int,v2 : Int) ->(sum : Int,difference : Int,average : Int) {
    let sum = v1 + v2
    return(sum,v1 - v2,sum >> 1)
}
let result = calculate(v1: 20, v2: 10)
result.sum
result.difference
result.average

//: #### 4. 函数的文档注释
/// 求和(概述)
///
/// 将2个整数相加
///
/// - Parameter v1:第一个整数
/// - Parameter v2:第二个整数
/// - Returns: 2个整数的和
///
/// - Note: 传入2个整数即可
///
func sum2(v1 : Int,v2 : Int) -> Int {
    return v1 + v2
}

//: #### 5. 参数标签(Argument Label)
//: - 可以修改参数标签
func goToWork(at time : String) {
    print("this time is \(time)")
}
goToWork(at: "08:00")
// go to work at 8:00

//: - 可以使用下划线_省略参数标签
func sum3(_ v1 : Int,_ v2 : Int) -> Int {
    return v1 + v2
}
sum3(10,20)

//: #### 6. 默认参数值(Default Parameter Value)
func check(name : String = "nobody",age : Int,job : String = "none") {
    print("name = \(name),age = \(age),job=\(job)")
}
check(name: "jack", age: 20, job: "Doctor")
check(name: "Rose", age: 18)
check(age: 15)

//: #### 7. 可变参数(Variadic Parameter)
func sum4(_ numbers : Int ...) -> Int {
    var total = 0
    for number in numbers {
        total += number
    }
    return total
}
sum4(10)
sum4(10,10)
sum4(10,10,10)
sum4(10,10,10,10)

//: - 一个函数最多只能有1个可变参数
//: - 紧跟在可变参数后面的参数不能省略参数标签
//参数string不能省略标签
func test(_ numbers : Int...,string : String,_ other : String) {
}
test(10,20,30, string: "jack", "rose")

//: #### 8. Swift自带的print函数
print(1,2,3,4,5,separator : "_",terminator:"*")

//: #### 9. 输入输出参数(In-Out Parameter)
//: - 可以用inout定义一个输入输出参数:可以在函数内部修改外部实参的值
func swapValues(_ v1 : inout Int,_ v2 : inout Int) {
    let tmp = v1
    v1 = v2
    v2 = tmp
}
var num1 = 10
var num2 = 20
swap(&num1, &num2)

//: #### 10.函数重载(Function Overload)
func sum5(v1 : Int,v2 : Int) -> Int {
    return v1 + v2
}

func sum5(v1 : Int,v2 : Int,v3 : Int) -> Int {
    return v1 + v2 + v3
}

func sum5(v1 : Int,v2 : Double) -> Double {
    return Double(v1) + v2
}

func sum5(v1 : Double,v2 : Int) -> Double {
    return v1 + Double(v2)
}
//参数标签不同
func sum5(_ v1 : Int, _ v2 : Int) -> Int {
    return v1 + v2
}

func sum5(a : Int,b : Int) -> Int {
    return a + b
}
//: #### 12.函数类型(Function Type)
func sum6(a : Int,b : Int) -> Int {
    return a + b
}
var fn : (Int,Int) -> Int = sum6
fn(2,3)

//: #### 13.函数类型作为函数参数
func sum7(v1 : Int,v2 : Int) -> Int {
    return v1 + v2
}

func diff(v1 : Int,v2 : Int) -> Int {
    return v1 - v2
}

func printResult(_ mathFn : (Int,Int) -> Int,_ a : Int,_ b : Int) {
    print("restult:\(mathFn(a,b))")
}
printResult(sum7, 5, 7)
printResult(diff, 5, 2)

//: #### 14.函数类型作为函数返回值
func next(_ input : Int) -> Int {
    return input + 1
}

func previous(_ input : Int) -> Int {
    return input - 1;
}

func forward(_ forward : Bool) -> (Int) -> Int {
    return forward ? next : previous
}
forward(true)(3)
forward(false)(3)

//: #### 15.typealias
typealias IntFn = (Int,Int) -> Int
func diff1(v1 : Int,v2 : Int) -> Int {
    return v1 - v2
}

let fn1 : IntFn = diff1;
fn1(20,10)

//: #### 16.嵌套函数(Nested Function)
func foward(_ forward : Bool) -> (Int) -> Int {
    func nex(_ input : Int) -> Int {
        return input + 1
    }
    func pre(_ input : Int) -> Int {
        return input - 1
    }
    return forward ? next : pre
}

forward(true)(3)
forward(false)(3)

//: [下一页](@next)
