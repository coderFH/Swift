//
//  TabBarViewController.swift
//  qiushibaike
//
//  Created by wangfh on 2020/4/20.
//  Copyright © 2020 wangfh. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setValue(TabBar(), forKeyPath: "tabBar")
        tabBar.barTintColor = UIColor.white
        
        addChild("糗事", "icon_main", "icon_main_active", HomeViewController.self)
        addChild("动态", "main_tab_qbfriends", "main_tab_qbfriends_active", TrendViewController.self)
        addChild("直播", "main_tab_live", "main_tab_live_active", LiveViewController.self)
    }
    
    func addChild(_ title : String,
                  _ image : String,
                  _ selectedImage : String,
                  _ type : UIViewController.Type) {
        let child = UINavigationController(rootViewController: type.init())
        child.title = title;
        child.tabBarItem.image = UIImage(named: image)
        child.tabBarItem.selectedImage = UIImage(named: selectedImage)
        child.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.black], for: .selected);
        addChild(child);
    }
}
