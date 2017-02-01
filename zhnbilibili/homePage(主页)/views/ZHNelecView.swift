//
//  ZHNelecView.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/13.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit

class ZHNelecView: UIView {

    
    // MARK - 属性
    var elecList: [elecListetailModel]? {
        didSet {
            if isStatusSeted {return}
            isStatusSeted = true    
            guard let elecList = elecList else {return}
            let count = elecList.count > 4 ? 4 : elecList.count
            let y = bottomContainerView.zhnheight/2 - 20
            for i in 0..<count {
                // 1. 生成控件
                let headIconImageView = UIImageView()
                headIconImageView.backgroundColor = UIColor.red
                headIconImageView.contentMode = .scaleAspectFill
                headIconImageView.layer.cornerRadius = 10
                headIconImageView.clipsToBounds = true
                bottomContainerView.addSubview(headIconImageView)
                let x = (count - i)*18
                headIconImageView.frame = CGRect(x: CGFloat(x), y: y, width: 20, height: 20)
                // 2. 赋值图片
                let elec = elecList[count - i - 1]
                let url = URL(string: elec.avatar)
                headIconImageView.sd_setImage(with: url)
            }
            countLabel.attributedText = String.elecAttributes(count: elecList.count)
            let countX = 30 + count * 18
            countLabel.frame = CGRect(x: CGFloat(countX), y: y, width: 200, height: 20)
        }
    }

    var isStatusSeted = false

    @IBOutlet weak var bottomContainerView: UIView!
    
    // MARK - 懒加载控件
    lazy var noticeImageView: UIImageView = {
        let noticeImageView = UIImageView()
        noticeImageView.image = UIImage(named: "misc_battery_power_bg")
        noticeImageView.contentMode = .scaleAspectFill
        return noticeImageView
    }()
    
    lazy var countLabel: UILabel = {
        let countLabel = UILabel()
        countLabel.font = UIFont.systemFont(ofSize: 12)
        return countLabel
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(noticeImageView)
        bottomContainerView.addSubview(countLabel)
        self.backgroundColor = kHomeBackColor
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        noticeImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self).offset(40)
            make.size.equalTo(CGSize(width: 50, height: 70))
        }
    }

    class func instanceView() -> ZHNelecView {
        let classStr = String(describing: ZHNelecView.self)
        return Bundle.main.loadNibNamed(classStr, owner: self, options: nil)?.last as! ZHNelecView
    }
}
