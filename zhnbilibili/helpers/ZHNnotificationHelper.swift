//
//  ZHNnotificationHelper.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/7.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class ZHNnotificationHelper {

    // MARK - 首页
    class func livecarouselClickNotification(link: String) {
        NotificationCenter.default.post(name: kcarouselViewSelectedLiVENotification, object: nil, userInfo: [kcarouselSelectedUrlKey:link])
    }
    
    class func recommedcarouselClickNotification(link: String) {
        NotificationCenter.default.post(name: kcarouselViewSelectedRECOMMENDNotification, object: nil, userInfo: [kcarouselSelectedUrlKey:link])
    }
    
    class func bangumicarouselClickNotification(link: String) {
        NotificationCenter.default.post(name: kcarouselViewSelectedBANGUMINotification, object: nil, userInfo: [kcarouselSelectedUrlKey:link])
    }
    
    
    // MARK - 主页
    class func homePageSelectedNormalNotification(item: itemDetailModel) {
        NotificationCenter.default.post(name: khomePageNormalPLayerSelectedNotification, object: nil, userInfo: [khomePageSelectedAidKey:item])
    }
    
    // MARK - 评论
    class func recommendSelectedHomePage(mid: Int) {
        NotificationCenter.default.post(name: krecommendControllerSelectedHomePageNotification, object: nil, userInfo: [krecommendNotificationKey: mid])
    }
    
    // MARK - 关闭播放器
    class func shutDownOldPlayer() {
        NotificationCenter.default.post(name: KplayingPlayerNeedToShutDownNotification, object: nil, userInfo: nil)
    }
    
    // MARK - 番剧
    class func bangumiItemSelected(bangumiModel: HomeBangumiDetailModel) {
        NotificationCenter.default.post(name: kbangumiSelectedNotification, object: nil, userInfo: [kbangumiModelKey: bangumiModel])
    }
    
}
