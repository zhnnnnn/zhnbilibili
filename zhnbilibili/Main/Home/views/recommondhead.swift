//
//  recommondhead.swift
//  zhnbilibili
//
//  Created by zhn on 16/11/23.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class recommondhead: UICollectionReusableView {

    enum headtype {
        case hotrecommend // 热门推荐的头部
        case normal// 普通的头部
    }
    
    // MARK: - 属性 set 方法
    var statusModel:recommendModel?{
        didSet{
            // 1.普通icon的设置
            normalHeade.statusModel = statusModel
            
            // 2.banner设置
            guard let banner = statusModel?.banner?.top else{return}
            var imageAry = [String]()
            for bannerItem in banner {
                imageAry.append(bannerItem.image!)
            }
            carouselView.intnetImageArray = imageAry
            carouselView.selectedAction = { [weak self] (_ index: Int) in
                let bannerMdel = self?.statusModel?.banner?.top?[index]
                guard let bannerURL = bannerMdel?.uri else {return}
                ZHNnotificationHelper.recommedcarouselClickNotification(link: bannerURL)
            }
        }
    }
    
    var type:headtype = .normal {
        
        didSet{
            // 1.普通的头部
            if type == .normal {
                
                carouselView.removeFromSuperview()
                carouselView.isHidden = true
                normalHeade.snp.remakeConstraints { (make) in
                    make.left.right.bottom.top.equalTo(self)
                }
                
            }else{// 2. 推荐的头部
                
                self.addSubview(carouselView)
                carouselView.isHidden = false
                carouselView.frame = CGRect(x: 0, y: 0, width: kscreenWidth, height: kcarouselHeight)
                normalHeade.snp.remakeConstraints { (make) in
                    make.left.right.bottom.equalTo(self)
                    make.top.equalTo(carouselView.snp.bottom)
                }
            }
        }
    }
    
    // MARK: - 懒加载控件
    lazy var carouselView: ZHNCarouselView = {
        let carouselView = ZHNCarouselView(viewframe: CGRect(x: 0, y: 0, width: kscreenWidth, height: kcarouselHeight))
        carouselView.clipsToBounds = true
        return carouselView
    }()
    
    lazy var normalHeade: collectionNormalHeader = {
        let normalHeade = collectionNormalHeader()
        return normalHeade
    }()
    
    
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(carouselView)
        self.addSubview(normalHeade)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // head管理自己的高度
    class func returnHeadHeight(type:String) ->CGFloat {
        if type == "recommend" {
            return kcarouselHeight + knormalHeadeHeight
        }else{
            return knormalHeadeHeight
        }
    }
    
}
