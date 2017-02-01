//
//  ZHNhomePageRowHeadView.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/13.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit

class ZHNhomePageRowHeadView: UIView {

    // MARK - 懒加载控件
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        return nameLabel
    }()

    lazy var coutLabel: UILabel = {
        let countLabel = UILabel()
        countLabel.textColor = UIColor.lightGray
        countLabel.font = UIFont.systemFont(ofSize: 13)
        return countLabel
    }()
    
    lazy var rightNoticeLabel: UILabel = {
        let rightNoticeLabel = UILabel()
        rightNoticeLabel.textColor = UIColor.lightGray
        rightNoticeLabel.font = UIFont.systemFont(ofSize: 13)
        rightNoticeLabel.text = "进去看看!"
        return rightNoticeLabel
    }()
    
    lazy var rightNoticeImageView: UIImageView = {
        let rightNoticeImageView = UIImageView()
        rightNoticeImageView.image = UIImage(named: "common_rightArrowShadow")
        return rightNoticeImageView
    }()
    
    // MARK - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kHomeBackColor
        self.addSubview(nameLabel)
        self.addSubview(coutLabel)
        self.addSubview(rightNoticeLabel)
        self.addSubview(rightNoticeImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(10)
        }
        coutLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(5)
            make.centerY.equalTo(self)
        }
        rightNoticeImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-10)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        rightNoticeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(rightNoticeImageView.snp.left).offset(-5)
        }
    }
}
