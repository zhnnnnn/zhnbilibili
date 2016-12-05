//
//  HomeLiveViewModel.swift
//  zhnbilibili
//
//  Created by zhn on 16/11/28.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

@objc protocol HomeLiveViewModelDelegate {
    @objc optional func HomeLiveViewModelReloadSetion(section:Int)
}

class HomeLiveViewModel {

    /// 存储数据的model
    var statusModelArray: [homeLiveItemModel] = [homeLiveItemModel]()
    /// banner的数组
    var bannerModelArray: [liveBannerModel]?
    /// 存放collectionview 每个section的数据数组的字典
    var reloadSectionDict = [String:Any]()
    /// 代理
    weak var delegate: HomeLiveViewModelDelegate?
    
    
}


//======================================================================
// MARK:- 请求数据
//======================================================================
extension HomeLiveViewModel {
    
    // 请求数据
    func requestDatas(finishCallBack:@escaping ()->(),failueCallBack:@escaping ()->()){
        
        // 1. 生成几个arra来暂时存放数据
        var commonAreaArray:[homeLiveItemModel]?
        var hotRecommendModel:homeLiveItemModel?
        
        // 2. 数据是从两个接口获取用group最后来同步数据
        let group = DispatchGroup()
        
        // 3. 请求各分区的数据
        group.enter()
        ZHNnetworkTool.requestData(.get, URLString: "http://live.bilibili.com/AppNewIndex/common?scale=2&device=phone&platform=ios", finishedCallback: { (result) in
            // <1. 获取到dict
            guard let resultDict = result as? [String:Any] else{return}
            // <2. 转成string
                // <<1.banner的数据
            let bannerJsonString = ZHNjsonHelper.getjsonArrayString(key: "banner", json: resultDict["data"])
                // <<2.普通分区的数据
            let areaJsonString = ZHNjsonHelper.getjsonArrayString(key: "partitions", json: resultDict["data"])
            // <3. 转模型
                // <<1.banner 数据
            if let bannerArray = JSONDeserializer<liveBannerModel>.deserializeModelArrayFrom(json: bannerJsonString){
                self.bannerModelArray = bannerArray as? [liveBannerModel]
            }
                // <<2.普通的数据
            if let commonArray = JSONDeserializer<homeLiveItemModel>.deserializeModelArrayFrom(json: areaJsonString){
                commonAreaArray = commonArray as? [homeLiveItemModel]
            }
    
            // <4. 每组显示4个row,拿下来的数据多于4处理一下
            if let commonAreaArray = commonAreaArray{
                for itemModel in commonAreaArray {
                    // <<1. 判断数据长度
                    guard let lives = itemModel.lives else {return}
                    guard lives.count > 4 else{return}
                    // <<2. 拿到前四组数据
                    var tempLives = [homeLiveDetailModel]()
                    for i in 0..<4{
                        let model = lives[i]
                        tempLives.append(model)
                    }
                    // <<3. 重新赋值
                    itemModel.lives = tempLives
                }
            }
            
            group.leave()
            }, errorCallBack: { (error) in
                // 错误的处理
                group.leave()
        })
        
        // 4. 请求推荐主播的数据
        group.enter()
        ZHNnetworkTool.requestData(.get, URLString: "http://live.bilibili.com/AppNewIndex/recommend?actionKey=appkey&appkey=27eb53fc9058f8c3&build=3970&buvid=937484d7e0997f66a821b1e335018212&device=phone&mobi_app=iphone&platform=ios&scale=2&sign=26d2146bb9aa27fcb847e5f50ff9700f&ts=1479285261", finishedCallback: { (result) in
            // <1. 获取到dict
            let jsonDict = JSON(result)
            // <2. 转成string
            let modelJson = jsonDict["data"]["recommend_data"].dictionaryObject
            // <3. 转模型
            if let hotModel = JSONDeserializer<homeLiveItemModel>.deserializeFrom(dict: modelJson as NSDictionary?){
                hotRecommendModel = hotModel
            }
            
            group.leave()
            }, errorCallBack: { (error) in
                // 错误的处理
                group.leave()
        })
        
        // 5.合并数据
        group.notify(queue: DispatchQueue.main) {
            
            // <2. 第一组的数据重新排列（具体不知道bilibili是什么策略，据我目测是最多三个分别加到上中下三个位置）
            self.dealFirstSectionData(hotRecommendModel: hotRecommendModel)

            // <3. 合并数据赋值数据
            guard let hotRecommendModel = hotRecommendModel else{return}
            commonAreaArray?.insert(hotRecommendModel, at: 0)
            guard let commonAreaArray = commonAreaArray else{return}
            self.statusModelArray = commonAreaArray
            
            // <4. 失败或者成功的回调
            if self.statusModelArray.count > 0 {
                finishCallBack()
            }else {
                failueCallBack()
            }
        }
    }
}


//======================================================================
// MARK:- datasource方法
//======================================================================
extension HomeLiveViewModel {
    
    // 生成cell
    func createCell(collectionView:UICollectionView,indexPath:IndexPath) -> UICollectionViewCell {
        
        // 1. 获取数据
        let sectionModel = statusModelArray[indexPath.section]
        let rowModel = sectionModel.lives?[indexPath.row]
        
        // 2. 拿到cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kliveCellreuseKey, for: indexPath) as! liveShowCell
        
        // 3. 赋值数据
        // <<1. 判断是不是需要显示area (需要先赋值这个属性)
        if indexPath.section == 0 {
            cell.isNeedShowArea = true
        }else {
            cell.isNeedShowArea = false
        }
        // <<2. 赋值数据
        if let rowModel = rowModel {
            let itemModel = creatItemModel(liveModel: rowModel)
            cell.statusModel = itemModel
            cell.sonStatusModel = itemModel
        }
        
        // 4. 判断是不是最后一个数据
        if indexPath.row == (sectionModel.lives?.count)!-1 {
            cell.showReloadButton = true
        }else{
            cell.showReloadButton = false
        }
        
        cell.delegate = self
        cell.selectedSection = indexPath.section
        cell.sectiontype = sectionModel.partition?.area
        return cell
    }
    
    func createHeadorFoot(kind:String,collectionView:UICollectionView,indexPath:IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader{// head
            // 1.拿到数据
            let sectionModel = statusModelArray[indexPath.section]
            // 2.生成cell
            let head = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: khomeLiveheadReuseKey, for: indexPath) as! homeLivehead
            // 3.赋值数据
            head.headModel = sectionModel.partition
            
            // 4. 赋值banner的数据
            if indexPath.section == 0{
                head.bannerModelArray = bannerModelArray
            }
            
            return head
        }else{// foot
            let foot = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: khomeLiveFootReuseKey, for: indexPath)
            return foot
        }
    }
    
    // 返回每组的数据
    func returnRowCount(section:Int) -> Int {
        if let count = statusModelArray[section].lives?.count {
            return count
        }else{
            return 0
        }
    }

}

//======================================================================
// MARK:- layout delegate 方法
//======================================================================
extension HomeLiveViewModel {
    
    // 计算 itemsize
    func calculateItemSize(indexPath: IndexPath) -> CGSize {
        
        // 1.拿到数据
        let sectionModel = statusModelArray[indexPath.section]
        let rowModel = sectionModel.lives?[indexPath.row]
        
        // 2.判断数据
        if let rowModel = rowModel {
            if rowModel.is_hotBanner {
                return CGSize(width: kscreenWidth - 2 * kpadding, height: 160)
            }else{
                let width = (kscreenWidth - 3*kpadding)/2
                let height:CGFloat = 160
                return CGSize(width: width, height: height)
            }
        }
        
        // 3. 返回默认的数据
        let width = (kscreenWidth - 3*kpadding)/2
        let height:CGFloat = 160
        return CGSize(width: width, height: height)
    }
    
    // head的高度
    func calculateHeadHeight(section: Int) -> CGSize {
        if section == 0{
            return CGSize(width: kscreenWidth, height: 40 + kcarouselHeight + khomeLiveMenuHeight)
        }else{
            return CGSize(width: kscreenWidth, height: 50)
        }
    }
    
    // foot的size
    func calculateFootHeight(section: Int) -> CGSize {
        if section == statusModelArray.count - 1{
            return CGSize(width: kscreenWidth, height: 65)
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
    
}

//======================================================================
// MARK:- normalBaseCell 的代理
//======================================================================
extension HomeLiveViewModel: normalBaseCellDelegate {
    
    func normalBaseReloadSection(section: Int, type: String?) {
        reloadSectionDataWithType(type: type, section: section)
    }
    
}

//======================================================================
// MARK:- 私有方法
//======================================================================
extension HomeLiveViewModel {
    
    fileprivate func creatItemModel(liveModel: homeLiveDetailModel) -> itemDetailModel{
        let itemModel = itemDetailModel()
        itemModel.name = liveModel.owner?.name
        itemModel.title = liveModel.title
        itemModel.area = liveModel.area
        itemModel.online = liveModel.online
        itemModel.cover = liveModel.cover?.src
        itemModel.corner = liveModel.corner
        return itemModel
    }
    
    fileprivate func reloadSectionDataWithType(type: String?,section: Int) {
    
        guard let type = type else {return}
        let urlString = HomeLiveReloadURLhelper.createReloadSectionURL(area: type)
        ZHNnetworkTool.requestData(.get, URLString: urlString, finishedCallback: { (result) in
           
            if type == "hot" {// 1. 推荐的数据
                // <1. 获取到dict
                let jsonDict = JSON(result)
                // <2. 转成string
                let modelJson = jsonDict["data"].dictionaryObject
                // <3. 转模型
                let hotModel = JSONDeserializer<homeLiveItemModel>.deserializeFrom(dict: modelJson as NSDictionary?)
                // <4. 处理成展示的array排列
                self.dealFirstSectionData(hotRecommendModel: hotModel)
                // <5. 赋值给数据
                if let hotModel = hotModel{
                    self.statusModelArray[0] = hotModel
                }
            }else{// 2. 普通的数据
                //
                // 这里偷懒了啊, 每次返回的array长度为10 显示的长度为4.完全可以吧这个10先缓存起来，没有缓存的时候再去加载网络的数据
                //
                // <1. 获取到dict
                guard let resultDict = result as? [String:Any] else{return}
                // <2. 转成string
                let resultString = ZHNjsonHelper.getjsonArrayString(key: "data", json: resultDict)
                // <3. 转成model
                let commonModelArray = JSONDeserializer<homeLiveDetailModel>.deserializeModelArrayFrom(json: resultString)
                // <4. 处理长度 每个row4行
                guard let count = commonModelArray?.count else {return}
                guard  count > 4 else{return}
                var tempArray = [homeLiveDetailModel]()
                for i in 0..<4{
                    guard let model = commonModelArray?[i] else {return}
                    tempArray.append(model)
                }
                self.statusModelArray[section].lives = tempArray
            }
            
            // 3. 通知代理
            if let delegate = self.delegate {
                if let method = delegate.HomeLiveViewModelReloadSetion{
                    method(section)
                }
            }
            }, errorCallBack: { (error) in
                // 错误的处理
        })
    }
    
    fileprivate func dealFirstSectionData(hotRecommendModel: homeLiveItemModel?) {
        
        guard let maxCount = hotRecommendModel?.lives?.count else {return}
        if hotRecommendModel?.banner_data?.count == 1 {
            // 拿到数据插入到最中间
            if let model = hotRecommendModel?.banner_data?.first {
                model.is_hotBanner = true
                hotRecommendModel?.lives?.insert(model, at: maxCount/2)
            }
        }else if hotRecommendModel?.banner_data?.count == 2{
            // <<1. 插入最上面
            if let firstModel = hotRecommendModel?.banner_data?.first{
                firstModel.is_hotBanner = true
                hotRecommendModel?.lives?.insert(firstModel, at: 0)
            }
            // <<2. 插入最中间
            if let lastModel = hotRecommendModel?.banner_data?.last{
                lastModel.is_hotBanner = true
                hotRecommendModel?.lives?.insert(lastModel, at: maxCount/2 + 1)
            }
        }else if hotRecommendModel?.banner_data?.count == 3{
            
            // <<1. 插入最上面
            if let firstModel = hotRecommendModel?.banner_data?.first{
                firstModel.is_hotBanner = true
                hotRecommendModel?.lives?.insert(firstModel, at: 0)
            }
            // <<3. 插入中间
            if let midModel = hotRecommendModel?.banner_data?[1]{
                midModel.is_hotBanner = true
                hotRecommendModel?.lives?.insert(midModel, at: 0)
            }
            
            // <<3. 插入最下面
            if let lastModel = hotRecommendModel?.banner_data?.last{
                lastModel.is_hotBanner = true
                hotRecommendModel?.lives?.insert(lastModel, at: maxCount + 1)
            }
        }
    }
    
}




