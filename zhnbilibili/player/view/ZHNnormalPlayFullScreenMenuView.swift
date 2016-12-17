
//
//  ZHNnormalPlayFullScreenMenuView.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/16.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class ZHNnormalPlayFullScreenMenuView: ZHNplayerMenuBaseView {

    lazy var topMenu: ZHNnormalFullScreenTop = {
        let topMenu = ZHNnormalFullScreenTop.instanceView()
        return topMenu
    }()
    
    lazy var bottomMenu: ZHNnormalFullScreenBottom = {
        let bottomMenu = ZHNnormalFullScreenBottom.instanceView()
        return bottomMenu
    }()
    
    lazy var pauseButton: UIButton = {
        let pauseButton = UIButton()
        pauseButton.setImage(UIImage(named: "player_pause_iphone_window"), for: .normal)
        pauseButton.setImage(UIImage(named: "player_pause_iphone_window"), for: .highlighted)
        return pauseButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        topContainerView.addSubview(topMenu)
        bottomContainerView.addSubview(bottomMenu)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        topMenu.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self).offset(10)
            make.height.equalTo(60)
        }
        bottomMenu.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.bottom.equalTo(self)
            make.height.equalTo(60)
        }
    }
}
