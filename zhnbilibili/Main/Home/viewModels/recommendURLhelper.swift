//
//  recommendURLhelper.swift
//  zhnbilibili
//
//  Created by zhn on 16/11/25.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class recommendURLhelper: NSObject {

    class func createSectionReloadURLStr(type:homeStatustype,tid:Int) -> String {
        
        // 我也不想这么猥琐啊,没办法这些接口都加密过的只能用这种猥琐方法了 😭😭
        // 并且这些接口还是稍微有点问题的，不能像bilibili那样无限拿到新数据，这个接口基本一段时间内拿到的数据都是一样的，你点击刷新的时候感觉没刷其实是刷了的只是数据都是一样的
        // 番剧和活动没有刷新的功能 
        
        // 1.热门推荐
        if type == .recommend {
            return "http://app.bilibili.com/x/v2/show/change?actionKey=appkey&appkey=27eb53fc9058f8c3&build=3970&channel=appstore&device=phone&mobi_app=iphone&plat=1&platform=ios&rand=1&sign=a0e33e296110ce58cbb555699d9a1e52&ts=1480054195"
        }
        
        // 2.推荐直播
        if type == .live {
            return "http://app.bilibili.com/x/show/live?actionKey=appkey&appkey=27eb53fc9058f8c3&build=3970&channel=appstore&device=phone&mobi_app=iphone&plat=1&platform=ios&rand=0&sign=291a3e19abc4f90f4064b0cf0e8f698d&ts=1480054280"
        }
        
        // 3. 其他的普通情况
        return "http://www.bilibili.com/index/ding/23.json?actionKey=appkey&appkey=27eb53fc9058f8c3&build=3970&device=phone&mobi_app=iphone&pagesize=20&platform=ios&sign=a5c8fc83d48a1f60a0f69bd3b8d77b5d&tid=\(tid)&ts=1480054781"
    }
    
}
