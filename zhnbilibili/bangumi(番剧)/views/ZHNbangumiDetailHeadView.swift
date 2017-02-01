//
//  ZHNbangumiDetailHeadView.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/20.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit
import DynamicBlurView

let kbangumiDetainClickBackButtonNotification = Notification.Name("kbangumiDetainClickBackButtonNotification")
class ZHNbangumiDetailHeadView: UIView {

    
    var headDetailModel: ZHNbangumiDetailModel? {
        didSet {
            // 加载背景和海报
            if let cover = headDetailModel?.cover {
                let url = URL(string: cover)
                backImageView.sd_setImage(with: url)
                postImageView.sd_setImage(with: url)
            }
            
            characterView.headDetailModel = headDetailModel 
        }
    }
    
    // MARK - 懒加载控件
    fileprivate lazy var backImageView: UIImageView = {
        let backImageView = UIImageView()
        backImageView.contentMode = .scaleAspectFill
        backImageView.clipsToBounds = true
        return backImageView
    }()

    fileprivate lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        return blurView
    }()
    
    fileprivate lazy var backButton: UIButton = {
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "common_back_v2"), for: .normal)
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        return backButton
    }()
    
    fileprivate lazy var titleNoticeLabel: UILabel = {
        let titleNoticeLabel = UILabel()
        titleNoticeLabel.text = "番剧详情"
        titleNoticeLabel.textColor = UIColor.white
        return titleNoticeLabel
    }()
    
    fileprivate lazy var postImageView: UIImageView = {
        let postImageView = UIImageView()
        postImageView.contentMode = .scaleAspectFill
        postImageView.layer.cornerRadius = 5
        postImageView.layer.borderColor = UIColor.white.cgColor
        postImageView.layer.borderWidth = 2
        postImageView.clipsToBounds = true
        return postImageView
    }()
    
    fileprivate lazy var characterView: ZHNbangumiDetailHeadCharacterView = {
        let characterView = ZHNbangumiDetailHeadCharacterView.instanceView()
        return characterView
    }()
    
    fileprivate lazy var menuView: ZHNbangumiDetailHeadMenuView = {
        let menuView = ZHNbangumiDetailHeadMenuView.instanceView()
        return menuView
    }()
    
    fileprivate lazy var fillView: UIImageView = {
        let fillView = UIImageView()
        fillView.backgroundColor = kHomeBackColor
        return fillView
    }()
    
    
    // MARK - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(backImageView)
        self.addSubview(blurView)
        self.addSubview(fillView)
        self.addSubview(backButton)
        self.addSubview(titleNoticeLabel)
        self.addSubview(postImageView)
        self.addSubview(characterView)
        self.addSubview(menuView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backImageView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.bottom.equalTo(self).offset(-60)
        }
        
        blurView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(backImageView)
        }
        
        fillView.snp.makeConstraints { (make) in
            make.top.equalTo(backImageView.snp.bottom)
            make.left.right.bottom.equalTo(self)
        }
        
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.top.equalTo(self).offset(25)
            make.size.equalTo(CGSize(width: 40, height: 30))
        }
        
        titleNoticeLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(backButton)
        }
        
        postImageView.snp.makeConstraints { (make) in
            make.left.equalTo(backButton)
            make.top.equalTo(backButton.snp.bottom).offset(20)
            make.size.equalTo(CGSize(width: 110, height: 150))
        }
        
        menuView.snp.makeConstraints { (make) in
            make.centerY.equalTo(fillView.snp.top).offset(15)
            make.left.equalTo(postImageView.snp.right)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
        }
        
        characterView.snp.makeConstraints { (make) in
            make.top.equalTo(postImageView)
            make.left.equalTo(menuView).offset(10)
            make.right.equalTo(self)
            make.bottom.equalTo(menuView.snp.top)
        }
    }
}

//======================================================================
// MARK:- target action
//======================================================================
extension ZHNbangumiDetailHeadView {
    @objc func backAction() {
        NotificationCenter.default.post(name: kbangumiDetainClickBackButtonNotification, object: nil)
    }
}

