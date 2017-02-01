//
//  ZHNbangumiHeadContainerView.swift
//  
//
//  Created by 张辉男 on 17/1/21.
//
//

import UIKit

enum bangumiheadSectionType: Float {
    case detail = 240
    case season = 70
    case list = 160
    case intro = 0
    case recommendHead = 60
}

class ZHNbangumiHeadContainerView: UIView {

    var introHight: CGFloat = 0
    
    // MARK - 属性
    var headModel: ZHNbangumiDetailModel? {
        didSet {
            // 1. 计算排列
            typeArray.append(.detail)
            if let seasonCount = headModel?.seasons?.count {
                if seasonCount > 1 {
                    typeArray.append(.season)
                }
            }
            if let itemCount = headModel?.episodes?.count {
                if itemCount > 1 {
                    typeArray.append(.list)
                }
            }
            typeArray.append(.intro)
            typeArray.append(.recommendHead)
           
            // 2. 初始化ui
            setupUI()
        }
    }
    ///
    var typeArray = [bangumiheadSectionType]()
    
}


extension ZHNbangumiHeadContainerView {
    func viewHeight() -> CGFloat {
        var height: CGFloat = 0
        for type in typeArray {
            let currentHeight = CGFloat(type.rawValue)
            height += currentHeight
        }
        height += introHight
        return height
    }
    
    fileprivate func setupUI() {
        var currentMaxHeight: Float = 0
        for type in typeArray {
            switch type {
            case .detail:
                let detailHeadView = ZHNbangumiDetailHeadView()
                detailHeadView.headDetailModel = headModel
                self.addSubview(detailHeadView)
                let currentHeight = bangumiheadSectionType.detail.rawValue
                detailHeadView.frame = CGRect(x: 0, y:CGFloat(currentMaxHeight), width: kscreenWidth, height: CGFloat(currentHeight))
                currentMaxHeight += currentHeight
            case .season:
                let seasonHeadView = ZHNbangumiHeadSeasonView()
                seasonHeadView.seasonArray = headModel?.seasons
                self.addSubview(seasonHeadView)
                let currentHeight = bangumiheadSectionType.season.rawValue
                seasonHeadView.frame = CGRect(x: 0, y:CGFloat(currentMaxHeight), width: kscreenWidth, height: CGFloat(currentHeight))
                currentMaxHeight += currentHeight
            case .list:
                let listItemView = ZHNbangumiHeadItemView()
                listItemView.listArray = headModel?.episodes    
                self.addSubview(listItemView)
                let currentHeight = bangumiheadSectionType.list.rawValue
                listItemView.frame = CGRect(x: 0, y:CGFloat(currentMaxHeight), width: kscreenWidth, height: CGFloat(currentHeight))
                currentMaxHeight += currentHeight
            case .intro:
                let introView = ZHNbangumiHeadTagView()
                introView.detailModel = headModel
                self.addSubview(introView)
                let currentHeight = introView.caculateContentHeight()
                introHight = currentHeight
                introView.frame = CGRect(x: 0, y:CGFloat(currentMaxHeight), width: kscreenWidth, height: CGFloat(currentHeight))
                currentMaxHeight += Float(currentHeight)
            case .recommendHead:
                let recommendHeadView = ZHNbangumiCommendHeadView()
                self.addSubview(recommendHeadView)
                let currentHeight = bangumiheadSectionType.recommendHead.rawValue
                recommendHeadView.frame = CGRect(x: 0, y:CGFloat(currentMaxHeight), width: kscreenWidth, height: CGFloat(currentHeight))
                currentMaxHeight += currentHeight
            }
        }
    }
}

