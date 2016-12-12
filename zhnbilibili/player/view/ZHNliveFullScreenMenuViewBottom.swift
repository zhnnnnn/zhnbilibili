//
//  ZHNliveFullScreenMenuViewBottom.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/11.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class ZHNliveFullScreenMenuViewBottom: UIView {
    
    weak var supView: ZHNlivePlayFullScreenMenuView?
    
    class func instanceView() -> ZHNliveFullScreenMenuViewBottom {
        return Bundle.main.loadNibNamed("ZHNliveFullScreenMenuViewBottom", owner: self, options: nil)?.last as! ZHNliveFullScreenMenuViewBottom
    }
    
}

//======================================================================
// MARK:- target action
//======================================================================
extension ZHNliveFullScreenMenuViewBottom {

    @IBAction func sendDanmuAction(_ sender: AnyObject) {
    }
    
    @IBAction func hotWordsAction(_ sender: AnyObject) {
    }
    
    
    @IBAction func sendGiftAction(_ sender: AnyObject) {
    }
    
    @IBAction func blockGiftAction(_ sender: AnyObject) {
    }
    
    @IBAction func loginAction(_ sender: AnyObject) {
    }
    
    
    @IBAction func dealDanmuAction(_ sender: AnyObject) {
    }
    
    @IBAction func resignFullScreenAction(_ sender: AnyObject) {
        guard let delegate = supView?.delegate else {return}
        guard let method = delegate.backAction else {return}
        method()
    }
}

