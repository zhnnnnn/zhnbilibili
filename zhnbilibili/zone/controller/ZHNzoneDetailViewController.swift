//
//  ZHNzoneDetailViewController.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/9.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit

fileprivate let menuOneRowHeight: CGFloat = 30
let kminiPadding: CGFloat = 20
class ZHNzoneDetailViewController: ZHNBaseViewController {

    // MARK - 属性
    // vm
    var zoneDetailVM = ZHNzoneDetailViewModel()
    // zone 数据
    var zoneModel: ZHNzoneModel?
    
    var menuView: slideMenu?
    // MARK - 懒加载控件
    lazy var contentScrollView: UIScrollView = {
        let contentScrollView = UIScrollView()
        contentScrollView.layer.cornerRadius = 10
        contentScrollView.clipsToBounds = true
        contentScrollView.backgroundColor = kHomeBackColor
        return contentScrollView
    }()
    // MARK - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1.加载ui
        setupUI()
        // 2.加载控制器
        initalControllers()
    }
}

//======================================================================
// MARK:- 公开方法
//======================================================================
extension ZHNzoneDetailViewController {
    
}

//======================================================================
// MARK:- 私有方法
//======================================================================
extension ZHNzoneDetailViewController {
    fileprivate func setupUI() {
        // 1.
        view.backgroundColor = knavibarcolor
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        naviBar.isHidden = false
        naviBar.titleLabel.text = zoneModel?.name
        naviBar.backArrowButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
        // 2. 加载scrollView
        let titleArray = ZHNzoneModel.titleArray(zoneArray: (zoneModel?.children)!)
        contentScrollView.frame = CGRect(x: 0, y: (KtabbarHeight + menuOneRowHeight), width: kscreenWidth, height: kscreenHeight - (KtabbarHeight + menuOneRowHeight))
        contentScrollView.contentSize = CGSize(width: kscreenWidth * CGFloat((zoneModel?.children?.count)!), height: 1)
        contentScrollView.isPagingEnabled = true
        view.addSubview(contentScrollView)
        contentScrollView.panGestureRecognizer.require(toFail: (navigationController?.interactivePopGestureRecognizer)!)
        // 3. 加载标题
        // 平常的颜色
        let normalColor = slideMenu.slideMenuTitleColor(red: 230, green: 230, blue: 230)
        // 显示的颜色
        let hightLightColor = slideMenu.slideMenuTitleColor(red: 255, green: 255, blue: 255)
        menuView = slideMenu(frame: CGRect(x: 20, y: KtabbarHeight + 10, width: kscreenWidth-40, height: 30), titles: titleArray, padding: kminiPadding, normalColr: normalColor, hightLightColor: hightLightColor, font: 13, sliderColor: UIColor.white, onlyHorizon: false, scrollView: contentScrollView, autoPadding: true)
        view.addSubview(menuView!)
        
        // 4. menu的高度重新设置一下
        var oldY: CGFloat = 0
        var isOneRow = true
        for sub in (menuView?.subviews)! {
            if oldY != 0 && oldY != sub.frame.origin.y {
                isOneRow = false
                break
            }else {
                oldY = sub.frame.origin.y
            }
        }
        if isOneRow {
            contentScrollView.frame = CGRect(x: 0, y: (KtabbarHeight + menuOneRowHeight) + 5, width: kscreenWidth, height: kscreenHeight - (KtabbarHeight + menuOneRowHeight))
            contentScrollView.contentSize = CGSize(width: kscreenWidth * CGFloat((zoneModel?.children?.count)!), height: 1)
            menuView?.frame = CGRect(x: 20, y: KtabbarHeight + 10, width: kscreenWidth-40, height: 30)
        }else {
            contentScrollView.frame = CGRect(x: 0, y: (KtabbarHeight + menuOneRowHeight * 2) + 5, width: kscreenWidth, height: kscreenHeight - (KtabbarHeight + menuOneRowHeight * 2))
            contentScrollView.contentSize = CGSize(width: kscreenWidth * CGFloat((zoneModel?.children?.count)!), height: 1)
            menuView?.frame = CGRect(x: 20, y: KtabbarHeight + 10, width: kscreenWidth-40, height: 60)
        }
    }
    
    fileprivate func initalControllers() {
        
        guard let count = zoneModel?.children?.count else {return}
        for i in 0..<count{
            let vc = ZHNzoneItemViewController()
            vc.zoneItemModel = zoneModel?.children?[i]
            self.addChildViewController(vc)
            contentScrollView.addSubview(vc.view)
            vc.view.frame = CGRect(x: CGFloat(i) * kscreenWidth, y: -20, width: kscreenWidth, height: kscreenHeight)
        }
    }
}

//======================================================================
// MARK:- target action
//======================================================================
extension ZHNzoneDetailViewController {
    @objc func backAction() {
        _ = navigationController?.popViewController(animated: true)
    }
}

//======================================================================
// MARK:- UIGestureRecognizerDelegate
//======================================================================
extension ZHNzoneDetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

