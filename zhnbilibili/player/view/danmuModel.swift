//
//  danmuModel.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/17.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit
import SwiftyJSON

class danmuModel {

    /// 弹幕的显示时间
    var danmuShowingTime: Float = 0
    /// 弹幕显示的内容
    var danmuText = ""
    /// 弹幕的显示 1-> 滚动弹幕 5->顶端弹幕 4->底部弹幕
    var danmuShowIngType: Int = 0
    /// 弹幕颜色的10进制
    var danmuColor: Int = 0
    
    /// 弹幕xml转modal
    class func modelArray(dict: [AnyHashable : Any]) -> [danmuModel] {
        let resultJson = JSON(dict)
        guard let danmuArray = resultJson["i"]["d"].array else {return []}
        var danmuModelArray = [danmuModel]()
        for danmuDict in danmuArray {
            // 1.先解析出数据
            let danmuDictObject = danmuDict.dictionaryObject
            guard let danmuItemString = danmuDictObject?["p"] as? String else {return []}
            let danmuDetailArray = danmuItemString.components(separatedBy: ",")
            // 2.赋值数据
            guard let text = danmuDictObject?["text"] as? String else {return []}
            guard let showingTime = Float(danmuDetailArray[0]) else {return []}
            guard let showIngType = Int(danmuDetailArray[1]) else {return []}
            guard let color = Int(danmuDetailArray[3]) else {return []}
            let model = danmuModel()
            model.danmuText = text
            model.danmuShowingTime = showingTime
            model.danmuShowIngType = showIngType
            model.danmuColor = color
            danmuModelArray.append(model)
        }
        return danmuModelArray
    }
}
