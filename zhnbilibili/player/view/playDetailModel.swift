//
//  playDetailModel.swift
//  zhnbilibili
//
//  Created by 张辉男 on 16/12/29.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit
import HandyJSON

class playDetailModel: HandyJSON  {
    
    /// 相关数据
    var relates: [relatesModel]?
    /// 播放数据
    var stat: relatesStatModel?
    /// 描述
    var desc: String = ""
    /// 标题
    var title: String = ""
    /// 上传的时间戳
    var ctime: Double = 0
    /// 用户
    var owner: relatesOwnerModel?
    /// 标签
    var tag: [tagModel]?
    /// 充能
    var elec: elecModel?
    /// 分级的列表
    var pages: [pageDetailModel]?
    /// 图片
    var pic: String = ""
    /// aid
    var aid: Int = 0
    
    required init() {}
}



// MARK - 关联数据
class relatesModel: HandyJSON {
    
    /// 用户数据
    var owner: relatesOwnerModel?
    /// 播放内容的数据
    var stat: relatesStatModel?
    /// 视频id
    var aid: Int = 0
    /// 图片
    var pic: String = ""
    /// 标题
    var title: String = ""
    
    required init() {}
}

class relatesOwnerModel: HandyJSON {
    /// 头像
    var face: String = ""
    /// 名字
    var name: String = ""
    ///
    var mid: Int = 0
    
    required init() {}
}

class relatesStatModel: HandyJSON {
    
//    "coin": 0,
//    "danmaku": 11,
//    "favorite": 52,
//    "his_rank": 0,
//    "now_rank": 0,
//    "reply": 17,
//    "share": 0,
//    "view": 3608
    /// 收藏数量
    var favorite: Int = 0
    /// 分享的数量
    var share: Int = 0
    /// 硬币数量
    var coin: Int = 0
    /// 弹幕数量
    var danmaku: Int = 0
    /// 观看数量
    var view: Int = 0
    
    
    required init() {}
}

// MARK - 标签的model
class tagModel: HandyJSON {
    
    //    "cover": "",
    //    "hates": 0,
    //    "likes": 9,
    //    "tag_id": 2485355,
    //    "tag_name": "东方project"
    var tag_name: String = ""
    
    required init() {}
}

// MARK - 充能
class elecModel: HandyJSON {
    /// 本月充能的人数
    var count: Int = 0
    /// 充能总数
    var total: Int = 0
    /// 充能的人的具体数据
    var list: [elecListetailModel]?
    
    required init() {}
}
class elecListetailModel: HandyJSON {
    
//    "avatar": "http://static.hdslb.com/images/member/noface.gif",
//    "pay_mid": 12046616,
//    "rank": 1,
//    "uname": "zhengyanqing"
    // 头像
    var avatar: String = ""
    
    required init() {}
}

// MARK - 分级
class pageDetailModel: HandyJSON {
    
//    "cid": 10989703,
//    "from": "vupload",
//    "has_alias": 0,
//    "link": "",
//    "page": 1,
//    "part": "动图版",
//    "rich_vid": "",
//    "vid": "vupload_10989703",
//    "weblink": ""
    /// cid
    var cid: Int = 0
    /// 名字
    var part: String = ""
    
    required init() {}
}






