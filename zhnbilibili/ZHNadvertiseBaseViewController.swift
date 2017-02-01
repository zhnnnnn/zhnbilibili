//
//  ZHNadvertiseBaseViewController.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/23.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit

class ZHNadvertiseBaseViewController: UIViewController {

    
    lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.text = "github: https://github.com/zhnnnnn\n\n邮箱: coderZhangHuiNan@163.com"
        return contentLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(50, 20, 100, 20))
        }
    }

}
