//
//  HomeTableViewCell.swift
//  qiushibaike
//
//  Created by wangfh on 2020/4/20.
//  Copyright © 2020 wangfh. All rights reserved.
//

import UIKit
import SnapKit

class HomeTableViewCell: UITableViewCell {
    lazy var photoImage : UIImageView = UIImageView()
    public lazy var titleLbl : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.red
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    public lazy var contentLbl : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.blue
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.photoImage.backgroundColor = UIColor.orange
        self.addSubview(self.photoImage)
        self.addSubview(self.titleLbl)
        self.addSubview(self.contentLbl)
        self.photoImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(10)
            make.size.equalTo(CGSize(width: 50, height: 50))
        };
        self.titleLbl.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo(self.photoImage.snp.right).offset(10)
        };
        
        self.contentLbl.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLbl.snp.bottom).offset(5)
            make.left.equalTo(self.titleLbl.snp.left)
            make.right.equalTo(-20)
            make.bottom.equalTo(self.snp.bottom).offset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
