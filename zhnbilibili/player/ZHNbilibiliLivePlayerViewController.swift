//
//  ZHNbilibiliLivePlayerViewController.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/6.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit
import IJKMediaFramework

/// 全屏的通知
let kfullscreenActionNotification = Notification.Name("kfullscreenActionNotification")
/// 退出全屏的通知
let knormalscreenActionNotification = Notification.Name("knormalscreenActionNotification")
/// 没有全屏情况下播放器的高度
let knormalPlayerHeight: CGFloat = 200

class ZHNbilibiliLivePlayerViewController: UIViewController {

    /// 缓冲数据的时候的timer
    var updataTimer: SwiftTimer?
    /// 是否是全屏状态
    var isfullScreen = false
    /// 全屏window切换的时候的展示的view
    var windowRoteImage: UIImage?
    
    // MARK: - 所有的action的封装
    // 1. 视频加载时候的menu的action
    var loadingActionModel: ZHNplayerUrlLoadingBackViewActionModel = ZHNplayerUrlLoadingBackViewActionModel()
    // 2. 直播的视频播放的menu的action
    var liveplayNormalActionModel: ZHNplayNormalMenuViewActionModel = ZHNplayNormalMenuViewActionModel()
    // 3. 直播的视频播放的全屏时候的action
    var liveplayFullScreenActionModel: ZHNplayFullScreenMenuViewActionModel = ZHNplayFullScreenMenuViewActionModel()
    
    // MARK: - 懒加载控件
    lazy var liveContainerView: UIView = {
        let liveContainerView = UIView()
        liveContainerView.backgroundColor = kHomeBackColor
        return liveContainerView
    }()
    
    lazy var bilibiliLiveIcon: UIImageView = {
        let bilibiliLiveIcon = UIImageView()
        bilibiliLiveIcon.image = UIImage(named: "live_bilih_ico")
        bilibiliLiveIcon.contentMode = .scaleAspectFit
        return bilibiliLiveIcon
    }()
    
    lazy var playLoadingMenuView: ZHNplayerUrlLoadingBackView = {
        let playLoadingMenuView = ZHNplayerUrlLoadingBackView()
        return playLoadingMenuView
    }()
    
    lazy var livePlayNormalMenu: ZHNlivePlayNoramlMenuView = {
        let livePlayNormalMenu = ZHNlivePlayNoramlMenuView()
        livePlayNormalMenu.isHidden = true
        return livePlayNormalMenu
    }()
    
    lazy var livePlayFullScreenMenuView: ZHNlivePlayFullScreenMenuView = {
        let livePlayFullScreenMenuView = ZHNlivePlayFullScreenMenuView()
        livePlayFullScreenMenuView.isHidden = true
        return livePlayFullScreenMenuView
    }()
    
    lazy var loadingProgressView: ZHNloadingProgressView = {
        let loadingProgressView = ZHNloadingProgressView()
        loadingProgressView.isHidden = true
        return loadingProgressView
    }()
    // MARK: - 属性设置
    var liveString: String? {
        didSet{
            guard let liveString = liveString else {return}
            if player == nil {
                IJKFFMoviePlayerController.setLogReport(false)
                IJKFFMoviePlayerController.setLogLevel(k_IJK_LOG_ERROR)
                IJKFFMoviePlayerController.checkIfFFmpegVersionMatch(true)
                let options = IJKFFOptions.byDefault()
                let tempPlayer = IJKFFMoviePlayerController(contentURLString: liveString, with: options)
                tempPlayer?.scalingMode = .aspectFit
                tempPlayer?.shouldAutoplay = true
                tempPlayer?.view.isUserInteractionEnabled = false
                player = tempPlayer
            }
        }
    }
    
    var player: IJKFFMoviePlayerController?
    

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        /// 1. 初始化ui
        setupUI()
        /// 2. 初始化通知
        installNotification()
        /// 3. 初始化action的model
        installActionModels()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.shared.isStatusBarHidden = false
        player?.shutdown()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        player?.prepareToPlay()
        // 只是单纯的做了一个展示的效果
        DispatchQueue.afer(time: 0.3) { 
            self.playLoadingMenuView.noticeTableView.scrollToBottom()
        }
    }
    
    deinit {
        println("player ---------------------------------------- 被销毁了")
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
}


//======================================================================
// MARK:- 私有方法
//======================================================================
extension ZHNbilibiliLivePlayerViewController {

    fileprivate func setupUI() {
        windowRoteImage = #imageLiteral(resourceName: "home_rotate_window")
        view.backgroundColor = UIColor.white
        
        view.addSubview(liveContainerView)
        liveContainerView.frame = CGRect(x: 0, y: 0, width: kscreenWidth, height: knormalPlayerHeight)
        
        guard let playerView = player?.view else {return}
        liveContainerView.addSubview(playerView)
        player?.view.snp.makeConstraints({ (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        })
        
        liveContainerView.addSubview(bilibiliLiveIcon)
        bilibiliLiveIcon.snp.makeConstraints { (make) in
            make.left.equalTo(liveContainerView.snp.left).offset(20)
            make.top.equalTo(liveContainerView.snp.top)
            make.size.equalTo(CGSize(width: 60, height: 40))
        }
        
        liveContainerView.addSubview(livePlayNormalMenu)
        livePlayNormalMenu.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        liveContainerView.addSubview(livePlayFullScreenMenuView)
        livePlayFullScreenMenuView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        liveContainerView.addSubview(loadingProgressView)
        loadingProgressView.snp.makeConstraints { (make) in
            make.centerY.equalTo(liveContainerView)
            make.left.equalTo(liveContainerView)
            make.size.equalTo(CGSize(width: 130, height: 20))
        }
        
        liveContainerView.addSubview(playLoadingMenuView)
        playLoadingMenuView.backgroundColor = kHomeBackColor
        playLoadingMenuView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    fileprivate func installNotification() {
        // 1. 监听url的加载状态
        NotificationCenter.default.addObserver(self, selector: #selector(loadStatedChanged(notification:)), name: NSNotification.Name.IJKMPMoviePlayerLoadStateDidChange, object: nil)
        
        // 2. 监听全屏按钮的点击
        NotificationCenter.default.addObserver(self, selector: #selector(fullScreenAction), name: kfullscreenActionNotification, object: nil)
        
        // 3. 监听是否准备开始播放了
        NotificationCenter.default.addObserver(self, selector: #selector(firstLoadSuccess(notification:)), name: NSNotification.Name.IJKMPMediaPlaybackIsPreparedToPlayDidChange, object: nil)
        
    }
    
    fileprivate func installActionModels() {
        // 1
        loadingActionModel.currentViewController = self
        playLoadingMenuView.delegate = loadingActionModel
        // 2
        liveplayNormalActionModel.currentViewController = self
        livePlayNormalMenu.delegate = liveplayNormalActionModel
        // 3
        liveplayFullScreenActionModel.currentViewController = self
        livePlayFullScreenMenuView.delegate = liveplayFullScreenActionModel
    }
    
    
}

//======================================================================
// MARK:- 公开方法
//======================================================================
extension ZHNbilibiliLivePlayerViewController {
    
    func resignFullScreen() {
        
        isfullScreen = false
        // 1. 旋转statusbar
        UIApplication.shared.statusBarOrientation = UIInterfaceOrientation.portrait
        // 2. 动画view
        var captureImage = player?.thumbnailImageAtCurrentTime()
        if (windowRoteImage != nil) {
            captureImage = windowRoteImage
        }
        let animationImageView = UIImageView()
        animationImageView.contentMode = .scaleAspectFit
        animationImageView.image = captureImage
        view.addSubview(animationImageView)
        animationImageView.frame = CGRect(x: (kscreenWidth - kscreenHeight)/2, y: (kscreenHeight - kscreenWidth)/2, width: kscreenHeight, height: kscreenWidth)
        animationImageView.transform = animationImageView.transform.rotated(by: CGFloat(M_PI_2))
        // 3. 还原player的位置
        self.liveContainerView.transform = CGAffineTransform.identity
        self.liveContainerView.frame = CGRect(x: 0, y: 0, width: kscreenWidth, height: knormalPlayerHeight)
        // 4. 动画
        UIView.animate(withDuration: 0.3, animations: {
            animationImageView.transform = CGAffineTransform.identity
            animationImageView.frame = CGRect(x: 0, y: 0, width: kscreenWidth, height: knormalPlayerHeight)
            }) { (complete) in
                DispatchQueue.afer(time: 0.1, action: {
                    animationImageView.removeFromSuperview()
                    // 切换menu
                    self.livePlayFullScreenMenuView.isHidden = true
                    self.livePlayNormalMenu.isHidden = false
                })
        }
    }
}

//======================================================================
// MARK:- notification 方法
//======================================================================
extension ZHNbilibiliLivePlayerViewController {
    
    
    @objc fileprivate func firstLoadSuccess(notification:Notification) {
        if isfullScreen {
            livePlayFullScreenMenuView.isHidden = false
            livePlayFullScreenMenuView.animateTimer?.start()
            playLoadingMenuView.isHidden = true
        }else {
            livePlayNormalMenu.isHidden = false
            livePlayNormalMenu.animateTimer?.start()
            playLoadingMenuView.isHidden = true
        }
        windowRoteImage = nil
    }
    
    @objc fileprivate func loadStatedChanged(notification:Notification) {
        guard let mpPlayer = notification.object as? IJKFFMoviePlayerController else {return}
        let loadState = mpPlayer.loadState
        
//        /// 1. 缓冲中 (在直播的情况下)
//        if loadState.rawValue == 4 {
//            loadingProgressView.isHidden = false
//            loadingProgressView.startRotaing()
//            updataTimer = SwiftTimer(interval: .milliseconds(500), repeats: true, queue: DispatchQueue.main, handler: { [weak self] (timer) in
//                guard let bufferingProgress = self?.player?.bufferingProgress else {return}
//                self?.loadingProgressView.progress = bufferingProgress
//                })
//            updataTimer?.start()
//            
//            ///2. 缓冲结束的情况下
//        } else if loadState.rawValue == 3 {
//            loadingProgressView.isHidden = true
//            loadingProgressView.progress = 0
//            loadingProgressView.endRotaing()
//            updataTimer = nil
//        }
        
        /// 1. 缓冲中 (在直播的情况下)
        if loadState == IJKMPMovieLoadState.stalled {
            loadingProgressView.isHidden = false
            loadingProgressView.startRotaing()
            updataTimer = SwiftTimer(interval: .milliseconds(500), repeats: true, queue: DispatchQueue.main, handler: { [weak self] (timer) in
                guard let bufferingProgress = self?.player?.bufferingProgress else {return}
                if ZHNnetWorkTypeHelper.netWorkType() == .NONETWORK {
                    self?.loadingProgressView.progress = 0
                }else {
                    if loadState.rawValue == 3 {
                        self?.loadingProgressView.isHidden = true
                        self?.loadingProgressView.progress = 0
                        self?.loadingProgressView.endRotaing()
                        self?.updataTimer = nil
                    }else {
                        self?.loadingProgressView.progress = bufferingProgress
                    }
                }
            })
            updataTimer?.start()
            
            ///2. 缓冲结束的情况下
        } else if loadState == IJKMPMovieLoadState.playthroughOK || loadState == IJKMPMovieLoadState.playable {
            loadingProgressView.isHidden = true
            loadingProgressView.progress = 0
            loadingProgressView.endRotaing()
            updataTimer = nil
        }
    }
    
    @objc fileprivate func fullScreenAction() {
        
        isfullScreen = true
        
        // 1. 旋转statusbar
        UIApplication.shared.statusBarOrientation = UIInterfaceOrientation.landscapeRight
        // 2. 一个遮罩为了显示的效果更好
        let maskImageView = UIImageView()
        maskImageView.backgroundColor = UIColor.black
        view.addSubview(maskImageView)
        maskImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        // 3. 做旋转动画的imageview
        var captureImage = player?.thumbnailImageAtCurrentTime()
        if (windowRoteImage != nil) {
            captureImage = windowRoteImage
        }
        let animationImageView = UIImageView()
        animationImageView.contentMode = .scaleAspectFit
        animationImageView.image = captureImage
        view.addSubview(animationImageView)
        animationImageView.frame = CGRect(x: 0, y: 0, width: kscreenWidth, height: knormalPlayerHeight)
        // 4. 做选择动画
        UIView.animate(withDuration: 0.3, animations: {
            // <1. 旋转
            animationImageView.transform = animationImageView.transform.rotated(by: CGFloat(M_PI_2))
            // <2. 位移
            animationImageView.frame = CGRect(x: 0, y: 0, width: kscreenWidth, height: kscreenHeight)
        }) { (complete) in
            
            DispatchQueue.afer(time: 0.1, action: {
                // <1. 先设置位置（位置需要稍微计算一下）
                self.liveContainerView.frame = CGRect(x: (kscreenWidth - kscreenHeight)/2, y: (kscreenHeight - kscreenWidth)/2, width: kscreenHeight, height: kscreenWidth)
                // <2. 再旋转过来
                self.liveContainerView.transform = self.liveContainerView.transform.rotated(by: CGFloat(M_PI_2))
                // <3. 移除
                animationImageView.removeFromSuperview()
                maskImageView.removeFromSuperview()
                // <4. 默认选择了statusbar的时候statusbar的hidden是yes
                UIApplication.shared.isStatusBarHidden = false
                // <5. 切换menu
                self.livePlayFullScreenMenuView.isHidden = false
                self.livePlayNormalMenu.isHidden = true
            })
        }
    }
    
    
}







