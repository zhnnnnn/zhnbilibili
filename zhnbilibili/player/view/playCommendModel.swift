//
//  playCommendModel.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/2.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit
import HandyJSON

class playCommendModel: HandyJSON {

    // 回复的数量
    var count: Int = 0
    // 点赞的数量
    var like: Int = 0
    // 回复的时间
    var ctime: Double = 0
    // 用户的数据
    var member: playCommendMember?
    // 回复这条消息的回复
    var replies: [playCommendModel]?
    // 回复的内容
    var content: playCommendContetModel?
    // 楼层
    var floor: Int = 0
    
    required init() {}
}


// MARK - 评论的用户的数据
class playCommendMember: HandyJSON {
    var mid: Int = 0
    // 名字
    var uname: String = ""
    // 头像
    var avatar: String = ""
    // 等级
    var level_info: playCommendMemberLevel?
    
    required init() {}
}

// 用户等级
class playCommendMemberLevel: HandyJSON {
    // 用户等级
    var current_level: Int = 0
    required init() {}
}

class playCommendContetModel: HandyJSON {
    // 回复的消息内容
    var message: String = ""
    required init() {}
}


