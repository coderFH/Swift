//
//  Item.swift
//  qiushibaike
//
//  Created by wangfh on 2020/4/22.
//  Copyright © 2020 wangfh. All rights reserved.
//

import KakaJSON

struct Item: Convertible {
    let content : String = ""
    let publishedAt : Int = 0
    let user : User? = nil
    
    func kj_modelKey(from property: Property) -> ModelPropertyKey {
//        return property.name.kk.underlineCased()
        if property.name == "publishedAt" { return "published_at" }
        return property.name
    }

}
