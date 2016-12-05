//
//  HomeBangumiRecommendCell.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/5.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

let homeBangumiRecommendDesFont = UIFont.systemFont(ofSize: 11)
let homeBangumiRecommendCoverHeight:CGFloat = 100
class HomeBangumiRecommendCell: UICollectionViewCell {
    
    
    // MARK: - set get 方法
    var recommendModel: HomeBangumiRecommendModel? {
        didSet{
            // 1. 标题和描述
            titleLabel.text = recommendModel?.title
            desLabel.text = recommendModel?.desc
            // 2. 判断是否是new
            if recommendModel?.is_new == 1 {
                newImageView.isHidden = false
            }else {
                newImageView.isHidden = true
            }
            // 3. cover的图片
            guard let cover = recommendModel?.cover else {return}
            let url = URL(string: cover)
            contentImageView.sd_setImage(with: url)
        }
    }
    
    // MARK: - 懒加载控件
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.layer.cornerRadius = 5
        containerView.layer.masksToBounds = true
        return containerView
    }()
    
    lazy var contentImageView: UIImageView = {
        let contentImageView = UIImageView()
        contentImageView.contentMode = .scaleAspectFill
        return contentImageView
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        return titleLabel
    }()
    
    lazy var desLabel: UILabel = {
        let desLabel = UILabel()
        desLabel.textColor = UIColor.lightGray
        desLabel.font = homeBangumiRecommendDesFont
        desLabel.numberOfLines = 0
        return desLabel
    }()
    
    lazy var newImageView: UIImageView = {
        let newImageView = UIImageView()
        newImageView.contentMode = .scaleAspectFill
        newImageView.image = UIImage(named: "home_bangumi_tableHead_new")
        return newImageView
    }()
    
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(containerView)
        containerView.addSubview(contentImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(desLabel)
        containerView.addSubview(newImageView)
        self.backgroundColor = kHomeBackColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
        }
        
        contentImageView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(containerView)
            make.height.equalTo(homeBangumiRecommendCoverHeight)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(containerView.snp.left).offset(5)
            make.right.equalTo(containerView)
            make.top.equalTo(contentImageView.snp.bottom).offset(10)
        }
        
        desLabel.snp.makeConstraints { (make) in
            make.left.equalTo(containerView.snp.left).offset(5)
            make.right.bottom.equalTo(containerView)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        
        newImageView.snp.makeConstraints { (make) in
            make.top.equalTo(containerView)
            make.right.equalTo(containerView).offset(-30)
            make.size.equalTo(CGSize(width: 30, height: 20))
        }
    }
}
