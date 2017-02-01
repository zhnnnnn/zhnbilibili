//
//  ZHNhomePageSeasonCollectionViewCell.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/15.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit

class ZHNhomePageSeasonCollectionViewCell: normalBaseCell {
    
    
    // MARK - 属性
    var detailModel: HomeBangumiDetailModel? {
        didSet {
            if let cover = detailModel?.cover {
                let url = URL(string: cover)
                contentImageView.sd_setImage(with: url)
            }
            if let name = detailModel?.title {
                nameLabel.text = name
            }
            if let index = detailModel?.newest_ep_index {
                indexLabel.text = "\(index)话全"
            }
        }
    }
    
    // MARK - 懒加载控件
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 13)
        nameLabel.textColor = UIColor.white
        return nameLabel
    }()
    lazy var indexLabel: UILabel = {
        let indexLabel = UILabel()
        indexLabel.font = UIFont.systemFont(ofSize: 12)
        indexLabel.textColor = UIColor.white
        return indexLabel
    }()
    
    // MARK - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        customContentImageBottomOffset = 0
        self.addSubview(nameLabel)
        self.addSubview(indexLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentImageView).offset(3)
            make.right.equalTo(contentImageView).offset(-3)
            make.bottom.equalTo(contentImageView.snp.bottom).offset(-20)
            make.height.equalTo(20)
        }
        indexLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom)
        }
    }

}

