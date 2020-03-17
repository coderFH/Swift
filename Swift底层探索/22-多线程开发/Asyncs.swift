//
//  Asyncs.swift
//  22-多线程开发
//
//  Created by wangfh on 2020/3/17.
//  Copyright © 2020 wangfh. All rights reserved.
//

import UIKit

public typealias Task = () -> Void

struct Asyncs {
    
    /// 传入一个任务,在子线程中执行
    /// - Parameter task: 要执行的任务
    public static func async(_ task: @escaping Task) {
        _async(task)
    }
    
    /// 传入一个任务,在子线程执行后,回到主线程执行传进来的任务
    /// - Parameters:
    ///   - task: 在子线程执行的任务
    ///   - mainTask: 在主线程执行的任务
    public static func async(_ task: @escaping Task, mainTask: @escaping Task) {
        _async(task, mainTask)
    }

    private static func _async(_ task: @escaping Task,
                               _ mainTask: Task? = nil) {
        let item = DispatchWorkItem(block: task)
        DispatchQueue.global().async(execute: item)
        if let main = mainTask {
            item.notify(queue: DispatchQueue.main, execute: main)
        }
    }
    
    @discardableResult
    public static func asyncDelay(_ seconds: Double,
                                     _ task: @escaping Task) -> DispatchWorkItem {
        return _asyncDelay(seconds, task)
    }
    
    @discardableResult
    public static func asyncDelay(_ seconds: Double,
                                     _ task: @escaping Task,
                                 _ mainTask: @escaping Task) -> DispatchWorkItem {
        return _asyncDelay(seconds, task, mainTask)
    }
    
    private static func _asyncDelay(_ seconds: Double,
                                       _ task: @escaping Task,
                                   _ mainTask: Task? = nil) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: task)
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + seconds, execute: item)
        if let main = mainTask {
            item.notify(queue: DispatchQueue.main, execute: main)
        }
        return item
    }
}
