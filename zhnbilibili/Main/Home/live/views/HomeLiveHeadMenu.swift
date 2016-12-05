//
//  HomeLiveHeadMenu.swift
//  zhnbilibili
//
//  Created by zhn on 16/11/30.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class HomeLiveHeadMenu: UIView {

    class func instanceView() -> HomeLiveHeadMenu {
        return Bundle.main.loadNibNamed("HomeLiveHeadMenu", owner: self, options: nil)?.last as! HomeLiveHeadMenu
    }

    @IBAction func menuChoseAction(_ sender: AnyObject) {
        println(sender.tag)
    }
}
