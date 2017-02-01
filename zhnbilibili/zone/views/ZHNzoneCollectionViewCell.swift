//
//  ZHNzoneCollectionViewCell.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/8.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit

class ZHNzoneCollectionViewCell: UICollectionViewCell {
    
    
    // MARK - 属性
    var statusModel: ZHNzoneModel? {
        didSet{
            if let tid = statusModel?.tid {
                iconImageView.image = UIImage(named: "home_region_icon_\(tid)")
            }
            nameLabel.text = statusModel?.name
            // 游戏中心特殊处理
            if statusModel?.name == "游戏中心" {
                backImageView.image = UIImage(named: "home_exregion_border")
                guard let logo = statusModel?.logo else {return}
                let url = URL(string: logo)
                iconImageView.sd_setImage(with: url)
                isGameTV = true
            }
        }
    }
    var isGameTV = false
    
    // MARK - 懒加载控件
    lazy var backImageView: UIImageView = {
        let backImageView = UIImageView()
        backImageView.image = UIImage(named: "home_region_border")
        backImageView.contentMode = UIViewContentMode.scaleAspectFill
        return backImageView
    }()
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.contentMode = UIViewContentMode.scaleAspectFill
        return iconImageView
    }()
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        return nameLabel
    }()
    
    // MARK - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(backImageView)
        self.addSubview(iconImageView)
        self.addSubview(nameLabel)
        self.backgroundColor = kHomeBackColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 20, left: 25, bottom: 30, right: 25))
        }
        if isGameTV == true {
            iconImageView.snp.makeConstraints { (make) in
                make.centerX.equalTo(backImageView)
                make.centerY.equalTo(backImageView).offset(5)
                make.size.equalTo(CGSize(width: 45, height: 45))
            }
        }else {
            iconImageView.snp.makeConstraints { (make) in
                make.center.equalTo(backImageView)
                make.size.equalTo(CGSize(width: 40, height: 40))
            }
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(backImageView)
            make.top.equalTo(backImageView.snp.bottom).offset(13)
        }
    }
}
