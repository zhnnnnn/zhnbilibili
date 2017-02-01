//
//  ZHNbangumiDetailHeadMenuView.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/20.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit

class ZHNbangumiDetailHeadMenuView: UIView {
    
    @IBOutlet weak var shareIconImageView: UIImageView!
    @IBOutlet weak var faverateIconImageView: UIImageView!
    @IBOutlet weak var cacheIocnImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shareIconImageView.image = UIImage(named: "iphonevideoinfo_share")?.withTintColor(kshareColor)
        faverateIconImageView.image = UIImage(named: "bangumi_like")
        cacheIocnImageView.image = UIImage(named: "iphonevideoinfo_dl")?.withTintColor(kdownloadColor)
    }
    
    class func instanceView() -> ZHNbangumiDetailHeadMenuView {
        let bundName = String(describing: self)
        return Bundle.main.loadNibNamed(bundName, owner: nil, options: nil)?.last as! ZHNbangumiDetailHeadMenuView
    }
}
