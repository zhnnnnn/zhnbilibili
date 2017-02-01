//
//  ZHNnormalFullScreenTop.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/16.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class ZHNnormalFullScreenTop: UIView {

    @IBOutlet weak var dangumiButton: UIButton!
    // 返回的action
    var backAction: (()->Void)?
    // 标题
    @IBOutlet weak var titleLabel: UILabel!
    // 退出全屏
    @IBAction func backAction(_ sender: AnyObject) {
        guard let action = backAction else {return}
        action()
    }
    
    class func instanceView() -> ZHNnormalFullScreenTop {
        return Bundle.main.loadNibNamed("ZHNnormalFullScreenTop", owner: self, options: nil)?.last as! ZHNnormalFullScreenTop
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.ZHNcolor(red: 0, green: 0, blue: 0, alpha: 0.7)
        dangumiButton.setImage(UIImage(named: "player_danmaku_setup")?.withTintColor(UIColor.white), for: .normal)
    }
}
