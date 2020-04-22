//
//  HomeViewController.swift
//  qiushibaike
//
//  Created by wangfh on 2020/4/20.
//  Copyright © 2020 wangfh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KakaJSON
import MJRefresh
import Kingfisher

class HomeViewController: UIViewController {
    static let itemCellId = "item"
    lazy var items = [Item]()
    var page = 0
    
    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 60
        
        tableView.rowHeight = UITableView.automaticDimension
       
        return UITableView();
    }();

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "糗事百科"
        
        tableView.frame = self.view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: Self.itemCellId);
        view.addSubview(tableView)
        
        let header = MJRefreshNormalHeader(refreshingBlock: self.loadNewData)
        header.beginRefreshing()
        tableView.mj_header = header
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: self.loadMoreData)
    }
    
    
    func loadNewData() {
        AF.request(API.imgrank, parameters: ["page": 1]).responseJSON {
            [weak self]response in
            switch response.result {
                case .success:
                    //如果不用SwiftyJSON,需要这么一步步的去写,会很麻烦
    //                    if let dict = response.value as? [String : Any] {
    //                    if let items = dict["items"] as? [[String : Any]] {
    //                            print(items);
    //                        }
    //                    }
                    //先判断有值
                    guard let dict = response.value else { return }
                    //然后使用SwiftyJSON去拿items
                    guard let jsons = JSON(dict)["items"].arrayObject else { return }
                    //字典转模型
                    let models = modelArray(from: jsons, Item.self)
                
                    print(models)
                    self?.items.removeAll()
                    self?.items.append(contentsOf: models)
                
                    self?.tableView.reloadData()
                    self?.tableView.mj_header?.endRefreshing()
                    self?.page = 1
                
                    break
                case .failure:
                    break
                    
            }
    }
}
    
    func loadMoreData() {
        AF.request(API.imgrank, parameters: ["page": 1]).responseJSON {
            [weak self] response in
            guard let dict = response.value else { return }
            guard let jsons = JSON(dict)["items"].arrayObject else { return }
            let models = modelArray(from: jsons, Item.self)
            
            self?.items.append(contentsOf: models)
            
            self?.tableView.reloadData()
            self?.tableView.mj_footer?.endRefreshing()
            
            self?.page += 1
        }
    }
}


extension HomeViewController : UITableViewDelegate {}

extension HomeViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.mj_footer?.isHidden = items.count == 0
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : HomeTableViewCell = tableView.dequeueReusableCell(withIdentifier: Self.itemCellId, for: indexPath) as! HomeTableViewCell;
        
        let item = items[indexPath.row]
        cell.titleLbl.text = String(item.user?.age ?? 0) + (item.user?.login ?? "")
        cell.contentLbl.text = item.content
            
        if let url = item.user?.thumb {
            cell.photoImage.kf.setImage(with: URL(string: url))
        }
        
        return cell;
    }
}
