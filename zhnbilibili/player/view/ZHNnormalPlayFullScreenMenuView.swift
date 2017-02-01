
//
//  ZHNnormalPlayFullScreenMenuView.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/16.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit
import IJKMediaFramework

@objc protocol ZHNnormalFullScreenViewDelegate {
    @objc optional func pauseAction(isPlaying: Bool)
    @objc optional func backAction()
}

class ZHNnormalPlayFullScreenMenuView: ZHNplayerMenuBaseView {

    // 代理
    weak var delegate: ZHNnormalFullScreenViewDelegate?
    // 判断是否正在播放
    var isPlaying = true
    // MARK - 懒加载控件
    lazy var topMenu: ZHNnormalFullScreenTop = {
        let topMenu = ZHNnormalFullScreenTop.instanceView()
        topMenu.backAction = {[weak self] in
            guard let delegate = self?.delegate else {return}
            guard let method = delegate.backAction else {return}
            method()
        }
        return topMenu
    }()
    
    lazy var bottomMenu: ZHNnormalFullScreenBottom = {
        let bottomMenu = ZHNnormalFullScreenBottom.instanceView()
        bottomMenu.backAction = {[weak self] in
            guard let delegate = self?.delegate else {return}
            guard let method = delegate.backAction else {return}
            method()
        }
        return bottomMenu
    }()
    
    lazy var pauseButton: UIButton = {
        let pauseButton = UIButton()
        pauseButton.setImage(UIImage(named: "player_pause_iphone_window"), for: .normal)
        pauseButton.setImage(UIImage(named: "player_pause_iphone_window"), for: .highlighted)
        pauseButton.addTarget(self, action: #selector(pauseAction), for: .touchUpInside)
        return pauseButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 1. 添加控件
        topContainerView.addSubview(topMenu)
        bottomContainerView.addSubview(pauseButton)
        bottomContainerView.addSubview(bottomMenu)
        // 2. 添加通知
        NotificationCenter.default.addObserver(self, selector: #selector(playerBackStateDidChange(notification:)), name: NSNotification.Name.IJKMPMoviePlayerPlaybackStateDidChange, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        topMenu.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self)
            make.height.equalTo(60)
        }
        pauseButton.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-10)
            make.bottom.equalTo(self).offset(-60)
            make.size.equalTo(CGSize(width: 80, height: 60))
        }
        bottomMenu.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.bottom.equalTo(self)
            make.height.equalTo(60)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//======================================================================
// MARK:- target action
//======================================================================
extension ZHNnormalPlayFullScreenMenuView {
    @objc fileprivate func pauseAction() {
        guard let delegate = delegate else {return}
        guard let method = delegate.pauseAction else {return}
        method(isPlaying)
        if isPlaying {
            noticePauseState(pause: true)
        }else{
            noticePauseState(pause: false)
        }
    }
    
    @objc func playerBackStateDidChange(notification:Notification) {
        guard let mpPlayer = notification.object as? IJKFFMoviePlayerController else {return}
        if mpPlayer.playbackState == .playing {
            pauseButton.setImage(UIImage(named: "player_pause_iphone_window"), for: .normal)
            pauseButton.setImage(UIImage(named: "player_pause_iphone_window"), for: .highlighted)
            isPlaying = true
        }else if mpPlayer.playbackState == .paused {
            pauseButton.setImage(UIImage(named: "player_start_iphone_window"), for: .normal)
            pauseButton.setImage(UIImage(named: "player_start_iphone_window"), for: .highlighted)
            isPlaying = false
        }
    }
}

