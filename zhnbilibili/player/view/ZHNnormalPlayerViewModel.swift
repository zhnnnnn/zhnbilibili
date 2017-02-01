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
import HandyJSON

/// 获取视频播放url成功的通知
let kgetPlayUrlSuccessNotification = Notification.Name("kgetPlayUrlSuccessNotification")

class ZHNnormalPlayerViewModel {

    /// 视频播放的url
    var playerUrl: String?
    /// 弹幕的数据数组
    var danmuModelArray: [danmuModel]?
    /// 视频的相关数据
    var detailModel: playDetailModel?
    
    func requestData(aid: Int,finishCallBack:@escaping ()->(),failueCallBack:@escaping ()->()) {
        
        let urlStr = "http://app.bilibili.com/x/view?actionKey=appkey&aid=\(aid)&appkey=27eb53fc9058f8c3&build=3380"
        println(urlStr)
        
        ZHNnetworkTool.requestData(.get, URLString: urlStr, finishedCallback: { (result) in
            let resultJson = JSON(result)
            // 1. 获取视频的相关数据
            self.detailModel = JSONDeserializer<playDetailModel>.deserializeFrom(dict: resultJson["data"].dictionaryObject as NSDictionary?)
            
            // 2. 获取播放的url和弹幕
            let dict = resultJson["data"]["pages"].array?.first?.dictionaryObject
            guard let cid = dict?["cid"] as? Int else {return}
            guard let page = dict?["page"] as? Int else {return}
            let group = DispatchGroup()
                // <1.获取视频播放的url
            group.enter()
            VideoURL.getWithAid(aid, cid: cid, page: page, completionBlock: { (url) in
                guard let urlStr = url?.absoluteString else {return}
                self.playerUrl = urlStr
                NotificationCenter.default.post(name: kgetPlayUrlSuccessNotification, object: nil)
                group.leave()
            })
                // <2.获取弹幕数据
            self.requestDanmuStatus(cid: cid, group: group)
            group.notify(queue: DispatchQueue.main, execute: {
                 finishCallBack()
            })
           
        }) { (error) in
                failueCallBack()
        }
    }
    
    
    func requestDanmuStatus(cid: Int,group: DispatchGroup) {
        group.enter()
        self.danmuModelArray?.removeAll()
        let URLString = "http://comment.bilibili.com/\(cid).xml"
        Alamofire.request(URLString, method: .get, parameters: nil).responseData { (response) in
            guard let result = try? XMLReader.dictionary(forXMLData: response.data) else {return}
            self.danmuModelArray = danmuModel.modelArray(dict: result)
            group.leave()
        }
    }
    
    func requestPagePlayUrl(page: Int,cid: Int,finishAction:@escaping (()->Void)) {
       
        let group = DispatchGroup()
        group.enter()
        VideoURL.getWithAid((detailModel?.aid)!, cid: cid, page: page, completionBlock: { (url) in
            guard let urlStr = url?.absoluteString else {return}
            self.playerUrl = urlStr
            NotificationCenter.default.post(name: kgetPlayUrlSuccessNotification, object: nil)
            group.leave()
        })
        requestDanmuStatus(cid: cid, group: group)
        group.notify(queue: DispatchQueue.main) { 
            finishAction()
        }
    }
    
}
