//
//  ViewController.swift
//  22-多线程开发
//
//  Created by wangfh on 2020/3/17.
//  Copyright © 2020 wangfh. All rights reserved.
//

import UIKit

//写在全局的,默认也是lazy的,调用的时候才会执行
fileprivate let initTask2: Void = {
    print("initTask2---------")
}()

class ViewController: UIViewController {
    private var delayItem : DispatchWorkItem?

    static let initTask1: Void = {
        print("initTask1---------")
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: - ------------------------------------once-------------------------------------
        //dispatch_once在Swift中已被废弃，取而代之 //可以用类型属性或者全局变量\常量 //默认自带 lazy + dispatch_once 效果
        let _ = Self.initTask1
        let _ = Self.initTask1
        let _ = Self.initTask1
        let _ = initTask2
        let _ = initTask2
        let _ = initTask2 //访问多次也是打印一次

        //MARK: - ------------------------------------多线程操作相关-------------------------------------
        print("0",Thread.current);
        
        //1.开启异步
        DispatchQueue.global().async {
            print("1",Thread.current);
            //2.回到主线程
            DispatchQueue.main.async {
                print("2",Thread.current);
            }
        }
        
        //3.DispatchWorkItem的使用
        //a.创建DispatchWorkItem任务
        let item = DispatchWorkItem {
            print("3",Thread.current)
        }
        //b.将item仍入异步
        DispatchQueue.global().async(execute: item)
        //c.回到主线程
        item.notify(queue: DispatchQueue.main) {
            print("4",Thread.current)
        }
        
        //4.延迟操作
        let time = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: time) {
            print("5",Thread.current) //如果想在子线程执行,main换成global
        }
        
        //5.使用封装的DispatchWorkItem和延迟
        Asyncs.async {
            print("6",Thread.current)
        }
        
        Asyncs.async({
            print("7",Thread.current)
        }) {
            print("8",Thread.current)
        }
        
        //封装的延时返回是会返回一个DispatchWorkItem,这样我没在外界就可以随时取消延时任务
        delayItem = Asyncs.asyncDelay(3) {
            print("9",Thread.current)
        }
        
        Asyncs.asyncDelay(5, {
            print("10",Thread.current)
        }) {
            print("11",Thread.current)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delayItem?.cancel() //我可以拿到item,取消延时任务
    }
}

//MARK: - ------------------------------------加锁-------------------------------------
//定义一个缓存结构体
struct Cache {
    private static var data = [String : Any]()
    //使用信号量加锁
//    private static var lock = DispatchSemaphore(value: 1)
    
    //NSLock,这个锁如果set里递归调用的话,会产生死锁,所以用递归锁
//    private static var lock = NSLock()
    
    //递归锁
    private static var lock = NSRecursiveLock()
    
    
    public static func get(_ key : String) -> Any? {
        data[key]
    }
    public static func set(_ key : String,_ value : Any) {
        //信号量的方式加锁解锁
//        lock.wait()
//        defer {
//            lock.signal()
//        }
        
        //NSLock,NSRecursiveLock方式加锁解锁
        lock.lock()
        defer {
            lock.unlock()
        }
        
        //正常不加锁,多线程访问时会出问题
        data[key] = value
    }
}
