//
//  ZHNPlayerBaseViewController.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/12.
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

class ZHNPlayerBaseViewController: UIViewController {
    
    var currentTypeWindowMenuView: ZHNplayerMenuBaseView?
    var currentTypeFullscreenMenuView: ZHNplayerMenuBaseView?
    
    /// 缓冲数据的时候的timer
    var updataTimer: SwiftTimer?
    /// 加载播放器加载数据的timer
    var sliderStatusTimer: SwiftTimer?
    /// 是否是全屏状态
    var isfullScreen = false
    /// 全屏window切换的时候的展示的view
    var windowRoteImage: UIImage?
    /// 判断是否是普通播放器 (需要在super.viewdidload 之后调用)
    var isNormalPlayer = false {
        didSet{
            if isNormalPlayer {
                currentTypeWindowMenuView = normalPlayerWindowMenuView
                currentTypeFullscreenMenuView = normalPlayerFullScreenMenuView
                bilibiliLiveIcon.isHidden = true
            }
        }
    }
    
    var titleString: String? {
        didSet{
            normalPlayerWindowMenuView.titleLabel.text = titleString!
            normalPlayerFullScreenMenuView.topMenu.titleLabel.text = titleString!
        }
    }
    // MARK: - 所有的action的封装
    // 1. 视频加载时候的menu的action
    var loadingActionModel: ZHNplayerUrlLoadingBackViewActionModel = ZHNplayerUrlLoadingBackViewActionModel()
    // 2. 直播的视频播放的menu的action
    var liveplayNormalActionModel: ZHNplayNormalMenuViewActionModel = ZHNplayNormalMenuViewActionModel()
    // 3. 直播的视频播放的全屏时候的action
    var liveplayFullScreenActionModel: ZHNplayFullScreenMenuViewActionModel = ZHNplayFullScreenMenuViewActionModel()
    // 4. 播放正常情况下的视频的全屏时候的action
    var normalPlayerFullScreenActionModel: ZHNnormalPlayerFullScreenActionModel = ZHNnormalPlayerFullScreenActionModel()
    
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
    
    lazy var danmuView: ZHNdanmuView = {
        let danmuView = ZHNdanmuView()
        return danmuView
    }()
    
    lazy var normalPlayerWindowMenuView: ZHNnormalPlayWindowMenuVIew = {
        let normalPlayerWindowMenuView = ZHNnormalPlayWindowMenuVIew()
        normalPlayerWindowMenuView.restartTimerAction = { [weak self] in
            self?.addSliderStatusTimer()
        }
        normalPlayerWindowMenuView.seekTimeSlider.addTarget(self, action: #selector(sliderTouchUpInside(slider:)), for: .touchUpInside)
        normalPlayerWindowMenuView.seekTimeSlider.addTarget(self, action: #selector(sliderTouchDown(slider:)), for: .touchDown)
        normalPlayerWindowMenuView.seekTimeSlider.addTarget(self, action: #selector(sliderValudeChanged(slider:)), for: .valueChanged)
        normalPlayerWindowMenuView.seekTimeSlider.addTarget(self, action: #selector(sliderTouchOutSide(slider:)), for: .touchUpOutside)
        normalPlayerWindowMenuView.seekTimeSlider.addTarget(self, action: #selector(sliderTouchCancle(slider:)), for: .touchCancel)
        normalPlayerWindowMenuView.isHidden = true
        return normalPlayerWindowMenuView
    }()
    
    lazy var normalPlayerFullScreenMenuView: ZHNnormalPlayFullScreenMenuView = {
        let normalPlayerFullScreenMenuView = ZHNnormalPlayFullScreenMenuView()
        normalPlayerFullScreenMenuView.bottomMenu.seekTimeSlider.addTarget(self, action: #selector(sliderTouchUpInside(slider:)), for: .touchUpInside)
        normalPlayerFullScreenMenuView.bottomMenu.seekTimeSlider.addTarget(self, action: #selector(sliderTouchDown(slider:)), for: .touchDown)
        normalPlayerFullScreenMenuView.bottomMenu.seekTimeSlider.addTarget(self, action: #selector(sliderValudeChanged(slider:)), for: .valueChanged)
        normalPlayerFullScreenMenuView.bottomMenu.seekTimeSlider.addTarget(self, action: #selector(sliderTouchOutSide(slider:)), for: .touchUpOutside)
        normalPlayerFullScreenMenuView.bottomMenu.seekTimeSlider.addTarget(self, action: #selector(sliderTouchCancle(slider:)), for: .touchCancel)
        normalPlayerFullScreenMenuView.isHidden = true
        return normalPlayerFullScreenMenuView
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
                tempPlayer?.setPauseInBackground(true)
                tempPlayer?.view.isUserInteractionEnabled = false
                player = tempPlayer
            }
            
            setupUI()
        }
    }
    
    var player: IJKFFMoviePlayerController?
    
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        /// 1. 初始化ui
//        setupUI()
        /// 2. 初始化通知
        installNotification()
        /// 3. 初始化action的model
        installActionModels()
        /// 4. 不同类型的player的menu的初始化
        initMenuType()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.shared.isStatusBarHidden = false
//        player?.shutdown()
        player?.pause()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        player?.play()
    }
    
    deinit {
        println("player ---------------------------------------- 被销毁了")
        player?.shutdown()
        NotificationCenter.default.removeObserver(self)
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
}

//======================================================================
// MARK:- 私有方法
//======================================================================
extension ZHNPlayerBaseViewController {
    
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
        
        liveContainerView.addSubview(danmuView)
        danmuView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
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
        
        liveContainerView.addSubview(normalPlayerWindowMenuView)
        normalPlayerWindowMenuView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        liveContainerView.addSubview(livePlayFullScreenMenuView)
        livePlayFullScreenMenuView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        liveContainerView.addSubview(normalPlayerFullScreenMenuView)
        normalPlayerFullScreenMenuView.snp.makeConstraints { (make) in
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

        // 4. 监听app进入后台，（暂停播放）
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackGround), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
       
        // 5. 监听播放的状态
        NotificationCenter.default.addObserver(self, selector: #selector(playerBackStateDidChange(notification:)), name: NSNotification.Name.IJKMPMoviePlayerPlaybackStateDidChange, object: nil)
    }
    
    fileprivate func installActionModels() {
        // 1
        loadingActionModel.currentViewController = self
        playLoadingMenuView.delegate = loadingActionModel
        // 2
        liveplayNormalActionModel.currentViewController = self
        livePlayNormalMenu.delegate = liveplayNormalActionModel
        normalPlayerWindowMenuView.delegate = liveplayNormalActionModel
        // 3
        liveplayFullScreenActionModel.currentViewController = self
        livePlayFullScreenMenuView.delegate = liveplayFullScreenActionModel
        // 4.
        normalPlayerFullScreenActionModel.currentViewController = self
        normalPlayerFullScreenMenuView.delegate = normalPlayerFullScreenActionModel
    }
    
    fileprivate func initMenuType() {
        currentTypeWindowMenuView =  livePlayNormalMenu
        currentTypeFullscreenMenuView = livePlayFullScreenMenuView
    }
    
    fileprivate func addSliderStatusTimer() {
        if sliderStatusTimer !=  nil {
            sliderStatusTimer = nil
        }
        sliderStatusTimer = SwiftTimer(interval: .seconds(1), repeats: true, queue: DispatchQueue.main, handler: { [weak self] (timer) in
            // 1.拿到数据
            guard let currentPlaybacktime = self?.player?.currentPlaybackTime else {return}
            guard let duration = self?.player?.duration else {return}
            guard let playableTime = self?.player?.playableDuration else {return}
            // 2. label
            self?.normalPlayerWindowMenuView.currentTimeLabel.text = currentPlaybacktime.timeString()
            self?.normalPlayerFullScreenMenuView.bottomMenu.currentTimeLabel.text = currentPlaybacktime.timeString()
            // 3. slider
            let sliderPercent = currentPlaybacktime/duration
            self?.normalPlayerWindowMenuView.seekTimeSlider.value = Float(sliderPercent)
            self?.normalPlayerFullScreenMenuView.bottomMenu.seekTimeSlider.value = Float(sliderPercent)
            // 4. progress
            let progressPercent = playableTime/duration
            self?.normalPlayerWindowMenuView.seekedTimeProgress.progress = Float(progressPercent)
            self?.normalPlayerFullScreenMenuView.bottomMenu.seekedTimeProgress.progress = Float(progressPercent)
            // 5. 屏幕地下的progressview
            self?.normalPlayerWindowMenuView.currentMarkProgressView.progress = Float(sliderPercent)
            })
        
            sliderStatusTimer?.start()
    }
    
    fileprivate func sliderTouchEnd(slider: UISlider){
        addSliderStatusTimer()
        guard let duration = player?.duration else {return}
        let currentTime = duration * TimeInterval(slider.value)
        player?.currentPlaybackTime = currentTime
    }
}

//======================================================================
// MARK:- 公开方法
//======================================================================
extension ZHNPlayerBaseViewController {
    
    func resignFullScreen() {
        
        addSliderStatusTimer()
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
                self.currentTypeFullscreenMenuView?.isHidden = true
                self.currentTypeWindowMenuView?.isHidden = false
            })
        }
    }
    
    func loadPlayer() {
        player?.prepareToPlay()
        // 只是单纯的做了一个展示的效果
        DispatchQueue.afer(time: 0.3) {
            self.playLoadingMenuView.noticeTableView.scrollToBottom()
        }
    }
}

//======================================================================
// MARK:- notification 方法
//======================================================================
extension ZHNPlayerBaseViewController {
    
    @objc func firstLoadSuccess(notification:Notification) {
        
        // 1. 视频信息的加载
        if let currentPlaybacktimer = player?.currentPlaybackTime {
            normalPlayerWindowMenuView.currentTimeLabel.text = currentPlaybacktimer.timeString()
        }
        if let duration = player?.duration {
            normalPlayerWindowMenuView.fullTimeLabel.text = duration.timeString()
            normalPlayerFullScreenMenuView.bottomMenu.fullTimeLabel.text = duration.timeString()
        }
        
        if isNormalPlayer {
            sliderStatusTimer = SwiftTimer(interval: .seconds(1), repeats: true, queue: DispatchQueue.main, handler: { [weak self] (timer) in
                // 1.拿到数据
                guard let currentPlaybacktime = self?.player?.currentPlaybackTime else {return}
                guard let duration = self?.player?.duration else {return}
                guard let playableTime = self?.player?.playableDuration else {return}
                // 2. label
                self?.normalPlayerWindowMenuView.currentTimeLabel.text = currentPlaybacktime.timeString()
                // 3. slider
                let sliderPercent = currentPlaybacktime/duration
                self?.normalPlayerWindowMenuView.seekTimeSlider.value = Float(sliderPercent)
                // 4. progress
                let progressPercent = playableTime/duration
                self?.normalPlayerWindowMenuView.seekedTimeProgress.progress = Float(progressPercent)
            })
            sliderStatusTimer?.start()
        }
        
        // 2. 切换menu
        if isfullScreen {
            currentTypeFullscreenMenuView?.isHidden = false
            currentTypeFullscreenMenuView?.animateTimer?.start()
            playLoadingMenuView.isHidden = true
        }else {
            currentTypeWindowMenuView?.isHidden = false
            currentTypeWindowMenuView?.animateTimer?.start()
            playLoadingMenuView.isHidden = true
        }
        windowRoteImage = nil
        addSliderStatusTimer()
    }
    
    @objc func loadStatedChanged(notification:Notification) {
        guard let mpPlayer = notification.object as? IJKFFMoviePlayerController else {return}
        let loadState = mpPlayer.loadState
        
        loadingProgressView.isHidden = true
        loadingProgressView.progress = 0
        loadingProgressView.endRotaing()
        updataTimer = nil
        
        /// 1. 缓冲中 (在直播的情况下)
        if loadState == IJKMPMovieLoadState.stalled {
            loadingProgressView.isHidden = false
            loadingProgressView.startRotaing()
            updataTimer = SwiftTimer(interval: .milliseconds(500), repeats: true, queue: DispatchQueue.main, handler: { [weak self] (timer) in
                guard let bufferingProgress = self?.player?.bufferingProgress else {return}
                self?.loadingProgressView.progress = bufferingProgress
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
    
    @objc func playerBackStateDidChange(notification:Notification) {
        
    }
    
    @objc func fullScreenAction() {
        sliderStatusTimer = nil
        addSliderStatusTimer()
        isfullScreen = true
        
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
                self.currentTypeFullscreenMenuView?.isHidden = false
                self.currentTypeWindowMenuView?.isHidden = true
                // <6. 添加timer
                self.addSliderStatusTimer()
                self.currentTypeFullscreenMenuView?.addTimer(needStart: true)
            })
        }
    }
    
    @objc func appDidEnterBackGround() {
        normalPlayerWindowMenuView.pauseAction()
        livePlayNormalMenu.pauseAction()
    }
    
}

//======================================================================
// MARK:- target action
//======================================================================
extension ZHNPlayerBaseViewController {

    // slider的值改变
    @objc fileprivate func sliderValudeChanged(slider: UISlider){
        guard let duration = player?.duration else {return}
        let toTime = duration * TimeInterval(slider.value)
        normalPlayerWindowMenuView.currentTimeLabel.text = toTime.timeString()
        normalPlayerFullScreenMenuView.bottomMenu.currentTimeLabel.text = toTime.timeString()
    }
    // slider 结束拖动
    @objc fileprivate func sliderTouchOutSide(slider: UISlider) {
        sliderTouchEnd(slider: slider)
    }

    @objc fileprivate func sliderTouchUpInside(slider: UISlider) {
        sliderTouchEnd(slider: slider)
    }
    
    @objc fileprivate func sliderTouchCancle(slider: UISlider) {
        sliderTouchEnd(slider: slider)
    }
    // slider 开始拖动
    @objc fileprivate func sliderTouchDown(slider: UISlider) {
        sliderStatusTimer = nil
    }
}


