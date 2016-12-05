//
//  recommendModel.swift
//  zhnbilibili
//
//  Created by zhn on 16/11/21.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit
import HandyJSON

enum homeStatustype {
    
    /// 1.热门推荐
    case recommend
    
    /// 2.推荐直播
    case live
    
    /// 3.番剧推荐
    case bangumi
    
    /// 4.动画区
    case donghua
    
    /// 5.音乐
    case music
    
    /// 6.舞蹈区
    case dance
    
    /// 7.游戏
    case game
    
    /// 8.鬼畜
    case guichu
    
    /// 9.科技
    case tecnolegy
    
    /// 10.活动中心
    case activity
    
    /// 11.生活区
    case life
    
    /// 12.时尚
    case morden
    
    /// 13.广告
    case advetise
    
    /// 14.娱乐
    case entertainment
    
    /// 15.电视剧
    case TVshow
    
    /// 16.电影
    case film
}


// MARK: - section的mode
class recommendModel:HandyJSON {

    // 判断是什么区的数据
    var sectionType:homeStatustype?
    
    var param: Int = 0
    var type: String?
    var style: String?
    var title: String?
    var banner: banner?
    var ext: liveDetailModel?
    var body: [itemDetailModel] = [itemDetailModel]()
    
    required init(){}
}

// MARK: - ecommendModel的一些公开方法
extension recommendModel {

    func setHomeStatusType() {
        
        if type == "recommend" {
            sectionType = .recommend
        }
        
        if type == "live" {
            sectionType = .live
        }
        
        if type == "bangumi" {
            sectionType = homeStatustype.bangumi
        }
        
        if type == "activity" {
            sectionType = homeStatustype.activity
        }
        
        // 动画
        if param == 1 {
            sectionType = homeStatustype.donghua
        }
        
        // 音乐
        if param == 3 {
            sectionType = homeStatustype.music
        }
        
        // 舞蹈区
        if param == 129 {
            sectionType = homeStatustype.dance
        }
        
        // 游戏区
        if param == 4 {
            sectionType = homeStatustype.game
        }
        
        // 鬼畜区
        if param == 119 {
            sectionType = homeStatustype.guichu
        }
        
        // 科技区
        if param == 36 {
            sectionType = homeStatustype.tecnolegy
        }
        
        // 舞蹈区
        if param == 160 {
            sectionType = homeStatustype.life
        }
        
        // 时尚区
        if param == 155 {
            sectionType = homeStatustype.morden
        }
        
        // 广告区
        if param == 165 {
            sectionType = homeStatustype.advetise
        }
        
        // 娱乐区
        if param == 5 {
            sectionType = homeStatustype.entertainment
        }
        
        // 电视剧区
        if param == 11 {
            sectionType = homeStatustype.TVshow
        }
        
        // 电影区
        if param == 23 {
            sectionType = homeStatustype.film
        }
    }
}



// MARK: - 普通显示的model
class itemDetailModel:HandyJSON {
    // 标题
    var title: String?
    // 显示的图片
    var cover: String?
    // 播放的url
    var uri: String?
    // 
    var param: Int = 0
    // 直播的状态
    var goto: String?
    // 类型
    var area: String?
    // 类型的id
    var area_id: String?
    // 用户的名字
    var name: String?
    // 用户的头像
    var face: String?
    // 
    var online: Int = 0
    // 播放数
    var play: Int = 0
    // 评论数
    var danmaku: Int = 0
    // 时间
    var mtime: String?
    // 连载剧集
    var index: Int?
    // 角上的图标
    var corner:String?
    
    
    required init(){}
}

// MARK: -
class banner:HandyJSON {
    
    // 顶部的轮播
    var top: [bannerDetailModel]?
    // 底部的轮播
    var bottom: [bannerDetailModel]?
    
    required init(){}
}

// MARK: - 轮播的model
class bannerDetailModel:HandyJSON {
    
    var id: String?
    
    var title: String?
    
    var image: String?
    
    var hash: String?
    
    var uri: String?
    
    /// 是否是广告
    var is_ad: Bool?
    
    required init(){}
}

// MARK: - 直播的model
class liveDetailModel: HandyJSON {
    var live_count: Int = 0
    
    required init(){}
}



