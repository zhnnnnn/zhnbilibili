//
//  ZHNnormalPlayerViewController.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/12.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

/// 最多只能有一个播放器 当开始播放的时候需要关掉之前的播放器
let KplayingPlayerNeedToShutDownNotification = Notification.Name("KplayingPlayerNeedToShutDownNotification")

/// 一些常量
let knavibarheight: CGFloat = 64
let kinputDanmuHeight: CGFloat = 40
fileprivate let kslideMenuViewHeight: CGFloat = 30

class ZHNnormalPlayerViewController: ZHNPlayerBaseViewController {

    // MARK - 属性
    /// 数据的模型
    var itemModel: itemDetailModel?
    /// 判断是否需要滑动的效果
    var watced = false
    /// viewmodel
    var playItemVM: ZHNnormalPlayerViewModel = ZHNnormalPlayerViewModel()
    /// 滑动切换播放时间的提示view
    var noticeView: ZHNforwardBackforwardNoticeView?
    /// 输入框是否正在展示
    var isinputShowing = false
    /// （是否需要直接pop掉控制器，如果player被shutdown的情况下需要pop掉）
    var isNeedDisapper = false
    // MARK: - 懒加载控件
    lazy var contentScrollView: UIScrollView = {[weak self] in
        let contentScrollView = UIScrollView()
        contentScrollView.contentSize = CGSize(width: kscreenWidth*2, height:1)
        contentScrollView.isPagingEnabled = true
        contentScrollView.bounces = false
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.panGestureRecognizer.require(toFail: (self?.navigationController?.interactivePopGestureRecognizer)!)
        return contentScrollView
    }()
    lazy var detailController: ZHNnormalPlayerDetailTableViewController = {
        let detailController = ZHNnormalPlayerDetailTableViewController()
        detailController.delegate = self
        return detailController
    }()
    lazy var commondController: ZHNnormalPlayerCommondTableViewController = {[weak self] in
        let commondController = ZHNnormalPlayerCommondTableViewController()
        if let aid = self?.itemModel?.param{
            commondController.aid = aid
        }
        return commondController
    }()
    lazy var slideMenuContainer: UIView = {
        let slideMenuContainer = UIView()
        slideMenuContainer.backgroundColor = UIColor.white
        return slideMenuContainer
    }()
    lazy var blurView: playerBlurView = {
        let blurView = playerBlurView()
        // 1. 背景的图片
        blurView.blurImageString = self.itemModel?.cover
        // 2. 返回按钮的事件
        blurView.backButtonAction = {[weak self] in
            _ = self?.navigationController?.popViewController(animated: true)
        }
        // 3. 屏幕的点击事件
        blurView.tapAction = {[weak self] in
            self?.pLoadPlay()
            ZHNnotificationHelper.shutDownOldPlayer()
        }
        return blurView
    }()
    lazy var slideMenuView: slideMenu = {[unowned self] in
        // 1.frame
        let width:CGFloat = 220
        let height:CGFloat = 30
        let x = (self.view.zhnWidth - width)/2
        let y = kslideMenuViewHeight - 26
        let rect = CGRect(x: x, y: y, width: width, height: height)
        // 2.平常的颜色
        let normalColor = slideMenu.slideMenuTitleColor(red: 198, green: 198, blue: 198)
        // 3.显示的颜色
        let hightLightColor = slideMenu.slideMenuTitleColor(red: 252, green: 132, blue: 164)
        // 4.生成slidemenu
        let menu = slideMenu(frame: rect, titles: [" 简介        "," 评论        "], padding: 15, normalColr: normalColor, hightLightColor: hightLightColor, font: 16, sliderColor: knavibarcolor, onlyHorizon: false, scrollView: self.contentScrollView, autoPadding: true)
        return menu
    }()
    lazy var loadingMaskView: normalPlayerLoadingMaskView = {
        let loadingMaskView = normalPlayerLoadingMaskView()
        loadingMaskView.backButtonAction = {[weak self] in
            _ = self?.navigationController?.popViewController(animated: true)
        }
        return loadingMaskView
    }()
    
    // MARK: - life cycle
    override func viewDidLoad() {
        
        // 1. 初始化ui
        setupUI()
        // 2. 监听滑动
        observeTableViewScroll()
        // 3. 调用父类方法
        super.viewDidLoad()
        // 4. 是否是普通播放器（默认是直播播放器）
        self.isNormalPlayer = true
        // 5. 需要先将播放器隐藏
        liveContainerView.isHidden = true
        // 6. 加载数据
        requestData(aid: (itemModel?.param)!,finishAction: {})
        // 7. 加载通知
        addNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.clearAllNotice()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isNeedDisapper {
            _ = navigationController?.popViewController(animated: false)
        }
    }
    
    
    deinit {
        removeAllobserve()
    }
    
    // MARK - 重写父类方法
    override func firstLoadSuccess(notification: Notification) {
        super.firstLoadSuccess(notification: notification)
        // 传递一个player给弹幕view，这样弹幕的现实能够和播放的进度匹配
        DispatchQueue.main.async {
            self.danmuView.player = self.player
        }
    }
}

//======================================================================
// MARK:- 私有方法
//======================================================================
extension ZHNnormalPlayerViewController {
    fileprivate func setupUI() {
        self.addChildViewController(detailController)
        self.addChildViewController(commondController)
        view.addSubview(contentScrollView)
        view.addSubview(slideMenuContainer)
        contentScrollView.addSubview(detailController.view)
        contentScrollView.addSubview(commondController.view)
        slideMenuContainer.addSubview(slideMenuView)
        view.addSubview(blurView)
        view.addSubview(loadingMaskView)
        
        contentScrollView.frame = CGRect(x: 0, y: knormalPlayerHeight+kslideMenuViewHeight, width: kscreenWidth, height: kscreenHeight - knavibarheight-kslideMenuViewHeight)
        detailController.view.frame = CGRect(x: 0, y: -20, width: kscreenWidth, height: contentScrollView.zhnheight)
        commondController.view.frame = CGRect(x: kscreenWidth, y: -20, width: kscreenWidth, height: contentScrollView.zhnheight)
        slideMenuContainer.frame = CGRect(x: 0, y: knormalPlayerHeight, width: kscreenWidth, height: kslideMenuViewHeight)
        blurView.frame = CGRect(x: 0, y: 0, width: kscreenWidth, height: knormalPlayerHeight)
        loadingMaskView.frame = view.bounds
    }
    
    fileprivate func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(swipeToChangingPlayTime(notification:)), name: kSwipeScreenToChangePlayTimeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(swipeEnd(notification:)), name: kSwipeScreenEndNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(swipeStart(notification:)), name: kSwipeScrrenBeginNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(shutDownPlayer), name: KplayingPlayerNeedToShutDownNotification, object: nil)
    }
    
    fileprivate func observeTableViewScroll() {
        detailController.tableView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
        commondController.tableView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    fileprivate func removeAllobserve() {
        detailController.tableView.removeObserver(self, forKeyPath: "contentOffset",context: nil)
        commondController.tableView.removeObserver(self, forKeyPath: "contentOffset",context: nil)
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func addInputView() {
        let inputView = UIView()
        inputView.backgroundColor = UIColor.black
        isinputShowing = true
        view.insertSubview(inputView, belowSubview: liveContainerView)
        inputView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(slideMenuContainer.snp.top)
            make.height.equalTo(kinputDanmuHeight)
        }
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(named: "misc_avatarDefault")
        iconImageView.layer.cornerRadius = 12
        iconImageView.clipsToBounds = true
        inputView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.left.equalTo(inputView).offset(20)
            make.centerY.equalTo(inputView)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        let noticeLabel = UILabel()
        noticeLabel.text = "输入弹幕"
        noticeLabel.backgroundColor = UIColor.darkGray
        noticeLabel.textColor = UIColor.lightGray
        noticeLabel.textAlignment = .center
        noticeLabel.layer.cornerRadius = 13
        noticeLabel.font = UIFont.systemFont(ofSize: 13)
        noticeLabel.clipsToBounds = true
        inputView.addSubview(noticeLabel)
        noticeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(inputView)
            make.height.equalTo(26)
            make.left.equalTo(iconImageView.snp.right).offset(40)
            make.right.equalTo(inputView.snp.right).offset(-40)
        }
    }
    
    fileprivate func pLoadPlay() {
        // <<1. 视频上的处理
        blurView.isHidden = true
        self.liveContainerView.isHidden = false
        if let playerurl = self.playItemVM.playerUrl {
            self.liveString = playerurl
        }
        self.loadPlayer()
        self.watced = true
        // <<2. 简介评论的处理
        self.slideMenuContainer.setY(Y: knormalPlayerHeight + kinputDanmuHeight)
        self.contentScrollView.setY(Y: knormalPlayerHeight + kinputDanmuHeight + kslideMenuViewHeight)
        self.detailController.view.setHeight(H: kscreenHeight - kinputDanmuHeight - kslideMenuViewHeight - knormalPlayerHeight)
        self.commondController.view.setHeight(H: kscreenHeight - kinputDanmuHeight - kslideMenuViewHeight - knormalPlayerHeight)
        self.detailController.tableView.contentInset = UIEdgeInsets.zero
        self.commondController.tableView.contentInset = UIEdgeInsets.zero
        self.detailController.watched = watced
        self.addInputView()
    }
    
    fileprivate func requestData(aid: Int,finishAction:@escaping (()->Void)) {
        self.danmuView.endRender()
        self.danmuView.startRender()
        playItemVM.requestData(aid: aid, finishCallBack: { [weak self] in
            DispatchQueue.main.async {
                self?.titleString = self?.playItemVM.detailModel?.title
                self?.loadingMaskView.removeFromSuperview()
                self?.danmuView.danmuModelArray = self?.playItemVM.danmuModelArray
                self?.detailController.detailModel = self?.playItemVM.detailModel
                self?.blurView.titleLabel.text = "AV\((self?.itemModel?.param)!)"
                self?.clearAllNotice()
                if let urlStr = self?.playItemVM.detailModel?.pic {
                    let url = URL(string: urlStr)
                    self?.blurView.backImageView.sd_setImage(with: url)
                    self?.blurView.backImageView.sd_setImage(with: url, completed: { (image, error, type, url) in
                        self?.blurView.percent = 0.999
                    })
                }
        
                self?.detailController.tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .bottom, animated: true)
                finishAction()
            }
        }) {
        }
    }
}

//======================================================================
// MARK:- kvo 和 通知
//======================================================================
extension ZHNnormalPlayerViewController {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // 1. 滑动
        if keyPath == "contentOffset" {
            if watced {return}
            // <1. 拿到滑动的offset
            guard let NSoffset = change?[NSKeyValueChangeKey.newKey] else {return}
            guard let CGoffset  = (NSoffset as AnyObject).cgPointValue else {return}
            // <2. 计算值(考虑边界的值)
            var delta = knormalPlayerHeight - CGoffset.y * 0.5
            if delta < knavibarheight {
                delta = knavibarheight
            }else if delta > knormalPlayerHeight {
                delta = knormalPlayerHeight
            }
            // <3. 滑动控件
                //<<1. blur 不会因为增加了输入view而改变
            blurView.percent = (delta - knavibarheight)/(knormalPlayerHeight-knavibarheight)
            blurView.setHeight(H: delta)
                //<<2. slidemenu 和地下的view会随着改变
            if isinputShowing {
                delta = delta + kinputDanmuHeight
            }
            slideMenuContainer.setY(Y: delta)
            contentScrollView.setY(Y: delta+kslideMenuViewHeight)
        }
    }
    
    @objc fileprivate func swipeStart(notification: Notification) {
        // 1.生成提示的view
        let noticeView = ZHNforwardBackforwardNoticeView.instanceView()
        noticeView.isHidden = true
        liveContainerView.addSubview(noticeView)
        noticeView.snp.makeConstraints { (make) in
            make.center.equalTo(liveContainerView)
            make.size.equalTo(CGSize(width: 150, height: 110))
        }
        self.noticeView = noticeView
        // 2.赋值一个当前的播放时间
        if let currentPlayBackTime = player?.currentPlaybackTime {
            self.noticeView?.currentPlayTime = currentPlayBackTime
        }
    }
    
    @objc fileprivate func swipeEnd(notification: Notification) {
        guard let needGoTime = noticeView?.needGoingPlayTime else {return}
        if noticeView?.isHidden == false {
            player?.currentPlaybackTime = needGoTime
        }
        noticeView?.removeFromSuperview()
    }
    
    @objc fileprivate func swipeToChangingPlayTime(notification: Notification) {
        noticeView?.isHidden = false
        guard let trans = notification.userInfo?[ktransKey] as? Float else {return}
        if let duration = player?.duration {
            noticeView?.maxPlayTime = duration
        }
        noticeView?.translate = trans
    }
    
    @objc fileprivate func shutDownPlayer() {
        if navigationController?.visibleViewController != self {
            if isinputShowing {
                player?.shutdown()
                isNeedDisapper = true
            }
        }
    }
}


//======================================================================
// MARK:- 各点击事件的响应方法
//======================================================================
extension ZHNnormalPlayerViewController: ZHNnormalPlayerDetailTableViewControllerDelegate {
    func ZHNnormalPlayerDetailTableViewControllerSelectedNewPlay(aid: Int) {
      
        // 切换播放器
        if watced {// 在播放状态下的切换
            self.noticeOnlyText("视频切换中")
            self.detailController.tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .bottom, animated: true)
            
            // 2.加载数据
            requestData(aid: aid,finishAction: {
                
                DispatchQueue.main.async {
                    // 1.清空之前的播放的状态
                    self.player?.shutdown()
                    self.player = nil
                }
                // <1. view的一些初始化
                self.watced = false
                self.detailController.view.frame = CGRect(x: 0, y: -20, width: kscreenWidth, height: kscreenHeight - kinputDanmuHeight - kslideMenuViewHeight - knavibarheight)
                self.commondController.view.frame = CGRect(x: kscreenWidth, y: -20, width: kscreenWidth, height: kscreenHeight - kinputDanmuHeight - kslideMenuViewHeight - knavibarheight)
                self.detailController.detailModel = self.playItemVM.detailModel
                self.blurView.isHidden = false
                self.liveContainerView.isHidden = true
                if let urlStr = self.playItemVM.detailModel?.pic {
                    let url = URL(string: urlStr)
                    self.blurView.backImageView.sd_setImage(with: url, completed: { (image, error, type, url) in
                        self.blurView.percent = 0.999
                    })
                }
                self.playLoadingMenuView.isHidden = false
                // 切换评论
                self.commondController.aid = aid
            })
        }else {// 不在播放状态下的切换
            self.noticeOnlyText("加载数据中")
            requestData(aid: aid, finishAction: {
                //  切换评论
                self.commondController.aid = aid
            })
        }
    }
    
    func ZHNnormalPlayerDetailTableViewControllerSelectedPage(cid: Int,index: Int) {
        self.noticeOnlyText("剧集切换中")
        // 清空之前的播放状态player的关闭要在主线程进行
        self.player?.shutdown()
        self.player = nil
        self.danmuView.endRender()
        self.danmuView.startRender()
        self.detailController.tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .bottom, animated: true)
        playItemVM.requestPagePlayUrl(page: index, cid: cid) { [weak self] in
            self?.clearAllNotice()
            if (self?.watced)! {// 在播放状态下的切换
                // 先加载弹幕
                self?.danmuView.danmuModelArray = self?.playItemVM.danmuModelArray
                // 在加载player
                if let playerurl = self?.playItemVM.playerUrl {
                    self?.liveString = playerurl
                }
                self?.playLoadingMenuView.isHidden = false
                self?.loadPlayer()
            }else {// 不在播放状态下的切换
                self?.pLoadPlay()
            }
        }
    }
    
}







