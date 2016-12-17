//
//  ZHNlivePlayFullScreenMenuView.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/10.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit


@objc protocol ZHNliveFullscreenMenuViewDelegate {
    @objc optional func backAction()
}

class ZHNlivePlayFullScreenMenuView: ZHNplayerMenuBaseView {
    // 代理
    weak var delegate: ZHNliveFullscreenMenuViewDelegate?
    
    // MARK: - 懒加载控件
    lazy var liveTopBackImageView: UIImageView = {
        let liveTopBackImageView = UIImageView()
        liveTopBackImageView.isUserInteractionEnabled = true
        liveTopBackImageView.image = UIImage(named: "live_player_vtop_bg")?.zhnResizingImage()
        return liveTopBackImageView
    }()
    
    lazy var liveBottomBackImageView: UIImageView = {
        let liveBottomBackImageView = UIImageView()
        liveBottomBackImageView.isUserInteractionEnabled = true
        liveBottomBackImageView.image = UIImage(named: "live_player_vbottom_bg")?.zhnResizingImage()
        return liveBottomBackImageView
    }()
    
    lazy var menuTop: ZHNliveFullScreenMenuViewTop = {
        let menuTop = ZHNliveFullScreenMenuViewTop.instanceView()
        menuTop.supView = self
        return menuTop
    }()
    
    lazy var menuBottm: ZHNliveFullScreenMenuViewBottom = {
        let menuBottom = ZHNliveFullScreenMenuViewBottom.instanceView()
        menuBottom.supView = self
        return menuBottom
    }()
    
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        topContainerView.addSubview(liveTopBackImageView)
        topContainerView.addSubview(menuTop)
        bottomContainerView.addSubview(liveBottomBackImageView)
        bottomContainerView.addSubview(menuBottm)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        liveTopBackImageView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(self)
            make.height.equalTo(100)
        }
        menuTop.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self).offset(10)
            make.height.equalTo(50)
        }
        
        liveBottomBackImageView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(70)
        }
        menuBottm.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(50)
        }
    }
}
