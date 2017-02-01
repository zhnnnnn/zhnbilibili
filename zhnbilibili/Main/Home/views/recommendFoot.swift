//
//  recommendFoot.swift
//  zhnbilibili
//
//  Created by zhn on 16/11/23.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

let kfootbuttonHeight: CGFloat = 50
let kfootcarouselViewHeight: CGFloat = 110
let kfootcarouselPadding: CGFloat = 10
let kfootbuttonVpadding: CGFloat = 10

class recommendFoot: UICollectionReusableView {
    
    enum footType {
        
        /// 普通 只有banner
        case normal
        /// 番剧 banner没值
        case bangumi
        /// 番剧 banner 有值
        case bangumiWithBanner
        /// 没有footer
        case none
    }
    
    // MARK: - 属性 set 方法
    var type:footType = .normal{
        
        didSet{
            // 重置状态
            switch type {
            // 普通情况 只有banner
            case .normal:
                
                everydayPushButton.isHidden = true
                bangumiIndexButton.isHidden = true
                self.addSubview(carouselView)
                carouselView.frame = CGRect(origin: CGPoint(x: 0, y: kfootcarouselPadding), size: bounds.size)
            // 番剧 没有banner
            case .bangumi:
                carouselView.removeFromSuperview()
                everydayPushButton.isHidden = false
                bangumiIndexButton.isHidden = false
                let width = (kscreenWidth - 3*kpadding)/2
                everydayPushButton.frame = CGRect(x: kpadding, y: kfootbuttonVpadding, width: width, height: kfootbuttonHeight)
                bangumiIndexButton.frame = CGRect(x: kpadding * 2 + width, y: kfootbuttonVpadding, width: width, height: kfootbuttonHeight)
            // 番剧 有banner
            case .bangumiWithBanner:
                self.addSubview(carouselView)
                everydayPushButton.isHidden = false
                bangumiIndexButton.isHidden = false
                
                let width = (kscreenWidth - 3*kpadding)/2
                everydayPushButton.frame = CGRect(x: kpadding, y: kfootbuttonVpadding, width: width, height: kfootbuttonHeight)
                bangumiIndexButton.frame = CGRect(x: kpadding * 2 + width, y: kfootbuttonVpadding, width: width, height: kfootbuttonHeight)
                let maxY = bangumiIndexButton.frame.maxY
                carouselView.frame = CGRect(x: 0, y: maxY + 20, width: kscreenWidth, height: kfootcarouselViewHeight)
            case .none:
                everydayPushButton.isHidden = true
                bangumiIndexButton.isHidden = true
                carouselView.removeFromSuperview()
            }
        }
    }
    
    var statusModel: recommendModel? {
        
        didSet{
            // banner设置
            guard let banner = statusModel?.banner?.bottom else{return}
            
            var imageAry = [String]()
            for bannerItem in banner {
                imageAry.append(bannerItem.image!)
            }
            carouselView.intnetImageArray = imageAry
            carouselView.selectedAction = {(_ index: Int) in
                let bannerMdel = banner[index]
                guard let bannerURL = bannerMdel.uri else {return}
                ZHNnotificationHelper.recommedcarouselClickNotification(link: bannerURL)
            }
        }
    }
    
    // MARK: - 懒加载控件
    lazy var carouselView: ZHNCarouselView = {[unowned self] in
        let carouselFrame = CGRect(x: 0, y: 0, width: kscreenWidth, height:kfootcarouselViewHeight)
        let carouselView = ZHNCarouselView(viewframe: carouselFrame)
        carouselView.backgroundColor = kHomeBackColor
        return carouselView
    }()
    
    //                           记录修改一个bug个过程
    //
    //      这里写完之后有一个比较蛋疼的问题，界面展示是没有任何问题，但是滑着滑着就会cpu到100%。。本来我以为用time  profiler定位一下问题应该很容易就解决了，但是我用了之后发现事情不是我想的那样。。。最后定位到的方法是到main函数，也就是基本等于定位不到具体是什么方法导致。。一筹莫展啊，各种google各种stackoverflow，基本没有可用的信息。。。。时间过的越久会越烦躁的，而且一般这种bug会超出你平常的认知。。最后我解决这个问题的过程也并不是说有多高明的方法，只是先去看cpu爆掉的临界值，看看是什么操作。通过操作去定位大概是哪个控制器哪个view，然后你通过注释掉一些代码慢慢慢慢缩小范围直到定位到最后的方法是  everydayPushButton.aliCornerRadius = kcellcornerradius 这是我之前设置圆角的，用了一个第三方库。之前写oc的时候我一直在用注释掉这个方法世界就安静了啊。具体原因我到现在为止还是不太清除，写这些的原因其实是想说，bug不可怕，遇到你感觉解决不了的bug的时候你需要的只是静下心来，相信自己。
    //
    //
    
    
    /// 每日推荐按钮 （猥琐的用了imageview button设置图片老是拉伸）
    lazy var everydayPushButton: UIImageView = {
        let everydayPushButton = UIImageView()
        everydayPushButton.image = UIImage(named:"hd_home_bangumi_timeline")
        everydayPushButton.contentMode = UIViewContentMode.scaleAspectFill
        everydayPushButton.clipsToBounds = true
        everydayPushButton.isUserInteractionEnabled = true
        everydayPushButton.layer.cornerRadius = kcellcornerradius
//        everydayPushButton.aliCornerRadius = kcellcornerradius
        return everydayPushButton
    }()
    
    /// 番剧索引按钮
    lazy var bangumiIndexButton: UIImageView = {
        let bangumiIndexButton = UIImageView()
        bangumiIndexButton.image = UIImage(named:"hd_home_bangumi_category")
        bangumiIndexButton.contentMode = UIViewContentMode.scaleAspectFill
        bangumiIndexButton.clipsToBounds = true
        bangumiIndexButton.isUserInteractionEnabled = true
        bangumiIndexButton.layer.cornerRadius = kcellcornerradius
//        bangumiIndexButton.aliCornerRadius = kcellcornerradius
        return bangumiIndexButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kHomeBackColor
        self.addSubview(carouselView)
        self.addSubview(everydayPushButton)
        self.addSubview(bangumiIndexButton)
        self.backgroundColor = kHomeBackColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension recommendFoot {
    
    /// 判断foot的类型
    class func returnFootType(statusModel:recommendModel) -> recommendFoot.footType {
        if statusModel.type == "bangumi" {// 番剧
            if (statusModel.banner?.bottom) != nil {
                return .bangumiWithBanner
            }
            return .bangumi
        }else{
            if statusModel.banner?.bottom != nil {
                return .normal
            }
            return .none
        }
    }

    // head管理自己的高度
    class func returnFoodHeight(statusModel:recommendModel) ->CGFloat {
        let type = recommendFoot.returnFootType(statusModel: statusModel)
        switch type {
        case .none:
            return 0
        case .normal:
            return kfootcarouselViewHeight + kfootcarouselPadding
        case .bangumi:
            return 2 * kfootbuttonVpadding + kfootbuttonHeight
        case.bangumiWithBanner:
            return 190
        }
    }
}



