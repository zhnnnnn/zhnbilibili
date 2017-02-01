//
//  HomeViewController.swift
//  zhnbilibili
//
//  Created by zhn on 16/11/21.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

/// 点击了各个轮播的通知
///1.直播
let kcarouselViewSelectedLiVENotification = NSNotification.Name(rawValue: "kcarouselViewSelectedLiVENotification")
///2.推荐
let kcarouselViewSelectedRECOMMENDNotification = NSNotification.Name(rawValue: "kcarouselViewSelectedLRECOMMENDNotification")
///3.番剧
let kcarouselViewSelectedBANGUMINotification = NSNotification.Name(rawValue: "kcarouselViewSelectedBANGUMINotification")

let kcarouselSelectedUrlKey = "kcarouselSelectedUrlKey"

class HomeViewController: UIViewController {

    lazy var contentScrollView: UIScrollView = {[unowned self] in
        let contentScrollView = UIScrollView()
        contentScrollView.frame = self.view.bounds
        contentScrollView.contentSize = CGSize(width: self.view.frame.width*3, height: self.view.frame.height)
        contentScrollView.isPagingEnabled = true
        contentScrollView.backgroundColor = knavibarcolor
        return contentScrollView
    }()
    
    lazy var titleMenu: slideMenu = {[unowned self] in
       
        // 1.frame
        let width:CGFloat = 150
        let height:CGFloat = 30
        let x = (self.view.zhnWidth - width)/2
        let y = KtabbarHeight - 26
        let rect = CGRect(x: x, y: y, width: width, height: height)
       
        // 2.平常的颜色
        let normalColor = slideMenu.slideMenuTitleColor(red: 230, green: 230, blue: 230)
        
        // 3.显示的颜色
        let hightLightColor = slideMenu.slideMenuTitleColor(red: 255, green: 255, blue: 255)
        
        // 4.生成slidemenu
        let menu = slideMenu(frame: rect, titles: ["直播","推荐","番剧"], padding: 15, normalColr: normalColor, hightLightColor: hightLightColor, font: 16, sliderColor: UIColor.white, onlyHorizon: false, scrollView: self.contentScrollView, autoPadding: true)

        return menu
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 初始化ui
        setupui()
        
        // 默认选中中间的推荐
        self.contentScrollView.contentOffset = CGPoint(x: kscreenWidth, y: 0)
        
        // 监听通知
        NotificationCenter.default.addObserver(self, selector: #selector(showLive), name: khomeViewControllerShowLIVEnotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//======================================================================
// MARK:- 私有方法
//======================================================================
extension HomeViewController {
    
    fileprivate func setupui(){
        
        view.addSubview(contentScrollView)
        
        view.addSubview(titleMenu)
        
        addChildVCs()
    }
    
    fileprivate func addChildVCs() {
        
        // 1 直播
        let liveVC = HomeLiveShowViewController()
        self.addChildViewController(liveVC)
        contentScrollView.addSubview(liveVC.view)
        liveVC.view.frame = view.bounds
        
        // 2 推荐
        let recommondVC = HomeRecommendViewController()
        self.addChildViewController(recommondVC)
        contentScrollView.addSubview(recommondVC.view)
        recommondVC.view.frame = CGRect(x: view.zhnWidth, y: 0, width: view.zhnWidth, height: view.zhnheight)
        
        // 3 番剧
        let serialVC = HomebangumiViewController()
        self.addChildViewController(serialVC)
        contentScrollView.addSubview(serialVC.view)
        serialVC.view.frame = CGRect(x: view.zhnWidth*2, y: 0, width: view.zhnWidth, height: view.zhnheight)
    }
}

//======================================================================
// MARK:- notification
//======================================================================
extension HomeViewController {
    @objc func showLive() {
        DispatchQueue.main.async {
          self.contentScrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: kscreenWidth, height: 100), animated: false)
        }
    }
}

