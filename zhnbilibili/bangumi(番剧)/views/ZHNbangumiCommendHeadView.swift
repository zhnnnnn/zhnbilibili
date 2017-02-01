//
//  ZHNbangumiCommendHeadView.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/23.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit

class ZHNbangumiCommendHeadView: UIView {

    // MARK - 懒加载控件
    fileprivate lazy var leftLabel: UILabel = {
        let leftLabel = UILabel()
        leftLabel.text = "评论 第 1 话 (1234)"
        return leftLabel
    }()
    
    fileprivate lazy var rightLabel: UILabel = {
        let rightLabel = UILabel()
        rightLabel.textColor = UIColor.lightGray
        rightLabel.font = UIFont.systemFont(ofSize: 14)
        rightLabel.text = "选集"
        return rightLabel
    }()
    
    fileprivate lazy var arrowImageView: UIImageView = {
        let arrowImageView = UIImageView()
        arrowImageView.image = UIImage(named: "more_arrow")
        arrowImageView.contentMode = .center
        return arrowImageView
    }()
    
    // MARK - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kHomeBackColor
        self.addSubview(leftLabel)
        self.addSubview(rightLabel)
        self.addSubview(arrowImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        leftLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(15)
        }
        arrowImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-10)
            make.size.equalTo(CGSize(width: 25, height: 25))
        }
        rightLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(arrowImageView.snp.left).offset(-15)
        }
    }
    
}
