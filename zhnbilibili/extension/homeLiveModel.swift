//
//  homeLiveModel.swift
//  zhnbilibili
//
//  Created by zhn on 16/11/28.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit
import HandyJSON

class homeLiveModel: HandyJSON {

    // 轮播的数据
    var banner: [liveBannerModel]?
    
    // 直播的数据
    var partitions: [homeLiveItemModel]?
    
    required init() {}
}

// 整个banner的model
class liveBannerModel: HandyJSON {
    
    // 轮播的标题
    var title: String?
    // 轮播的图片
    var img: String?
    // 我也不知道是啥
    var remark: String?
    // 当前轮播对应的链接
    var link: String?
    
    required init() {}
}


class homeLiveHeadModel: HandyJSON {
    
    var id: Int = 0
    // 这个head的类型(中文)
    var name: String?
    // 这个head的类型(英文)
    var area: String?
    // 这个head的图标model
    var sub_icon: homeLiveHeadIconModel?
    // 当前直播的人数
    var count: Int = 0
    
    
    required init() {}
}

// 每组head上的icon model
class homeLiveHeadIconModel: HandyJSON {
    
    // 每个section的head对应icon
    var src: String?
    // 图标的高度
    var height: Int = 0
    // 图标的宽度
    var width: Int = 0
    
    required init() {}
}


// 当前直播的人的信息
class homeLivePeopleModel: HandyJSON {
    
    // 头像
    var face: String?
    // 我也不知道是啥
    var mid: String?
    // 名字
    var name: String?
    
    required init() {}
}

// 当前直播显示的背景model
class homeLiveCoverModel: HandyJSON {
    
    // 背景图片
    var src: String?
    // 宽度
    var width: Int = 0
    // 高度
    var height: Int = 0
    
    required init() {}
}


// 直播细节的model
class homeLiveDetailModel: HandyJSON {
    
    // 直播的人
    var owner: homeLivePeopleModel?
    // 直播的背景
    var cover: homeLiveCoverModel?
    // 直播的标题
    var title: String?
    // 直播的房间号
    var room_id: Int = 0
    // 当前的在线人数
    var online: Int = 0
    // 当前直播的类型
    var area: String?
    // 当前直播类型的id
    var area_id: Int = 0
    // 当前的直播的url
    var playurl: String?
    // 右上角的显示
    var corner: String?
    
    // 下面三个不知道是啥
    var accept_quality: Int = 0
    var broadcast_type: String?
    var is_tv: Int = 0
    
    
    // 判断是不是推荐的banner
    var is_hotBanner = false
    
    required init() {}
}


// 直播item的model
class homeLiveItemModel: HandyJSON {

    var partition: homeLiveHeadModel?
    
    var lives: [homeLiveDetailModel]?
    
    var banner_data: [homeLiveDetailModel]?
    
    required init() {}
}


