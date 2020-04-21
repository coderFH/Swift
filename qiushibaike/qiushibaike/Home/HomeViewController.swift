//
//  HomeViewController.swift
//  qiushibaike
//
//  Created by wangfh on 2020/4/20.
//  Copyright © 2020 wangfh. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {
    static let itemCellId = "item"
    lazy var items = [Any]()
    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        return UITableView();
    }();

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "糗事百科"
        tableView.frame = self.view.bounds
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: Self.itemCellId);
        view.addSubview(tableView)
    }
    
    
     func loadNewData() {
        AF.request(<#T##convertible: URLConvertible##URLConvertible#>, method: <#T##HTTPMethod#>, parameters: <#T##Encodable?#>, encoder: <#T##ParameterEncoder#>, headers: <#T##HTTPHeaders?#>, interceptor: <#T##RequestInterceptor?#>, requestModifier: <#T##Session.RequestModifier?##Session.RequestModifier?##(inout URLRequest) throws -> Void#>)
        request(API.imgrank, parameters: ["page": 1]).responseJSON {
            [weak self] response in
            guard let dict = response.result.value else { return }
            let jsons = JSON(dict)["items"].arrayObject
            guard let models = modelArray(from: jsons, Item.self) else { return }
            
            self?.items.removeAll()
            self?.items.append(contentsOf: models)
            
            self?.tableView.reloadData()
            self?.tableView.mj_header.endRefreshing()
            
            self?.page = 1
        }
//        requ
//        request(API.imgrank, parameters: ["page": 1]).responseJSON {
//           [weak self] response in
//           guard let dict = response.result.value else { return }
//           let jsons = JSON(dict)["items"].arrayObject
//           guard let models = modelArray(from: jsons, Item.self) else { return }
//
//           self?.items.removeAll()
//           self?.items.append(contentsOf: models)
//
//           self?.tableView.reloadData()
//           self?.tableView.mj_header.endRefreshing()
//
//           self?.page = 1
//        }
       }
   
    

}


extension HomeViewController : UITableViewDelegate {
    
}

extension HomeViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100//items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : HomeTableViewCell = tableView.dequeueReusableCell(withIdentifier: Self.itemCellId, for: indexPath) as! HomeTableViewCell;
        cell.titleLbl.text = "123"
        cell.contentLbl.text = "qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq"
        return cell;
    }
}
