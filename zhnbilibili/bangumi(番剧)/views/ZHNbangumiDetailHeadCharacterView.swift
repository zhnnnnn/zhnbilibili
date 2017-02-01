//
//  ZHNbangumiDetailHeadCharacterView.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/20.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit

class ZHNbangumiDetailHeadCharacterView: UIView {

    // MARK - 属性
    var headDetailModel: ZHNbangumiDetailModel? {
        didSet {
            if let title = headDetailModel?.bangumi_title {
                titleLabel.text = title
            }
            if let play = headDetailModel?.play_count {
                playLabel.text = play.returnShowString()
            }
            if let subscribe = headDetailModel?.favorites {
                subscribeLabel.text = subscribe.returnShowString()  
            }
            if let weakDay = headDetailModel?.weekday {
                updateTimeLabel.text = "连载中,每周\(weakDay.CHNweekDay())更新"
            }
        }
    }
    
    // MARK - 控件
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playLabel: UILabel!
    @IBOutlet weak var subscribeLabel: UILabel!
    @IBOutlet weak var updateTimeLabel: UILabel!
    
    
    class func instanceView() -> ZHNbangumiDetailHeadCharacterView {
        let bundName = String(describing: self)
        return Bundle.main.loadNibNamed(bundName, owner: nil, options: nil)?.last as! ZHNbangumiDetailHeadCharacterView
    }
}
