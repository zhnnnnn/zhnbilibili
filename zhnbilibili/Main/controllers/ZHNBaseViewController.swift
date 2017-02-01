//
//  ZHNBaseViewController.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/8.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit

let knavibarHeight: CGFloat = 50
class ZHNBaseViewController: UIViewController {

    lazy var naviBar: customNaviBar = {
        let naviBar = customNaviBar()
        return naviBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(naviBar)
        naviBar.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(view)
            make.height.equalTo(knavibarHeight)
        }
        naviBar.backArrowButton.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
    }
}

extension ZHNBaseViewController {
    @objc func popViewController() {
        _ = navigationController?.popViewController(animated: true)
    }
}
