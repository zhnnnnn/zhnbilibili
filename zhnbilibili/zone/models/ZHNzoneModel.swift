//
//  ZHNzoneModel.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/6.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit
import HandyJSON

class ZHNzoneModel: HandyJSON {

//    "tid": 13,
//    "reid": 0,
//    "name": "番剧",
//    "logo": "",
//    "goto": "",
//    "param": "",
//    "children"
    
    var tid: Int = 0
    // 名字
    var name: String = ""
    // 标志
    var logo: String = ""
    // 子区域
    var children: [ZHNzoneModel]?
    
    required init(){}
}

extension ZHNzoneModel {
    
    class func menuisOneRow(zoneArray: [ZHNzoneModel]) -> Bool {
        var width: CGFloat = 0
        for zone in zoneArray {
            width += zone.name.widthWithConstrainedHeight(height: 10000, font: UIFont.systemFont(ofSize: 13)) + kminiPadding
        }
        if width > kscreenWidth{
            return false
        }else {
            return true 
        }
    }
    
    class func titleArray(zoneArray: [ZHNzoneModel]) -> [String] {
        var titleArray = [String]()
        for zoneModel in zoneArray{
            titleArray.append(zoneModel.name)
        }
        return titleArray
    }
    
}
