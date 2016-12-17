//
//  ZHNnormalFullScreenTop.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/16.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class ZHNnormalFullScreenTop: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBAction func backAction(_ sender: AnyObject) {
    }
    
    class func instanceView() -> ZHNnormalFullScreenTop {
        return Bundle.main.loadNibNamed("ZHNnormalFullScreenTop", owner: self, options: nil)?.last as! ZHNnormalFullScreenTop
    }

}
