//
//  homeLivehead.swift
//  zhnbilibili
//
//  Created by zhn on 16/11/29.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

let khomeLiveMenuHeight:CGFloat = 100

class homeLivehead: UICollectionReusableView {

    // 普通的头部数据
    var headModel: homeLiveHeadModel? {
        didSet{
            
            // 1. 设置图标
            if let imgStr = headModel?.sub_icon?.src {
                let imgUrl = URL(string: imgStr)
                contentView.iconImageView.kf.setImage(with: imgUrl)
            }
            // 2. 设置坐标的标题
            contentView.iconLabel.text = headModel?.name
            
            // 3. 设置标题的文字
            let countString = String.creatCountString(count: (headModel?.count)!)
            let attrStr = String.creatAttributesText(countString: countString, beginStr: "当前", endStr: "个直播,进去看看")
            contentView.noticeLabel.attributedText = attrStr
            
            // 4. 设置arrowimage
            contentView.arrImageView.image = UIImage(named: "common_rightArrowShadow")
            contentView.rightIconImageView.isHidden = true
            
            // 5. 更改控件位置
            normalHead()
        }
    }
    
    // 带banner的数据
    var bannerModelArray: [liveBannerModel]? {
        didSet{
            // 1. 赋值数据
            var imageStringArray = [String]()
            guard let bannerModelArray = bannerModelArray else {return}
            for model in bannerModelArray{
                guard let imgString = model.img else {return}
                imageStringArray.append(imgString)
            }
            carouselView.intnetImageArray = imageStringArray
           
            // 2.更改位置
            topHead()
        }
    }
    
    
    // MARK: - 懒加载控件
    lazy var contentView: collectionNormalHeader = {
        let conteView = collectionNormalHeader()
        return conteView
    }()
    
    lazy var carouselView: ZHNCarouselView = {
        let carouselView = ZHNCarouselView(viewframe: CGRect(x: 0, y: 0, width: kscreenWidth, height: kcarouselHeight))
        carouselView.clipsToBounds = true
        carouselView.delegate = self
        return carouselView
    }()
    
    lazy var menuView: HomeLiveHeadMenu = {
        let menuView = HomeLiveHeadMenu.instanceView()
        menuView.backgroundColor = kHomeBackColor
        return menuView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(contentView)
        self.addSubview(carouselView)
        self.addSubview(menuView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 私有方法
extension homeLivehead {

    // 普通头部的内部控件的位置
    fileprivate func normalHead() {
        
        menuView.isHidden = true
        carouselView.removeFromSuperview()
        menuView.removeFromSuperview()
        
        contentView.snp.remakeConstraints { (make) in
            make.left.top.bottom.right.equalTo(self)
        }
    }
    
    // 第一个section的内部控件的位置
    fileprivate func topHead() {
    
        menuView.isHidden = false
        self.addSubview(carouselView)
        self.addSubview(menuView)
        
        carouselView.snp.remakeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.height.equalTo(kcarouselHeight)
        }
        
        menuView.snp.remakeConstraints { (make) in
            make.top.equalTo(carouselView.snp.bottom)
            make.left.right.equalTo(self)
            make.height.equalTo(khomeLiveMenuHeight)
        }
        
        contentView.snp.remakeConstraints { (make) in
            make.left.bottom.right.equalTo(self)
            make.top.equalTo(menuView.snp.bottom)
        }
    }

}

extension homeLivehead: ZHNcarouselViewDelegate {
    func ZHNcarouselViewSelectedIndex(index: Int) {
        guard let model = bannerModelArray?[index] else {return}
        guard let link = model.link else {return}
        ZHNnotificationHelper.livecarouselClickNotification(link: link)
    }
}

