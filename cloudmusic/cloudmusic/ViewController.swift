//
//  ViewController.swift
//  cloudmusic
//
//  Created by Ne on 2020/5/30.
//  Copyright © 2020 Ne. All rights reserved.
//

import UIKit
import Flutter
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let flutterEngine = (UIApplication.shared.delegate as! AppDelegate).flutterEngine
        let flutterVC = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        navigationController?.pushViewController(flutterVC, animated: true)
    }


}

