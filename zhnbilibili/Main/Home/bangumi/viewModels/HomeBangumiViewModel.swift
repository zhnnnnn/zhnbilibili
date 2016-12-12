//
//  HomeBangumiViewModel.swift
//  zhnbilibili
//
//  Created by zhn on 16/11/30.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

class HomeBangumiViewModel {
    
// MARK: - 私有属性
    // 新番
    fileprivate var previousModelArray = [HomeBangumiDetailModel]()
    // 连载
    fileprivate var serializingModelArray = [HomeBangumiDetailModel]()
    // 推荐连载
    fileprivate var bangumiRecommendArray = [HomeBangumiRecommendModel]()
// MARK: - 外部属性
    // banner的数组array
    var headBannerModelArray = [HomeBangumiADdetailModel]()
    // 第一个section底部的banner数组
    var bodyBannerModelArray = [HomeBangumiADdetailModel]()
    
    // 图片string的数组
    var headImageStringArray = [String]()
    var bodyImageStringArray = [String]()
    
    // 数据的数组
    var statusArray = [Any]()
    
    // 判断新番的月份
    var season: Int = 0
    
}

//======================================================================
// MARK:-  请求数据
//======================================================================
extension HomeBangumiViewModel {
    
    func requestDatas(finishCallBack:@escaping ()->(),failueCallBack:@escaping ()->()) {
        
        let netGroup = DispatchGroup()
        
        // 2. 获取新番和连载番剧的数据
        netGroup.enter()
        ZHNnetworkTool.requestData(.get, URLString: "http://bangumi.bilibili.com/api/app_index_page_v4?build=3970&device=phone&mobi_app=iphone&platform=ios", finishedCallback: { (result) in
            // 1. 转成json
            let resultJson = JSON(result)
            // 2. 转成模型
                // <1. 头部的banner
            let headArrayString = ZHNjsonHelper.getjsonArrayString(key: "head", json: resultJson["result"]["ad"].dictionaryObject)
            if let bannerHeadArray = JSONDeserializer<HomeBangumiADdetailModel>.deserializeModelArrayFrom(json: headArrayString){
                guard let bannerHeadArray = bannerHeadArray as? [HomeBangumiADdetailModel] else {return}
                self.headBannerModelArray = bannerHeadArray
            }
                // 2. top model array  -> string array
            self.headImageStringArray.removeAll()
            for head in  self.headBannerModelArray {
                guard let img = head.img else {return}
                self.headImageStringArray.append(img)
            }
            
                // <3. 第一组的底部的banner
            let bodyArrayString = ZHNjsonHelper.getjsonArrayString(key: "body", json: resultJson["result"]["ad"].dictionaryObject)
            if let bodyBannerArray = JSONDeserializer<HomeBangumiADdetailModel>.deserializeModelArrayFrom(json: bodyArrayString){
                guard let bodyBannerArray = bodyBannerArray as? [HomeBangumiADdetailModel] else {return}
                self.bodyBannerModelArray = bodyBannerArray
            }
                // <4. bottom model array -> string array
            self.bodyImageStringArray.removeAll()
            for body in  self.bodyBannerModelArray {
                guard let img = body.img else {return}
                self.bodyImageStringArray.append(img)
            }
        
                // <3. 新番
            let previousArrayString = ZHNjsonHelper.getjsonArrayString(key: "list", json: resultJson["result"]["previous"].dictionaryObject)
            if let previousModelArray = JSONDeserializer<HomeBangumiDetailModel>.deserializeModelArrayFrom(json: previousArrayString ){
                guard let previousModelArray = previousModelArray as? [HomeBangumiDetailModel] else {return}
                self.previousModelArray = previousModelArray
            }
            
                // <4. 连载番剧
            let serializingArrayString = ZHNjsonHelper.getjsonArrayString(key: "serializing", json: resultJson["result"].dictionaryObject)
            if let serializingModelArray = JSONDeserializer<HomeBangumiDetailModel>.deserializeModelArrayFrom(json: serializingArrayString){
                guard let serializingModelArray = serializingModelArray as? [HomeBangumiDetailModel] else {return}
                self.serializingModelArray = serializingModelArray
            }
            
                // <5. 拿到连载的新番的月份
            self.season = resultJson["result"]["previous"]["season"].int!
            
            netGroup.leave()
            }, errorCallBack: { (error) in
            // 错误的处理
                netGroup.leave()
        })
        
        // 3. 获取番剧推荐的数据
        netGroup.enter()
        ZHNnetworkTool.requestData(.get, URLString: "http://bangumi.bilibili.com/api/bangumi_recommend?actionKey=appkey&appkey=27eb53fc9058f8c3&build=3970&cursor=0&device=phone&mobi_app=iphone&pagesize=10&platform=ios&sign=a47247d303f51e1328a43c2d49c69051&ts=1479350934", finishedCallback: { (result) in
            // <1. 转成json
            let resultJson = JSON(result)
            // <2. 转modelarray
            let recommendArrayString = ZHNjsonHelper.getjsonArrayString(key: "result", json: resultJson.dictionaryObject)
            if let recommendArray = JSONDeserializer<HomeBangumiRecommendModel>.deserializeModelArrayFrom(json: recommendArrayString) {
                // <<1. 赋值
                guard let recommendArray = recommendArray as? [HomeBangumiRecommendModel] else {return}
                self.bangumiRecommendArray = recommendArray
                // <<2. 计算行高
                for model in recommendArray {
                    model.caluateRowHeight()
                }
            }
            
            netGroup.leave()
            }, errorCallBack: { (error) in
                failueCallBack()
                // 错误的处理
                netGroup.leave()
        })
        
        // 3. 合并数据
        netGroup.notify(queue: DispatchQueue.main) {
            // <1. 清空数据
            if self.serializingModelArray.count > 0 && self.previousModelArray.count > 0 && self.bangumiRecommendArray.count > 0 {
                self.statusArray.removeAll()
            }
            // <2. 添加数据
            self.statusArray.append(self.serializingModelArray)
            self.statusArray.append(self.previousModelArray)
            self.statusArray.append(self.bangumiRecommendArray)
          
            finishCallBack()
        }
    }
    
}

//======================================================================
// MARK:- datesource 方法
//======================================================================
extension HomeBangumiViewModel {
    // 组
    func sectionCount() -> Int {
        return statusArray.count
    }
    // 行
    func rowCount(section: Int) -> Int {
        guard let array:[Any] = statusArray[section] as? Array else {return 0}
        return array.count
    }
    // cell
    func createCell(collectionView: UICollectionView , indexPath: IndexPath) -> UICollectionViewCell {
        if  indexPath.section == 0 || indexPath.section == 1 {
            // 1. 拿到cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kbangumiALLCellReuseKey, for: indexPath) as! HomeBangumiNormalCell
            // 2. 赋值数据
            if let sectionModelArray = statusArray[indexPath.section] as? [HomeBangumiDetailModel] {
                let rowModel = sectionModelArray[indexPath.row]
                cell.bangumiDetailModel = rowModel
            }
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kbangumiRecommendReusekey, for: indexPath) as! HomeBangumiRecommendCell
            cell.recommendModel = bangumiRecommendArray[indexPath.row]
            return cell
        }
    }
    
    // head foot
    func createFootHeadView(kind:String,collectionView:UICollectionView,indexPath:IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader { // head
            
            if indexPath.section == 0 {
                let head = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: KbangumiBannerMenuReuseKey, for: indexPath) as! HomeBangumiTopView
                // banner的数据可能不存在
                if headImageStringArray.count > 0 {
                    head.isNoBanner = false
                    head.imgStringArray = headImageStringArray
                    head.bannerModelArray = headBannerModelArray
                }else{
                    head.isNoBanner = true
                }
                return head
            }else {
                let head = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kbangumiNormalHeadReuseKey, for: indexPath) as! HomeBangumiNormalHead
                head.section = indexPath.section
                if indexPath.section == 1 {
                    head.season = season
                }
                return head
            }

        }else{ // foot
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kbangumiBannerFootReuseKey, for: indexPath) as! HomeBangumiTopFoot
            footer.carouselView.intnetImageArray = bodyImageStringArray
            footer.modelArray = bodyBannerModelArray
            return footer
        }
    }
}

//======================================================================
// MARK:- layout delegate 方法
//======================================================================
extension HomeBangumiViewModel {

    func caluateItemSize(indexPath:IndexPath) -> CGSize {
        if indexPath.section == 2 {// 1. 推荐番剧
            let model = bangumiRecommendArray[indexPath.row]
            return CGSize(width: kscreenWidth - 2 * kpadding, height: CGFloat(model.rowHight))
        }else {// 2. 普通
             return CGSize(width: (kscreenWidth - 4 * kpadding)/3, height: 200)
        }
    }
    
    func caluateHeadSize(section:Int) -> CGSize {
        if  section == 0 {
            if headImageStringArray.count > 0 {
                return CGSize(width: kscreenWidth, height: 275)
            }else {
                return CGSize(width: kscreenWidth, height: 275 - kcarouselHeight)
            }
        }else {
            return CGSize(width: kscreenWidth, height: 40)
        }
    }
    
    func caluateFootSize(section:Int) -> CGSize {
        if section == 0 {
            if bodyImageStringArray.count > 0 {
                return CGSize(width: kscreenWidth, height: 90)
            }
            return CGSize(width: 0, height: 0)
        }else {
            return CGSize(width: 0, height: 0)
        }
    }
}



