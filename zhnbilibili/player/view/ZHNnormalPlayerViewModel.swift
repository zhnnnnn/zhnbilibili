//
//  ZHNnormalPlayerViewModel.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/14.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

/// 获取视频播放url成功的通知
let kgetPlayUrlSuccessNotification = Notification.Name("kgetPlayUrlSuccessNotification")

class ZHNnormalPlayerViewModel {

    var playerUrl: String?
    
    func requestData(aid: Int,finishCallBack:@escaping ()->(),failueCallBack:@escaping ()->()) {
        
        let urlStr = "http://app.bilibili.com/x/view?actionKey=appkey&aid=\(aid)&appkey=27eb53fc9058f8c3&build=3380"
        ZHNnetworkTool.requestData(.get, URLString: urlStr, finishedCallback: { (result) in
            let resultJson = JSON(result)
            let dict = resultJson["data"]["pages"].array?.first?.dictionaryObject
            guard let cid = dict?["cid"] as? Int else {return}
            guard let page = dict?["page"] as? Int else {return}
            
            VideoURL.getWithAid(aid, cid: cid, page: page, completionBlock: { (url) in
                guard let urlStr = url?.absoluteString else {return}
                self.playerUrl = urlStr
                NotificationCenter.default.post(name: kgetPlayUrlSuccessNotification, object: nil)
            })
            
            finishCallBack()
        }) { (error) in
                failueCallBack()
        }
    }
    
    
    func requestDanmuStatus() {
        let URLString = "xaad"
        Alamofire.request(URLString, method: .get, parameters: nil).responseData { (data) in
            
        }
    }
    
}
