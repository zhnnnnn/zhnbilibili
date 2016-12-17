//
//  ZHNnormalPlayerViewController.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/12.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

let knavibarheight: CGFloat = 64
fileprivate let kslideMenuViewHeight: CGFloat = 30

class ZHNnormalPlayerViewController: ZHNPlayerBaseViewController {

    /// 数据的模型
    var itemModel: itemDetailModel?
    /// 判断是否需要滑动的效果
    var watced = false
    // viewmodel
    var playItemVM: ZHNnormalPlayerViewModel = ZHNnormalPlayerViewModel()
    
    // MARK: - 懒加载控件
    lazy var contentScrollView: UIScrollView = {
        let contentScrollView = UIScrollView()
        contentScrollView.contentSize = CGSize(width: kscreenWidth*2, height:1)
        contentScrollView.isPagingEnabled = true
        contentScrollView.bounces = false
        contentScrollView.showsHorizontalScrollIndicator = false
        return contentScrollView
    }()
    lazy var detailController: ZHNnormalPlayerDetailTableViewController = {
        let detailController = ZHNnormalPlayerDetailTableViewController()
        return detailController
    }()
    lazy var commondController: ZHNnormalPlayerCommondTableViewController = {
        let commondController = ZHNnormalPlayerCommondTableViewController()
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
            blurView.isHidden = true
            self?.liveContainerView.isHidden = false
            if let playerurl = self?.playItemVM.playerUrl {
                self?.liveString = playerurl
            }
            self?.loadPlayer()
            self?.watced = true
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
       
        // 
        playItemVM.requestData(aid: (itemModel?.param)!, finishCallBack: { 
            DispatchQueue.main.async {
                self.loadingMaskView.removeFromSuperview()
            }
            }) {
        }
        
        
    }
    
    deinit {
        removeAllobserve()
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
    
    fileprivate func observeTableViewScroll() {
        detailController.tableView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
        commondController.tableView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    fileprivate func removeAllobserve() {
        detailController.tableView.removeObserver(self, forKeyPath: "contentOffset",context: nil)
        commondController.tableView.removeObserver(self, forKeyPath: "contentOffset",context: nil)
    }
}

//======================================================================
// MARK:- kvo
//======================================================================
extension ZHNnormalPlayerViewController {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
           
            if watced {return}
            
            // 1. 拿到滑动的offset
            guard let NSoffset = change?[NSKeyValueChangeKey.newKey] else {return}
            guard let CGoffset  = (NSoffset as AnyObject).cgPointValue else {return}
            // 2. 计算值(考虑边界的值)
            var delta = knormalPlayerHeight - CGoffset.y * 0.5
            if delta < knavibarheight {
                delta = knavibarheight
            }else if delta > knormalPlayerHeight {
                delta = knormalPlayerHeight
            }
            // 3. 滑动控件
            slideMenuContainer.setY(Y: delta)
            contentScrollView.setY(Y: delta+kslideMenuViewHeight)
            blurView.setHeight(H: delta)
            blurView.percent = (delta - knavibarheight)/(knormalPlayerHeight-knavibarheight)
        }
    }
}









