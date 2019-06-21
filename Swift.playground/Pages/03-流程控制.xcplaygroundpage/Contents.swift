//: [上一页](@previous)

import Foundation

//: #### 1.if-else
let age = 4
if age >= 2 {
    print("get married")
} else if age >= 18 {
    print("being a adult")
} else {
    print("just a child")
}

//: #### 2.while
var num = 5
while num > 0 {
    print("num is \(num)")
    num -= 1
}

var num1 = -1
repeat  {
    print("num is \(num)")
} while num > 0

//: #### 3.for
//: - 闭区间运算符:a...b a<=取值<=b
let names = ["Anna","Alex","Brian","Jack"];
for i in 0...3 {
    print(names[i])
}

//i默认是let,有需要时可以声明为var
for var i in 1...3 {
    i += 5;
    print(i)
}

//: - 半开区间运算符:a..<b a<=取值<b
for i in 1..<5 {
    print(i)
}

//: #### 4.for-区间运算符用在数组上
for name in names[0...3] {
    print(name)
}
//: - 单侧区间:让区间朝一个方向尽可能的远
for name in names[2...] {
    print(name)
} //Brian Jack

for name in names[...2] {
    print(name)
} //Anna Alex Brian

for name in names[..<2] {
    print(name)
} //Anna  Alex

let range = ...5
range.contains(7)
range.contains(4)
range.contains(-3)

//: #### 5.区间类型
let range1 : ClosedRange<Int> = 1...3
let range2 : Range<Int> = 1..<3
let range3 : PartialRangeThrough<Int> = ...5

//: - 字符,字符串也能使用区间运算符,但默认不能用在for-inh中
let stringRang1 = "cc"..."ff"
stringRang1.contains("cb")
stringRang1.contains("dz")
stringRang1.contains("fg")

let stringRang2 = "a"..."f"
stringRang2.contains("d")
stringRang2.contains("h")

//: - \0 到 ~ 囊括了所有可能要用到的ASCII字符
let characterRange : ClosedRange<Character> = "\0"..."~"
characterRange.contains("G")

//: #### 6.带间隔的区间值
let hours = 11
let hourInterval = 2
//从4开始,累计2,不超过11
for i in stride(from: 4, to: hours, by: hourInterval) {
    print(i)
} //4 6 8 10

//: #### 7.switch
var number = 1
switch number {
case 1:
    print("number is 1")
    break
case 2:
    print("number is 2")
    break
default:
    print("number is other")
    break
}

//: #### 8.fallthrough
//: - fallthrough 可以实现贯穿效果
var number1 = 1
switch number1 {
case 1:
    print("number is 1")
    fallthrough
case 2:
    print("number is 2")
default:
    print("number is other")
}

//: #### 8.switch注意点
//: -如果能保证已处理所有情况,也可以不使用default
enum Answer {case right,wrong}
let answer = Answer.right

switch answer {
case .right:
    print("right")
default:
    print("wrong")
}

//: #### 10.复合条件
//: - switch 也支持Character,String类型
let string = "jack"
switch string {
case "jack":
    fallthrough
case "rose":
    print("Right person")
default:
    break
}

let character : Character = "a"
switch character {
case "a","A":
    print("the letter A")
default:
    print("Not the Letter A")
}

switch string {
case "jack","rose":
    print("Right person")
default:
    break
}

//: #### 11.区间e匹配,元组匹配
let count = 62
switch count {
case 0:
    print("none")
case 1..<5:
    print("a fex")
case 5..<12:
    print("several")
case 12..<100:
    print("dozens of")
case 100..<1000:
    print("hundreds of")
default:
    print("many")
}

let point = (1,1)
switch point {
case (0,0):
    print("the origin")
case (_,0):
    print("on the x-axis")
case (0,_):
    print("on the y-axis")
case(-2...2,-2...2):
    print("inside the box")
default:
    print("outside of the box")
}

//: #### 12.值绑定
let point1 = (2,0)
switch point1 {
case (let x,0):
    print("value of \(x)")
case(0,let y):
    print("value of \(y)")
case let(x,y):
    print("somewhere else at(\(x),\(y))")
}

//: #### 13.where
let point2 = (1,-1)
switch point2 {
case let(x,y) where x == y:
    print("x == y")
case let(x,y) where x == -y:
    print("x == -y")
case let(x,y):
    print("(\(x),\(y)) is just some arbitrary point")
}

var numnbers = [10,20,-10,-20,30,-30]
var sum = 0
for num in numnbers where num > 0 {
    sum += num
}
print(sum)

//: #### 14.标签语句
outer : for i in 1...4 {
    for k in 1...4 {
        if k == 3 {
            continue outer
        }
        if 1 == 3 {
            break outer
        }
        print(i,k)
    }
}
//: [下一页](@next)
