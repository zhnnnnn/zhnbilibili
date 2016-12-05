//
//  HomeBangumiNormalHead.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/4.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class HomeBangumiNormalHead: UICollectionReusableView {
    
    // 组 季节
    var section: Int = 0 {
        didSet{
            // 1. 新番
            if section == 1 {
                normalHead.noticeLabel.isHidden = false
                normalHead.arrImageView.isHidden = false
                normalHead.noticeLabel.text = "分季列表"
            }
            // 2. 推荐
            if section == 2 {
                normalHead.iconLabel.text = "番剧推荐"
                normalHead.noticeLabel.isHidden = true
                normalHead.arrImageView.isHidden = true
                normalHead.iconImageView.image = UIImage(named: "home_bangumi_tableHead_bangumiRecommend")
            }
        }
    }

    var season: Int = 0 {
        didSet{
            normalHead.iconImageView.image = season.seasionIconImage()
            normalHead.iconLabel.text = "\(season.seasionMoth())月新番"
        }
    }
    
    // MARK: - 懒加载控件
    lazy var normalHead: collectionNormalHeader = {
        let normalHead = collectionNormalHeader()
        return normalHead
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(normalHead)
        normalHead.rightIconImageView.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        normalHead.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }

}
