//
//  recommendSectionReloadModel.swift
//  zhnbilibili
//
//  Created by zhn on 16/11/25.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit
import HandyJSON

class recommendSectionReloadModel: HandyJSON {

    var aid: String?
    var typeid: Int = 0
    var subtitle: String?
    var review: Int = 0
    
    /// 播放的数量
    var play: Int = 0
    /// 评论的数量
    var video_review: Int = 0
    /// 标题
    var title: String?
    /// 图片
    var pic: String?
    
    required init() {}
}
