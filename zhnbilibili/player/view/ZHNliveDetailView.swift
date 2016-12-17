//
//  ZHNliveDetailView.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/12.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class ZHNliveDetailView: UIView {

    var detailModel: homeLiveDetailModel? {
        didSet{
            // 1. 标题
            titlelabel.text = detailModel?.title
            // 2. 名字
            nameLabel.text = detailModel?.owner?.name
            // 3. 头像
            guard let face = detailModel?.owner?.face else {return}
            guard let url = URL(string: face) else {return}
            headImageView.sd_setImage(with: url)
            // 4. 观看人数
            guard let online = detailModel?.online else {return}
            var coutStr = "\(online)"
            if online > 10000 {
                coutStr = "\(online/10000)万人"
            }
            watchCountLabel.text = coutStr
        }
    }
    
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var watchCountLabel: UILabel!
    @IBOutlet weak var heightConstrant: NSLayoutConstraint!
    
    class func instanceView() -> ZHNliveDetailView {
        let view = Bundle.main.loadNibNamed("ZHNliveDetailView", owner: self, options: nil)?.last as! ZHNliveDetailView
        view.heightConstrant.constant = 0.5
        return view
    }
}
