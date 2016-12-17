//
//  ZHHnormalPayerItemModel.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/14.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit
import HandyJSON

//"cid": 11857260,
//"from": "vupload",
//"has_alias": 0,
//"link": "",
//"page": 1,
//"part": "",
//"rich_vid": "",
//"vid": "vupload_11857260",
//"weblink": ""
class ZHHnormalPayerItemModel: HandyJSON {
    
    // 需要拿这个cid去拼接播放的数据
    var cid: String = ""
    
    var page: Int = 0
    var vid: String = ""
    
    required init() {}
}
