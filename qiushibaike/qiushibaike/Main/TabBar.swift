//
//  TabBar.swift
//  qiushibaike
//
//  Created by wangfh on 2020/4/20.
//  Copyright © 2020 wangfh. All rights reserved.
//

import UIKit

class TabBar: UITabBar {
    override func layoutSubviews() {
        super.layoutSubviews()
        for button in subviews where button is UIControl  {
            var frame = button.frame
            frame.origin.y = -2
            button.frame = frame
        }
    }

}
