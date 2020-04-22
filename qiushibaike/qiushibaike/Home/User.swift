//
//  User.swift
//  qiushibaike
//
//  Created by wangfh on 2020/4/22.
//  Copyright © 2020 wangfh. All rights reserved.
//

import KakaJSON

struct User: Convertible {
    let thumb: String = ""
    let medium: String = ""
    let age: Int = 0
    let id: String = ""
    let login: String = ""
    
    func kk_modelKey(from property: Property) -> ModelPropertyKey {
        if property.name == "name" { return "login" }
        return property.name
    }
}
