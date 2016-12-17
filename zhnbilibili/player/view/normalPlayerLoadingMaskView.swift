//
//  normalPlayerLoadingMaskView.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/15.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class normalPlayerLoadingMaskView: UIView {

    // 返回按钮的action
    var backButtonAction: (()->Void)?
    
    // MARK: - 懒加载控件
    fileprivate lazy var backButton: UIButton = {
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "videoinfo_back"), for: .normal)
        backButton.setImage(UIImage(named: "videoinfo_back"), for: .highlighted)
        backButton.addTarget(self, action: #selector(popViewAction), for: .touchUpInside)
        return backButton
    }()
    fileprivate lazy var startImageView: UIImageView = {
        let startImageView = UIImageView()
        startImageView.image = UIImage(named: "player_start_iphone_window")
        startImageView.contentMode = .scaleAspectFill
        return startImageView
    }()
    lazy var menuTitlelabel: UILabel = {
        let menuTitlelabel = UILabel()
        menuTitlelabel.textColor = knavibarcolor
        menuTitlelabel.font = UIFont.systemFont(ofSize: 13)
        menuTitlelabel.text = "简介"
        return menuTitlelabel
    }()
    lazy var menuLine: UIView = {
        let menuLinne = UIView()
        menuLinne.backgroundColor = knavibarcolor
        return menuLinne
    }()
    lazy var menuContainerView: UIView = {
        let menuContainerView = UIView()
        menuContainerView.backgroundColor = UIColor.white
        return menuContainerView
    }()
    lazy var topContainerView: UIView = {
        let topContainerView = UIView()
        topContainerView.backgroundColor = UIColor.lightGray
        return topContainerView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(topContainerView)
        self.addSubview(menuContainerView)
        topContainerView.addSubview(backButton)
        topContainerView.addSubview(startImageView)
        menuContainerView.addSubview(menuTitlelabel)
        menuTitlelabel.addSubview(menuLine)
        self.backgroundColor = kHomeBackColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topContainerView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo(knormalPlayerHeight)
        }
        menuContainerView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self).offset(knormalPlayerHeight)
            make.height.equalTo(30)
        }
        startImageView.frame = CGRect(x: kscreenWidth - 80, y: knormalPlayerHeight - 60, width: 60, height: 40)
        backButton.center = CGPoint(x: 20, y: 30)
        backButton.sizeToFit()
        
        menuTitlelabel.snp.makeConstraints { (make) in
            make.center.equalTo(menuContainerView)
        }
        menuTitlelabel.sizeToFit()
        
        menuLine.snp.makeConstraints { (make) in
            make.centerX.equalTo(menuContainerView)
            make.top.equalTo(menuContainerView).offset(28)
            make.size.equalTo(CGSize(width: 60, height: 2))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - target action
extension normalPlayerLoadingMaskView {
    @objc fileprivate func popViewAction() {
        guard let action = backButtonAction else {return}
        action()
    }
}

