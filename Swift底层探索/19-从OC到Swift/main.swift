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

