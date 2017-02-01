//
//  ZHNzoneItemHeadr.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/10.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit

enum zoneItemHeadType {
    case recommend
    case new
}

class ZHNzoneItemHeadr: UIView {
    
    var type: zoneItemHeadType = zoneItemHeadType.recommend {
        didSet{
            if type == .new {
                iconImageView.image = UIImage(named: "home_new_region")
                nameLabel.text = "最新投稿"
            }
            
            if type == .recommend {
                iconImageView.image = UIImage(named: "home_recommend_icon_0")
                nameLabel.text = "热门推荐"
            }
        }
    }
    
    // MARK - 懒加载控件
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(named: "home_recommend_icon_0")
        iconImageView.contentMode = UIViewContentMode.scaleAspectFill
        return iconImageView
    }()
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "热门推荐"
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        return nameLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(iconImageView)
        self.addSubview(nameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(15)
            make.size.equalTo(CGSize(width: 20, height: 15))
        }
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(iconImageView.snp.right).offset(10)
        }
    }
    
    
}
