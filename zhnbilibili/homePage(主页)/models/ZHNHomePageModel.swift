//
//  ZHNHomePageModel.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/11.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit
import HandyJSON

class ZHNHomePageModel: HandyJSON {

    /// 公开的数据
    var setting: ZHNhomePageSettingModel?
    
    var card: ZHNhomePageCardModel?
    
    var elec: elecModel?
    
    /// 投稿
    var archive: ZHNhomePageArchiveModel?
    
    /// 番剧
    var season: ZHNhomePageSeasonModel?
    
    /// 投币
    var coin_archive: ZHNhomePageCoinModel?
    
    /// 收藏
    var favourite: ZHNhomePageFaverateModel?
    
    /// 标签
    var tag: [tagModel]?
    
    /// 背景图片
    var images: ZHNhomePageBackImageUrl?
    
    required init() {}
}


class ZHNhomePageSettingModel: HandyJSON {
    
    //
    // 0代表没有公开的  1代表都是公开的
    //
    
    // 标签
    var tags: Int = 0
    // 收藏
    var fav_video: Int = 0
    // 投币
    var coins_video: Int = 0
    // 番剧
    var bangumi: Int = 0
    // 游戏
    var played_game: Int = 0
    // 圈子
    var groups: Int = 0
    
    required init() {}
}


class ZHNhomePageCardModel: HandyJSON {
    
    var mid: Int = 0
    /// 名字
    var name: String = ""
    /// 性别
    var sex: String = ""
    /// 介绍
    var sign: String = ""
    /// 关注
    var attention: Int = 0
    /// 粉丝
    var fans = 0
    /// 头像
    var face: String = ""
    /// 等级
    var level_info: ZHNhomePagelevelModel?
    
    required init() {}
}


class ZHNhomePagelevelModel: HandyJSON {
    
    /// 当前的等级
    var current_level: Int = 0
    var current_min: Int = 0
    /// 当前的等级分
    var current_exp: Int = 0
    /// 下一个等级分
    var next_exp: Int = 0
    
    required init() {}
}


/// 投稿
class ZHNhomePageArchiveModel: HandyJSON {
    
    /// 数量
    var count: Int = 0
    /// 具体数据
    var item: [itemDetailModel]?
    
    required init() {}
}


/// 番剧
class ZHNhomePageSeasonModel: HandyJSON {
    // 数量
    var count: Int = 0
    // 具体数据
    var item: [HomeBangumiDetailModel]?
    
    required init() {}
}


/// 收藏夹
class ZHNhomePageFaverateModel: HandyJSON {

    /// 数量
    var count: Int = 0
    /// 具体数据
    var item: [ZHNhomePagefavirateDetailModel]?
    
    required init() {}
}


/// 最近投币
class ZHNhomePageCoinModel: HandyJSON {
    
    /// 数量
    var count: Int = 0
    
    /// 具体数据
    var item: [itemDetailModel]?
    
    required init() {}
}


class ZHNhomePagefavirateDetailModel: HandyJSON {
    
    var name: String = ""
    var cur_count: Int = 0
    var cover: [ZHNhomePageFavoriteCoverModel]?
    
    required init() {}
}

class ZHNhomePageFavoriteCoverModel: HandyJSON {
    
    var aid: Int = 0
    var pic: String = ""
    
    required init() {}
}

class ZHNhomePageBackImageUrl: HandyJSON {
    
    /// 背景图片
    var imgUrl: String = ""
    
    required init() {}
}


