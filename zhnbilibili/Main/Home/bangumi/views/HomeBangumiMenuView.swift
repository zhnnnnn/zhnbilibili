//
//  HomeBangumiMenuView.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/3.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class HomeBangumiMenuView: UIView {

    // MARK: - 属性
    @IBOutlet weak var goAfterBangumiButton: UIButton!
    @IBOutlet weak var fangsonbiaoButton: UIButton!
    @IBOutlet weak var typeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        goAfterBangumiButton.imageView?.contentMode = .scaleAspectFill
        fangsonbiaoButton.imageView?.contentMode = .scaleAspectFill
        typeButton.imageView?.contentMode = .scaleAspectFill
        self.backgroundColor = kHomeBackColor
    }
}

// MARK: - 公共方法
extension HomeBangumiMenuView {
    class func instanceView() -> HomeBangumiMenuView {
        return Bundle.main.loadNibNamed("HomeBangumiMenuView", owner: self, options: nil)?.first as! HomeBangumiMenuView
    }
}
