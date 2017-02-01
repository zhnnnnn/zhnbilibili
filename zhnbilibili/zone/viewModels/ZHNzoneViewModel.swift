//
//  ZHNzoneViewModel.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/6.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

class ZHNzoneViewModel {
    
    var zoneModelArray = [ZHNzoneModel]()
}

// MARK - 公开的方法
extension ZHNzoneViewModel {
    func requestData(finishAction: @escaping (() -> Void)) {
        
        ZHNnetworkTool.requestData(.get, URLString: "http://app.bilibili.com/x/v2/region?actionKey=appkey&appkey=27eb53fc9058f8c3&build=3970&device=phone&mobi_app=iphone&platform=ios&sign=f4aa89fae4cb28e040b27febfb29f75e&ts=1483685717", finishedCallback: { (result) in
            
            let jsonArryStr = ZHNjsonHelper.getjsonArrayString(key: "data", json: result)
            if let zoneArray = JSONDeserializer<ZHNzoneModel>.deserializeModelArrayFrom(json: jsonArryStr) as? [ZHNzoneModel] {
                self.zoneModelArray = zoneArray
            }
            finishAction()
            
        }) { (error) in
        }
    }
}
