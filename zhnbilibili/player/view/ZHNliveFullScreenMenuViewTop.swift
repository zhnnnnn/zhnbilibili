//
//  ZHNliveFullScreenMenuViewTop.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/11.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class ZHNliveFullScreenMenuViewTop: UIView {

    weak var supView: ZHNlivePlayFullScreenMenuView?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var roomIDlabel: UILabel!
    @IBOutlet weak var watchIngCountLabel: UILabel!
    
    class func instanceView() -> ZHNliveFullScreenMenuViewTop {
        return Bundle.main.loadNibNamed("ZHNliveFullScreenMenuViewTop", owner: self, options: nil)?.first as! ZHNliveFullScreenMenuViewTop
    }
    
    @IBAction func backAction(_ sender: AnyObject) {
        guard let delegate = supView?.delegate else {return}
        guard let method = delegate.backAction else {return}
        method()
    }
    @IBAction func moreAction(_ sender: AnyObject) {
        
    }
}
