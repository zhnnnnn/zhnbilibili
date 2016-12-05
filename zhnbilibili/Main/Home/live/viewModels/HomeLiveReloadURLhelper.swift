//
//  HomeLiveReloadURLhelper.swift
//  zhnbilibili
//
//  Created by zhn on 16/11/30.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class HomeLiveReloadURLhelper: NSObject {

    // 加密过的,sign 和 area 有关系只能用这种方法拿
    class func createReloadSectionURL(area: String) -> String {
        
        
        // 1. 推荐主播
        if area == "hot" {
            return "http://live.bilibili.com/AppIndex/recommendRefresh?actionKey=appkey&appkey=27eb53fc9058f8c3&build=3970&device=phone&mobi_app=iphone&platform=ios&sign=ee5759f6df79cf2abbaf7927ab35e983&ts=1479286545"
        }
        
        // 2. 绘画
        if area == "draw" {
            return "http://live.bilibili.com/AppIndex/dynamic?actionKey=appkey&appkey=27eb53fc9058f8c3&area=draw&build=3970&device=phone&mobi_app=iphone&platform=ios&sign=dd48aa4f416222aadaa591af573c4faa&ts=1479286692"
        }
        
        // 3. 手机直播
        if area == "mobile" {
            return "http://live.bilibili.com/AppIndex/dynamic?actionKey=appkey&appkey=27eb53fc9058f8c3&area=mobile&build=3970&device=phone&mobi_app=iphone&platform=ios&sign=b70507f063d8325b85426e6b4feddbc6&ts=1479286747"
        }
        
        // 4. 唱见舞见
        if area == "sing-dance" {
            return "http://live.bilibili.com/AppIndex/dynamic?actionKey=appkey&appkey=27eb53fc9058f8c3&area=sing-dance&build=3970&device=phone&mobi_app=iphone&platform=ios&sign=4cd40a5e0073765d156e26ac6115e23a&ts=1479287001"
        }
        
        // 5. 手机游戏
        if area == "mobile-game" {
            return "http://live.bilibili.com/AppIndex/dynamic?actionKey=appkey&appkey=27eb53fc9058f8c3&area=mobile-game&build=3970&device=phone&mobi_app=iphone&platform=ios&sign=6254a0cac7ff9da85a24c037971303f4&ts=1479287130"
        }
        
        // 6.单机
        if area == "single"{
            return "http://live.bilibili.com/AppIndex/dynamic?actionKey=appkey&appkey=27eb53fc9058f8c3&area=single&build=3970&device=phone&mobi_app=iphone&platform=ios&sign=b16eb80648d3eccd337d83bc97c8a5c2&ts=1479287170"
        }
        
        // 7. 网络游戏
        if area == "online" {
            return "http://live.bilibili.com/AppIndex/dynamic?actionKey=appkey&appkey=27eb53fc9058f8c3&area=online&build=3970&device=phone&mobi_app=iphone&platform=ios&sign=0a987b8f320d44ff992ef14c82f8b840&ts=1479287203"
        }
        
        // 8.电子竞技
        if area == "e-sports" {
            return "http://live.bilibili.com/AppIndex/dynamic?actionKey=appkey&appkey=27eb53fc9058f8c3&area=e-sports&build=3970&device=phone&mobi_app=iphone&platform=ios&sign=7b11eb5ad6446055e551ac3cffdfcfb9&ts=1479287244"
        }
        
        // 9. 御宅文化
        if area == "otaku" {
            return "http://live.bilibili.com/AppIndex/dynamic?actionKey=appkey&appkey=27eb53fc9058f8c3&area=otaku&build=3970&device=phone&mobi_app=iphone&platform=ios&sign=59ccc610ead8551347fbbf414caf3191&ts=1479287296"
        }
        
        // 10.放映厅
        if area == "movie" {
            return "http://live.bilibili.com/AppIndex/dynamic?actionKey=appkey&appkey=27eb53fc9058f8c3&area=movie&build=3970&device=phone&mobi_app=iphone&platform=ios&sign=07a772a0824d9289da692be8ed3044cb&ts=1479287345"
        }
        
        return ""
    }
    
}
