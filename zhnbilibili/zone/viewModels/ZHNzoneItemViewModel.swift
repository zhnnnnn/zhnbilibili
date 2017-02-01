//
//  ZHNzoneItemViewModel.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/10.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

class ZHNzoneItemViewModel {
    // 热门推荐
    var recommendArray = [itemDetailModel]()
    // 最新数据
    var newestArray = [itemDetailModel]()
    // 数据
    var statusArray = [[itemDetailModel]]()
}

extension ZHNzoneItemViewModel {
    func requestData(rid: Int,finishAction: @escaping (()->Void))  {
//        http://app.bilibili.com/x/v2/region/show/child?actionKey=appkey&appkey=27eb53fc9058f8c3&build=3970&device=phone&mobi_app=iphone&platform=ios&rid=20&sign=f2850f2934407d055f8b200d49a96a6f&ts=1483686014
        
        ZHNnetworkTool.requestData(.get, URLString: "http://app.bilibili.com/x/v2/region/show/child?actionKey=appkey&appkey=27eb53fc9058f8c3&build=3970&device=phone&mobi_app=iphone&platform=ios&rid=\(rid)&sign=f2850f2934407d055f8b200d49a96a6f&ts=1483686014", finishedCallback: { (result) in
            // 字典转模型
            let resultJson = JSON(result)
            let recommendAryStr = ZHNjsonHelper.getjsonArrayString(key: "recommend", json: resultJson["data"].dictionaryObject)
            let newAryStr = ZHNjsonHelper.getjsonArrayString(key: "new", json: resultJson["data"].dictionaryObject)
            if let tempRecommedArray = JSONDeserializer<itemDetailModel>.deserializeModelArrayFrom(json: recommendAryStr) {
                self.recommendArray = tempRecommedArray as! [itemDetailModel]
            }
            if let rempNewArray = JSONDeserializer<itemDetailModel>.deserializeModelArrayFrom(json: newAryStr) {
                self.newestArray = rempNewArray as! [itemDetailModel]
            }
            self.statusArray.append(self.recommendArray)
            self.statusArray.append(self.newestArray)
            finishAction()
        }) { (error) in
        }
    }
}
