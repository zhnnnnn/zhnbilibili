//
//  ZHNnotificationHelper.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/7.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class ZHNnotificationHelper {

    class func livecarouselClickNotification(link: String) {
        NotificationCenter.default.post(name: kcarouselViewSelectedLiVENotification, object: nil, userInfo: [kcarouselSelectedUrlKey:link])
    }
    
    class func recommedcarouselClickNotification(link: String) {
        NotificationCenter.default.post(name: kcarouselViewSelectedRECOMMENDNotification, object: nil, userInfo: [kcarouselSelectedUrlKey:link])
    }
    
    class func bangumicarouselClickNotification(link: String) {
        NotificationCenter.default.post(name: kcarouselViewSelectedBANGUMINotification, object: nil, userInfo: [kcarouselSelectedUrlKey:link])
    }
    
}
