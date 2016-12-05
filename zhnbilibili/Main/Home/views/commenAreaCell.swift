//
//  commenAreaCell.swift
//  zhnbilibili
//
//  Created by zhn on 16/11/27.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit
class commenAreaCell: normalBaseCell {

    
    // MARK: - set 方法 
    // 赋值播放数和评论数
    var sonStatusModel: itemDetailModel? {
        didSet{
            
            if let playCount = sonStatusModel?.play{
                playNumberLabel.text = playCount.returnShowString()
            }
            
            if let reviewCount = sonStatusModel?.danmaku {
                reviewLabel.text = reviewCount.returnShowString()
            }
            
        }
    }
    
    // MARK: - 懒加载控件
    lazy var playIocnImageView: UIImageView = {
        let playIconImageView = UIImageView()
        playIconImageView.image = UIImage(named: "misc_playCount_new")
        return playIconImageView
    }()

    lazy var playNumberLabel: UILabel = {
        let playNumberLabel = UILabel()
        playNumberLabel.sizeToFit()
        playNumberLabel.text = ""
        playNumberLabel.textColor = UIColor.white
        playNumberLabel.font = celldetailLabelsFont
        return playNumberLabel
    }()
    
    lazy var reviewIconImageView: UIImageView = {
        let reviewIconImageView = UIImageView()
        reviewIconImageView.image = UIImage(named: "misc_danmakuCount_new")
        return reviewIconImageView
    }()
    
    lazy var reviewLabel: UILabel = {
        let reviewLabel = UILabel()
        reviewLabel.text = ""
        reviewLabel.textColor = UIColor.white
        reviewLabel.font = celldetailLabelsFont
        return reviewLabel
    }()
    
    
    // MARK: - 重写init方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 添加控件
        self.addSubview(playIocnImageView)
        self.addSubview(playNumberLabel)
        self.addSubview(reviewIconImageView)
        self.addSubview(reviewLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playIocnImageView.snp.makeConstraints { (make) in
            make.left.equalTo(maskImageView.snp.left).offset(8)
            make.bottom.equalTo(maskImageView.snp.bottom).offset(-6)
            make.size.equalTo(CGSize(width: cellIconWidth, height: cellIconHeight))
        }
        playNumberLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(playIocnImageView)
            make.left.equalTo(playIocnImageView.snp.right).offset(3)
        }
        
        reviewIconImageView.snp.makeConstraints { (make) in
            make.left.equalTo(maskImageView.snp.centerX).offset(5)
            make.centerY.equalTo(playIocnImageView)
            make.size.equalTo(playIocnImageView)
        }
        reviewLabel.snp.makeConstraints { (make) in
            make.left.equalTo(reviewIconImageView.snp.right).offset(3)
            make.centerY.equalTo(playIocnImageView)
        }
    }
}
