//
//  recommendViewModel.swift
//  zhnbilibili
//
//  Created by zhn on 16/11/21.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit
import HandyJSON

@objc protocol recommendViewModelDelegate {
    @objc optional func recommendViewModelReloadSetion(section:Int)
}

class recommendViewModel {
    
    // MARK: - 共有属性
    /// 整个collectionview的数据数组
    var statusArray: Array<recommendModel> = [recommendModel]()
    /// 存放collectionview 每个section的数据数组的字典
    var reloadSectionDict = [String:Any]()
    /// 代理
    weak var delegate: recommendViewModelDelegate?
 
    // MARK: - 私有属性
    /// item size 的数组
    fileprivate var itemSizeArray = [CGSize]()
    /// head size 的数组
    fileprivate var headSizeArray = [CGSize]()
    /// foot size 的数组
    fileprivate var footSizeArray = [CGSize]()
    /// edgeinsets 的数组
    fileprivate var edgeInsetsArray = [UIEdgeInsets]()
}


//======================================================================
// MARK:- 请求数据
//======================================================================
extension recommendViewModel {
    
    /// 获取首页推荐的数据 (接口有加密过只能用这种猥琐的方式了)
    func requestDatas(finishCallBack:@escaping ()->(),failueCallBack:@escaping ()->()){
        
        ZHNnetworkTool.requestData(.get, URLString: "http://app.bilibili.com/x/v2/show?access_key=c58e470c0dcbab355c42ebd5cfb22db4&actionKey=appkey&appkey=27eb53fc9058f8c3&build=3970&channel=appstore&device=phone&mobi_app=iphone&plat=1&platform=ios&sign=1e9e45248b865d603bff41e73750f436&ts=1479282458&warm=1", finishedCallback: { (result) in
                // 1.获取json array 数组
                let resultStr = ZHNjsonHelper.getjsonArrayString(key: "data", json: result)
            
                // 2.字典转模型
                if let modelArray = JSONDeserializer<recommendModel>.deserializeModelArrayFrom(json:resultStr){
                self.statusArray = modelArray as! Array<recommendModel>
                // 3.设置一下自己的type
                for model in self.statusArray{
                    model.setHomeStatusType()
                }
                // 4.初始化所有的size数组(先计算好在保存起来，对性能略微有点提升)
                self.initSizeArrays()
                    
                finishCallBack()
            }
            }) { (error) in
                // 错误的回调
                failueCallBack()
        }
    }
}

//======================================================================
// MARK:- datasource
//======================================================================
extension recommendViewModel {
    
    /// 生成cell
    func creatCell(collectionView:UICollectionView,indexPath:IndexPath) -> UICollectionViewCell {
        
        // 1. 拿到section数据
        let sectionModel = statusArray[indexPath.section]
        
        // 2. 活动中心特殊处理
        if sectionModel.sectionType == homeStatustype.activity{// 推荐
            // <1.生成cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kactivitycellReuseKey, for: indexPath) as! recommendActivityCell
            // <2.获取数据
            let statusArray = sectionModel.body
            // <3.赋值数据
            cell.statusArray = statusArray
            // <4.返回cell
            return cell
        }else{
            // <1.拿到row的数据
            let model = sectionModel.body[indexPath.row]
            // <2. 生成cell
            if sectionModel.sectionType == homeStatustype.live{ // 直播
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kliveCellreuseKey, for: indexPath) as! liveShowCell
                // <<1. 赋值数据
                cell.statusModel = model
                cell.sonStatusModel = model
                // <<2. 父类的数据赋值
                initCellStatusWithSectionModel(sectionModel: sectionModel, cell: cell, indexPath: indexPath)
                return cell
            }else if sectionModel.sectionType == homeStatustype.bangumi {// 番剧
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kbanmikuCellreuseKey, for: indexPath) as! banmikuShowCell
                // <<1. 赋值数据
                cell.statusModel = model
                cell.sonStatusModel = model
                // <<2. 父类的数据赋值
                initCellStatusWithSectionModel(sectionModel: sectionModel, cell: cell, indexPath: indexPath)
                return cell
            }else{// 普通
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kcommenAreaCell, for: indexPath) as! commenAreaCell
                // <<1. 赋值数据
                cell.statusModel = model
                cell.sonStatusModel = model
                // <<2. 父类的数据赋值
                initCellStatusWithSectionModel(sectionModel: sectionModel, cell: cell, indexPath: indexPath)
                return cell
            }
            
        }
    }
    
    
    fileprivate func initCellStatusWithSectionModel(sectionModel:recommendModel,cell:normalBaseCell,indexPath:IndexPath){
        
        // 1. 设置代理
        cell.delegate = self
        // 2. 判断是否是最后一组 （番剧也没有刷新功能）
        if indexPath.row == (sectionModel.body.count - 1) && sectionModel.sectionType != homeStatustype.bangumi{
            cell.showReloadButton = true
        }else{
            cell.showReloadButton = false
        }
        // 3. 传递section的信息
        cell.sectiontype = sectionModel.type
        cell.selectedSection = indexPath.section
    }
    
    
    /// 生成head 或者 foot
    func createFootOrHead(kind:String,collectionView:UICollectionView,indexPath:IndexPath) -> UICollectionReusableView {
        
        // 1. 获取数据
        let sectionModel = statusArray[indexPath.section]
        
        // 1. 设置header
        if kind == UICollectionElementKindSectionHeader {
            
            // <1. 生成header
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kheaderreuseKey, for: indexPath) as! recommondhead
            
            // <2. 判断headr的类型 （这种reuse的view需要注意清空状态）
            if let banner = sectionModel.banner?.top {
                if banner.count > 0 {
                    header.type = .hotrecommend
                }else{
                    header.type = .normal
                }
            }else{
                header.type = .normal
            }
            
            // <3. 赋值数据
            header.statusModel = sectionModel
            
            return header
            
            // 2.设置footer
        }else{
            
            // <1.生成footer
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: kfooterreuseKey, for: indexPath) as! recommendFoot
            
            // <2.判断footer类型
            let type = recommendFoot.returnFootType(statusModel: sectionModel)
            footer.type = type
            
            // <3.赋值数据
            footer.statusModel = sectionModel
            
            return footer
        }
    }
    
    
    
    // 计算section里有多少行
    func calculateRowCount(section:Int) -> Int {
        
        // 1.拿到数据
        let itemModel = statusArray[section]
        
        // 2.活动中心特殊处理
        if(itemModel.sectionType == homeStatustype.activity){
            return 1
        }else{
            return itemModel.body.count
        }
    }
}

//======================================================================
// MARK:- layout delegate
//======================================================================
extension recommendViewModel {
    
    // 计算 itemsize
    func calculateItemSize(section:Int) -> CGSize {
        return itemSizeArray[section]
    }
    
    // 计算section的inset
    func calculateSectionInset(section:Int) -> UIEdgeInsets {
        return edgeInsetsArray[section]
    }
    
    // 计算head的size
    func calulateSectionHeadSize(section:Int) -> CGSize {
        return headSizeArray[section]
    }
    
    
    // 计算foot的size
    func calulateSectionfootSize(section:Int) -> CGSize {
        return footSizeArray[section]
    }
    
}

//======================================================================
// MARK:- base cell的代理方法
//======================================================================
extension recommendViewModel: normalBaseCellDelegate {
    
    func normalBaseReloadSection(section: Int, type: String?) {
        
        // 1. type不存在就不做处理
        guard let type = type else {return}
        
        // 2. 推荐一组6个数据 其他的都是4个数据
        let sectionRowCount = type == "recommend" ? 6 : 4
        
        // 3. 拿到section的model
        let currentSectionModel = statusArray[section]
        
        // 4. 拿到当前组的title（当中cache的key）
        guard let typeTitleString = currentSectionModel.title  else {return}
        
        // 5.没有数据的情况
        guard let sectionArray = reloadSectionDict[type] as? [itemDetailModel] else {
            if let sectionType = currentSectionModel.sectionType{
                let urlStr =  recommendURLhelper.createSectionReloadURLStr(type: sectionType,tid:currentSectionModel.param)
                loadSectionData(url: urlStr, type: sectionType, typeString: typeTitleString, sectionRowCount: sectionRowCount, section: section)
            }
            return
        }
        
        // 6. 有数据的情况
            // <1数据不够的情况
        if sectionArray.count < sectionRowCount {
            if let sectionType = currentSectionModel.sectionType{
                let urlStr =  recommendURLhelper.createSectionReloadURLStr(type: sectionType,tid:currentSectionModel.param)
                loadSectionData(url: urlStr, type: sectionType, typeString: typeTitleString, sectionRowCount: sectionRowCount, section: section)
            }
            
        }else{ // <2数据够的情况
            resetDatas(sectionRowCount: sectionRowCount, section: section, typeString: typeTitleString, sectionArray: sectionArray)
        }
    }
}



//======================================================================
// MARK:- 私有方法
//======================================================================
extension recommendViewModel {
    
    fileprivate func loadSectionData(url:String,type:homeStatustype,typeString:String,sectionRowCount:Int,section:Int){
        
        ZHNnetworkTool.requestData(.get, URLString: url, finishedCallback: { (result) in
            
            if type == .recommend || type == .live {// 1. 热门推荐和直播推荐的数据结构不一样
                
                // 1.获取json array 数组
                let resultStr = ZHNjsonHelper.getjsonArrayString(key: "data", json: result)
                
                // 2.字典转模型
                if let modelArray = JSONDeserializer<itemDetailModel>.deserializeModelArrayFrom(json:resultStr){
                    
                    // 1. 重新生成一个statusarray
                    let newModelArray = modelArray as! Array<itemDetailModel>
                    self.resetDatas(sectionRowCount: sectionRowCount, section: section, typeString: typeString, sectionArray: newModelArray)
                    
                }
                    
            }else{// 2. 其他类型的section做处理
                
                // <1.获取json array 数组
                let resultStr = ZHNjsonHelper.getjsonArrayString(key: "list", json: result)

                // <2.字典转模型
                if let modelArray = JSONDeserializer<recommendSectionReloadModel>.deserializeModelArrayFrom(json:resultStr){
                    
                    // <<1. 拿到数据
                    let newModelArray = modelArray as! Array<recommendSectionReloadModel>
                    // <<2. 转到itemmodel
                    var itemModelArray = [itemDetailModel]()
                    for model in newModelArray {
                        let item = itemDetailModel()
                        item.play = model.play
                        item.danmaku = model.video_review
                        item.title = model.title
                        item.cover = model.pic
                        itemModelArray.append(item)
                    }
                    // <<3.重新生成一个statusarray
                    self.resetDatas(sectionRowCount: sectionRowCount, section: section, typeString: typeString, sectionArray: itemModelArray)
                    
                }
            }
            
            }, errorCallBack: { (error) in
                // 错误的处理
        })
        
    }
    
    fileprivate func resetDatas(sectionRowCount:Int,section:Int,typeString:String,sectionArray:[itemDetailModel]) {
        
        // 1.如果数据够的话就拿到数据
        var newSectionArray = [itemDetailModel]()
        for i in 0..<sectionRowCount{
            let sectionModel = sectionArray[i]
            newSectionArray.append(sectionModel)
        }
        
        // 2.新的数据替换旧的数据
        let oldModel = statusArray[section]
        oldModel.body = newSectionArray
        
        // 3.删除掉添加过的数据
        var addToDictArray = sectionArray
        for _ in 0..<sectionRowCount{
            addToDictArray.removeFirst()
        }
        
        // 4.保存数据
        reloadSectionDict[typeString] = addToDictArray
        
        // 5.通知代理
        if let delegate = delegate {
            if let method = delegate.recommendViewModelReloadSetion {
                method(section)
            }
        }
    }
    
    fileprivate func initSizeArrays() {
        
        for model in statusArray {
            // 1. itemzie
            if model.sectionType == homeStatustype.activity {
                itemSizeArray.append(CGSize(width: kscreenWidth, height: 160))
            }else{
                let width = (kscreenWidth - 3*kpadding)/2
                let height:CGFloat = 160
                itemSizeArray.append(CGSize(width: width, height: height))
            }
            // 2. headzise
            let headheight = recommondhead.returnHeadHeight(type: model.type!)
            headSizeArray.append(CGSize(width: kscreenWidth, height: headheight))
            // 3. foot size
            let footheight = recommendFoot.returnFoodHeight(statusModel: model)
            footSizeArray.append(CGSize(width: kscreenWidth, height: footheight))
            // 4. edgeinsets
            if model.sectionType == homeStatustype.activity {
                edgeInsetsArray.append(UIEdgeInsets.zero)
            }else{
                edgeInsetsArray.append(UIEdgeInsets(top: 0, left: kpadding, bottom: 0, right: kpadding))
            }
        }
    }
    
    
}




