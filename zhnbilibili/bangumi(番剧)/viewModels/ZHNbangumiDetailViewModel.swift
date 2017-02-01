//
//  ZHNbangumiDetailViewModel.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/20.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

class ZHNbangumiDetailViewModel: ZHNplayerCommendViewModel {
    /// -- 头部的数据
    var bangumiDetailModel: ZHNbangumiDetailModel?
}

//======================================================================
// MARK:- 网络数据的加载
//======================================================================
extension ZHNbangumiDetailViewModel {
    
    func bangumiRequestData(seasonId: Int,finishAction: @escaping (()->Void)) {
        ZHNnetworkTool.dataReponeseRequestdata(.get, URLString: "http://bangumi.bilibili.com/jsonp/seasoninfo/\(seasonId).ver", finishedCallback: { (result) in
           
            do {
                // 解析头部的数据
                let resultObject = result as! NSString
                let resultData: Data = resultObject.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)!
                let resultJson = try JSONSerialization.jsonObject(with: resultData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
                self.bangumiDetailModel = JSONDeserializer<ZHNbangumiDetailModel>.deserializeFrom(dict: resultJson["result"] as! NSDictionary?)
                
                // 加载回复的数据
                if let list = self.bangumiDetailModel?.episodes?.first {
                    self.requestRecommendData(oid: list.av_id, finishAction: finishAction)
                }
            }
            
            catch {
            
            }
        }) { (error) in
        }
    }
    
    fileprivate func requestRecommendData(oid: Int, finishAction: @escaping (()->Void)) {
        ZHNnetworkTool.requestData(.get, URLString: "http://api.bilibili.com/x/v2/reply?_device=iphone&_hwid=937484d7e0997f66&_ulv=0&access_key=&appkey=27eb53fc9058f8c3&appver=3970&build=3970&nohot=0&oid=\(oid)&platform=ios&pn=1&ps=20&sign=9ad048889f735621214d2bcf0ab9eb7f&sort=0&type=1", finishedCallback: { (result) in
            // 解析数据
            self.jsonToModel(result: result)
            // 回调
            finishAction()
        }) { (error) in
        }
    }
}

//======================================================================
// MARK:- tableivew 数据源的处理
//======================================================================
extension ZHNbangumiDetailViewModel {

}
