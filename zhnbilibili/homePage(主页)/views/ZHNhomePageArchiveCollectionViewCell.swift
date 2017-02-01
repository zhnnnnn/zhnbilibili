//
//  ZHNhomePageArchiveCollectionViewCell.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/13.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit

class ZHNhomePageArchiveCollectionViewCell: normalBaseCell {
 
    override var statusModel: itemDetailModel? {
        didSet {
            intialStatus()
            if let play = statusModel?.play {
                playLabel.text = play.returnShowString()
            }
            if let danmuku = statusModel?.danmaku {
                danmukuLabel.text = danmuku.returnShowString()  
            }
        }
    }
    // MARK - 懒加载控件
    lazy var playIconImageView: UIImageView = {
        let playIconImageView = UIImageView()
        playIconImageView.contentMode = .center
        playIconImageView.image = UIImage(named: "misc_playCount_new")?.withTintColor( UIColor.lightGray)
        return playIconImageView
    }()
    
    lazy var playLabel: UILabel = {
        let playLabel = UILabel()
        playLabel.font = UIFont.systemFont(ofSize: 11)
        playLabel.textColor = UIColor.lightGray
        return playLabel
    }()
    
    lazy var danmukuIconImageView: UIImageView = {
        let danmukuIconImageView = UIImageView()
        danmukuIconImageView.contentMode = .center
        danmukuIconImageView.image = UIImage(named: "misc_danmakuCount_new")?.withTintColor( UIColor.lightGray)
        return danmukuIconImageView
    }()
    
    lazy var danmukuLabel: UILabel = {
        let danmukuLabel = UILabel()
        danmukuLabel.font = UIFont.systemFont(ofSize: 11)
        danmukuLabel.textColor = UIColor.lightGray
        return danmukuLabel
    }()
    
    // MARK - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.backgroundColor = UIColor.clear
        self.addSubview(playIconImageView)
        self.addSubview(playLabel)
        self.addSubview(danmukuIconImageView)
        self.addSubview(danmukuLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playIconImageView.snp.makeConstraints { (make) in
            make.left.equalTo(contentImageView.snp.left)
            make.top.equalTo(titleLabel.snp.bottom)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        playLabel.snp.makeConstraints { (make) in
            make.left.equalTo(playIconImageView.snp.right).offset(5)
            make.centerY.equalTo(playIconImageView)
        }
        danmukuIconImageView.snp.makeConstraints { (make) in
            make.left.equalTo(contentImageView.snp.centerX)
            make.centerY.equalTo(playIconImageView)
            make.size.equalTo(playIconImageView.snp.size)
        }
        danmukuLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(playIconImageView)
            make.left.equalTo(danmukuIconImageView.snp.right).offset(5)
        }
    }
    
}
