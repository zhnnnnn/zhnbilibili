//
//  HomeBangumiNormalCell.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/1.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class HomeBangumiNormalCell: normalBaseCell {

    
    var bangumiDetailModel: HomeBangumiDetailModel? {
        didSet{
            // 1.图片赋值
            if let cover = bangumiDetailModel?.cover {
                let coveURL = URL(string: cover)
                contentImageView.sd_setImage(with: coveURL)
            }
            // 2. 标题赋值
            if let title = bangumiDetailModel?.title {
                bangumiTitleLabel.text = title
            }
            // 3. 标题之类的赋值
            guard let watchCount = bangumiDetailModel?.watching_count else {return}
            if watchCount == 0 {
                guard let faviouteString = bangumiDetailModel?.favourites.returnShowString() else {return}
                bangumiNoticeLabel.text = "\(faviouteString)人追番"
                bangumiIndexLabel.isHidden = true
            }else{
                bangumiIndexLabel.isHidden = false
                let watchString = "\(watchCount.returnShowString())人在看"
                bangumiNoticeLabel.text = watchString
                if let newestIndex = bangumiDetailModel?.newest_ep_index {
                    bangumiIndexLabel.text = "更新至第\(newestIndex)话"
                }
            }
        }
    }
    
    // MARK: - 懒加载控件
    lazy var bangumiNoticeLabel: UILabel = {
        let bangumiNoticeLabel = UILabel()
        bangumiNoticeLabel.textColor = UIColor.white
        bangumiNoticeLabel.font = celldetailLabelsFont
        return bangumiNoticeLabel
    }()
    
    lazy var bangumiTitleLabel: UILabel = {
        let bangumiTitleLabel = UILabel()
        bangumiTitleLabel.numberOfLines = 0
        bangumiTitleLabel.font = knormalItemCellTitleFont
        return bangumiTitleLabel
    }()
    
    lazy var bangumiIndexLabel: UILabel = {
        let bangumiIndexLabel = UILabel()
        bangumiIndexLabel.font = UIFont.systemFont(ofSize: 11)
        bangumiIndexLabel.textColor = UIColor.lightGray
        return bangumiIndexLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customContentImageBottomOffset = 60
        self.addSubview(bangumiNoticeLabel)
        self.addSubview(bangumiIndexLabel)
        self.addSubview(bangumiTitleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 初始化位置
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bangumiNoticeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentImageView.snp.left).offset(5)
            make.bottom.equalTo(contentImageView.snp.bottom).offset(-5)
        }
        
        bangumiTitleLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentImageView)
            make.top.equalTo(contentImageView.snp.bottom).offset(5)
        }
        
        bangumiIndexLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentImageView)
            make.top.equalTo(bangumiTitleLabel.snp.bottom)
            make.height.equalTo(20)
        }
    }
}


