//
//  ZHNlivePlayNoramlMenuView.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/10.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit
import IJKMediaFramework

@objc protocol ZHNlivePlayMenuNormalViewDelegate {
    @objc optional func popViewControllerAction()
    @objc optional func shareAction()
    @objc optional func fullScreenAction()
    @objc optional func pauseAction(isPlaying:Bool)
}

class ZHNlivePlayNoramlMenuView: ZHNplayerMenuBaseView {

    /// 代理
    weak var delegate: ZHNlivePlayMenuNormalViewDelegate?
    
    /// 判断是否正在播放
    var isPlaying = true
    
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
    
    lazy var backButton: UIButton = {
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "live_back_ico"), for: .normal)
        backButton.setImage(UIImage(named: "live_back_ico"), for: .highlighted)
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        return backButton
    }()
    
    lazy var smallPauseButton: UIButton = {
        let smallPauseButton = UIButton()
        smallPauseButton.setImage(UIImage(named: "player_pause_bottom_window"), for: .normal)
        smallPauseButton.setImage(UIImage(named: "player_pause_bottom_window"), for: .highlighted)
        smallPauseButton.addTarget(self, action: #selector(pauseAction), for: .touchUpInside)
        return smallPauseButton
    }()
    
    lazy var bigPauseButton: UIButton = {
        let bigPauseButton = UIButton()
        bigPauseButton.setImage(UIImage(named: "player_pause_iphone_window"), for: .normal)
        bigPauseButton.setImage(UIImage(named: "player_pause_iphone_window"), for: .highlighted)
        bigPauseButton.addTarget(self, action: #selector(pauseAction), for: .touchUpInside)
        return bigPauseButton
    }()
    
    lazy var fullScreenButton: UIButton = {
        let fullScreenButton = UIButton()
        fullScreenButton.setImage(UIImage(named: "player_fullScreen_iphone"), for: .normal)
        fullScreenButton.setImage(UIImage(named: "player_fullScreen_iphone"), for: .highlighted)
        fullScreenButton.addTarget(self, action: #selector(fullScreenAction), for: .touchUpInside)
        return fullScreenButton
    }()
    
    lazy var shareButton: UIButton = {
        let shareButton = UIButton()
        shareButton.setImage(UIImage(named: "hd_icmpv_more_light"), for: .normal)
        shareButton.setImage(UIImage(named: "hd_icmpv_more_light"), for: .highlighted)
        shareButton.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
        return shareButton
    }()
    
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 1.添加控件
        topContainerView.addSubview(liveTopBackImageView)
        bottomContainerView.addSubview(liveBottomBackImageView)
        bottomContainerView.addSubview(bigPauseButton)
        liveTopBackImageView.addSubview(backButton)
        liveTopBackImageView.addSubview(shareButton)
        liveBottomBackImageView.addSubview(smallPauseButton)
        liveBottomBackImageView.addSubview(fullScreenButton)
        // 2.添加通知
        NotificationCenter.default.addObserver(self, selector: #selector(playerBackStateDidChange(notification:)), name: NSNotification.Name.IJKMPMoviePlayerPlaybackStateDidChange, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 1. 初始化控件的位置
        liveTopBackImageView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.height.equalTo(50)
        }
        
        liveBottomBackImageView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(50)
        }
        
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.top.equalTo(self).offset(20)
        }
        
        smallPauseButton.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(15)
            make.bottom.equalTo(self).offset(-10)
        }
        
        fullScreenButton.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-30)
            make.bottom.equalTo(self).offset(-10)
        }
        
        bigPauseButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(fullScreenButton)
            make.bottom.equalTo(fullScreenButton.snp.top)
        }
        
        shareButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(bigPauseButton)
            make.top.equalTo(backButton)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//======================================================================
// MARK:- target action
//======================================================================
extension ZHNlivePlayNoramlMenuView {
    
    @objc func backAction() {
        guard let delegate = delegate else {return}
        guard let method = delegate.popViewControllerAction else {return}
        method()
    }
    
    @objc func fullScreenAction() {
        guard let delegate = delegate else {return}
        guard let method = delegate.fullScreenAction else {return}
        method()
    }
    
    @objc func pauseAction() {
        guard let delegate = delegate else {return}
        guard let method = delegate.pauseAction else {return}
        method(isPlaying)
        if isPlaying {
            noticePauseState(pause: true)
        }else{
            noticePauseState(pause: false)
        }
    }
    
    @objc func shareAction() {
        guard let delegate = delegate else {return}
        guard let method = delegate.shareAction else {return}
        method()
    }
    
    @objc func playerBackStateDidChange(notification:Notification) {
        guard let mpPlayer = notification.object as? IJKFFMoviePlayerController else {return}
         if mpPlayer.playbackState == .playing {
            bigPauseButton.setImage(UIImage(named: "player_pause_iphone_window"), for: .normal)
            bigPauseButton.setImage(UIImage(named: "player_pause_iphone_window"), for: .highlighted)
            smallPauseButton.setImage(UIImage(named: "player_pause_bottom_window"), for: .normal)
            smallPauseButton.setImage(UIImage(named: "player_pause_bottom_window"), for: .highlighted)
            isPlaying = true
         }else if mpPlayer.playbackState == .paused {
            bigPauseButton.setImage(UIImage(named: "player_start_iphone_window"), for: .normal)
            bigPauseButton.setImage(UIImage(named: "player_start_iphone_window"), for: .highlighted)
            smallPauseButton.setImage(UIImage(named: "player_play_bottom_window"), for: .normal)
            smallPauseButton.setImage(UIImage(named: "player_play_bottom_window"), for: .highlighted)
            isPlaying = false
         }
    }
}

//======================================================================
// MARK:- 私有方法
//======================================================================
extension ZHNlivePlayNoramlMenuView {
    

}
