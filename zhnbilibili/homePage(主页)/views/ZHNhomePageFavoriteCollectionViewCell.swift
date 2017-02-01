//
//  ZHNhomePageFavoriteCollectionViewCell.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/15.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit

class ZHNhomePageFavoriteCollectionViewCell: UICollectionViewCell {
    
    var detailModel: ZHNhomePagefavirateDetailModel? {
        didSet {
            if isSetted {return}
            isSetted = true
            // 图片
            guard let list = detailModel?.cover else {
                setupUI()
                self.backgroundColor = UIColor.lightGray
                return
            }
            let count = list.count
            if count == 1 {
                // 1. 创建view
                let model = list.first
                let coverImageView = UIImageView()
                coverImageView.contentMode = .scaleAspectFill
                self.addSubview(coverImageView)
                coverImageView.frame = self.bounds
                coverImageView.clipsToBounds = true
                coverImageView.backgroundColor = UIColor.lightGray
                // 2. 赋值图片
                guard let pic = model?.pic else {return}
                let url = URL(string: pic)
                coverImageView.sd_setImage(with: url)
            }else if count == 2 {
                for i in 0..<2 {
                    // 1. 创建view
                    let model = list[i]
                    let coverImageView = UIImageView()
                    coverImageView.contentMode = .scaleAspectFill
                    coverImageView.clipsToBounds = true
                    coverImageView.backgroundColor = UIColor.lightGray
                    self.addSubview(coverImageView)
                    let coverImageY = (self.zhnheight/2 + 2.5) * CGFloat(i)
                    let height = (self.zhnheight/2 - 2.5)
                    coverImageView.frame = CGRect(x: 0, y: coverImageY, width: self.zhnWidth, height: height)
                    // 2. 赋值图片
                    let url = URL(string: model.pic)
                    coverImageView.sd_setImage(with: url)
                }
            }else if count == 3 {
                for i in 0..<3 {
                    // 1. 创建view
                    let model = list[i]
                    let coverImageView = UIImageView()
                    coverImageView.contentMode = .scaleAspectFill
                    coverImageView.clipsToBounds = true
                    coverImageView.backgroundColor = UIColor.lightGray
                    self.addSubview(coverImageView)
                    let height = (self.zhnheight/2 - 2.5)
                    if i == 0 {
                        coverImageView.frame = CGRect(x: 0, y: 0, width: self.zhnWidth, height: height)
                    }else {
                        let coverImageY = (self.zhnheight/2 + 2.5)
                        let coverImageX = (self.zhnWidth/2 + 2.5) * CGFloat(i - 1)
                        let coverImageWidth = (self.zhnWidth/2 - 2.5)
                        coverImageView.frame = CGRect(x: coverImageX, y: coverImageY, width: coverImageWidth, height: height)
                    }
                    // 2. 赋值图片
                    let url = URL(string: model.pic)
                    coverImageView.sd_setImage(with: url)
                }
            }else if count == 0 {
                self.backgroundColor = UIColor.lightGray
            }
            
            setupUI()
        }
    }
    
    var isSetted = false
}

//======================================================================
// MARK:- 私有方法
//======================================================================
extension ZHNhomePageFavoriteCollectionViewCell {
    fileprivate func setupUI() {
        
        // maskimageview
        let maskImageView = UIImageView()
        maskImageView.image = UIImage(named: "live_bottom_bg")
        self.addSubview(maskImageView)
        maskImageView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.top.equalTo(self.snp.centerY)
        }
        
        // 个数
        let countLabel = UILabel()
        countLabel.layer.cornerRadius = 5
        countLabel.clipsToBounds = true
        countLabel.backgroundColor = UIColor.ZHNcolor(red: 80, green: 80, blue: 80, alpha: 0.7)
        self.addSubview(countLabel)
        countLabel.textColor = UIColor.white
        countLabel.font = UIFont.systemFont(ofSize: 11)
        countLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(5)
            make.right.equalTo(self).offset(-5)
            make.height.equalTo(25)
        }
        if let count = detailModel?.cur_count {
            countLabel.text = "  \(count)  "
        }else {
            countLabel.text = "  0  "
        }
        
        // 名字
        let nameLabel = UILabel()
        nameLabel.textColor = UIColor.white
        nameLabel.font = UIFont.systemFont(ofSize: 12)
        nameLabel.text = detailModel?.name
        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(5)
            make.right.equalTo(self).offset(-5)
            make.bottom.equalTo(self).offset(-10)
        }
        
        //
        layer.cornerRadius = 5
        self.clipsToBounds = true
    }
}

