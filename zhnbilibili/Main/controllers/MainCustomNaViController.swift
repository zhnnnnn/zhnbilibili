//
//  MainCustomNaViController.swift
//  zhnbilibili
//
//  Created by zhn on 16/11/21.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class MainCustomNaViController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isNavigationBarHidden = true
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if childViewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}
