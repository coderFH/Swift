//
//  ViewController.swift
//  21-资源管理
//
//  Created by wangfh on 2020/3/17.
//  Copyright © 2020 wangfh. All rights reserved.
//

import UIKit

//MARK: - ------------------------------------第一种思路需要添加的枚举-------------------------------------
//这个时候我们可以用一下方式去解决,定义一个枚举,然后对image,btn,等扩展一些方法
enum R {
    enum string: String {
        case add = "添加"
    }
    enum image: String { //原始值,如果没有后边的=某个值,默认值就是"logo"
        case logo
    }
    enum segue: String {
        case login_main //默认值就是"login_main"
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: - ------------------------------------资源名管理的第一种思路-------------------------------------
        //平时我们用到图片,设置名称一般都是字符串,如果图片更换名称,我们可能需要各处到处改,这个时候我们可以定义枚举12行
        let _ = UIImage(named: "logo")
        let btn = UIButton(type: .custom)
        btn.setTitle("添加", for: .normal)
//        performSegue(withIdentifier: "login_main", sender: self)  //举例使用,会崩溃先注释

        //然后用下面这种方式就可以
        let _ = UIImage(R.image.logo)
        let btn1 = UIButton(type: .custom)
        btn1.setTitle(R.string.add, for: .normal)
//        performSegue(withIdentifier: R.segue.login_main, sender: self)
        
        //MARK: - ------------------------------------资源名管理的其他思路-------------------------------------
        //
        let _ = UIImage(named: "logo")
        let _ = UIFont(name: "Arial", size: 14)
       
        //优化后,可以用一下方式
        let _ = R1.image.logo
        let _ = R1.font.arial(14)
        
        enum R1 {
            enum image {
                static var logo = UIImage(named: "logo") }
            enum font {
                static func arial(_ size: CGFloat) -> UIFont? {
                    UIFont(name: "Arial", size: size)
                }
            }
        }
    }
}

//MARK: - ------------------------------------第一种思路需要添加的扩展-------------------------------------
extension UIImage {
    convenience init?(_ name: R.image) {
        self.init(named: name.rawValue)
    }
}

extension UIViewController {
    func performSegue(withIdentifier identifier: R.segue, sender: Any?) {
        performSegue(withIdentifier: identifier.rawValue, sender: sender)
    }
}

extension UIButton {
    func setTitle(_ title: R.string, for state: UIControl.State) {
        setTitle(title.rawValue, for: state)
    }
}


