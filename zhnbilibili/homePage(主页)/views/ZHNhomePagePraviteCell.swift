//
//  ZHNhomePagePraviteCell.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/14.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit

class ZHNhomePagePraviteCell: UITableViewCell {

    
    // MARK - 属性
    var type: homePageSectionType = homePageSectionType.card {
        didSet {
            switch type {
            case homePageSectionType.coinVideoPravite:
                nameLabel.text = "最近投币"
                rightNoticeLabel.text = "没有公开投币"
            case homePageSectionType.favouritePravite:
                nameLabel.text = "TA的收藏夹"
                rightNoticeLabel.text = "没有公开的收藏夹"
            case homePageSectionType.seasonPravite:
                nameLabel.text = "TA的追番"
                rightNoticeLabel.text = "没有公开的追番"
            case homePageSectionType.gamePravite:
                nameLabel.text = "TA玩的游戏"
                rightNoticeLabel.text = "没有公开的游戏"
            case homePageSectionType.tagePravite:
                nameLabel.text = "TA关注的标签"
                rightNoticeLabel.text = "没有公开关注的标签"
            default:
                break
            }
        }
    }
    
    // MARK - 懒加载控件
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        return nameLabel
    }()
    
    lazy var countLabel: UILabel = {
        let countLabel = UILabel()
        countLabel.text = "0"
        countLabel.font = UIFont.systemFont(ofSize: 13)
        countLabel.textColor = UIColor.lightGray
        return countLabel
    }()
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(named: "space_hide_eye_icon")
        iconImageView.contentMode = .center
        return iconImageView
    }()
    
    lazy var rightNoticeLabel: UILabel = {
        let rightNoticeLabel = UILabel()
        rightNoticeLabel.textColor = UIColor.lightGray
        rightNoticeLabel.font = UIFont.systemFont(ofSize: 13)
        return rightNoticeLabel
    }()
    
    lazy var lineView: UIImageView = {
        let lineView = UIImageView()
        lineView.backgroundColor = ktableCellLineColor
        return lineView
    }()
    // MARK - life cycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = kHomeBackColor
        self.addSubview(nameLabel)
        self.addSubview(countLabel)
        self.addSubview(iconImageView)
        self.addSubview(rightNoticeLabel)
        self.addSubview(lineView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.centerY.equalTo(self)
        }
        countLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(nameLabel.snp.right).offset(5)
        }
        iconImageView.snp.makeConstraints { (make) in
            make.left.equalTo(countLabel.snp.right).offset(5)
            make.centerY.equalTo(self)
        }
        rightNoticeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-5)
            make.centerY.equalTo(self)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
}
