//
//  ZHNplayerCommendViewModel.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/2.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

class ZHNplayerCommendViewModel {
    
    /// 热门评论的数据
    var hotCommendArray: [playCommendModel]?
    /// 普通评论的数据
    var normalCommendArray: [playCommendModel]?
    /// 数据数组
    var statusArray = [[playCommendModel]]()
    /// 是否包含热门
    var isContainerHot = false
    /// 组的数量
    var sectionCount = 1
    /// 每组的行数
    var rowCoutArray = [0]
}

//======================================================================
// MARK:- 对外的公共的方法
//======================================================================
extension ZHNplayerCommendViewModel {

    func reRequestData(aid: Int,page: Int,finishAction:@escaping (()->Void)) {
        hotCommendArray?.removeAll()
        normalCommendArray?.removeAll()
        statusArray.removeAll()
        isContainerHot = false
        hotCommendArray = nil
        normalCommendArray = nil
        requestData(aid: aid, page: page, finishAction: finishAction)
    }
    
    func requestData(aid: Int,page: Int,finishAction:@escaping (()->Void)) {
        let url = "http://api.bilibili.com/x/v2/reply?_device=iphone&_hwid=937484d7e0997f66&_ulv=0&access_key=&appkey=27eb53fc9058f8c3&appver=3970&build=3970&nohot=0&oid=\(aid)&platform=ios&pn=\(page)&ps=20&sign=c159d44677bad34e862f2fd555898733&sort=0&type=1"
        ZHNnetworkTool.requestData(.get, URLString: url, finishedCallback: { (result) in
            // 解析数据
            self.jsonToModel(result: result)
            // 成功的回回调
            finishAction()
        }) { (error) in
        }
    }
    
    func dealSectionCount() -> Int {
        return statusArray.count
    }
    
    func dealRowCount(section: Int) -> Int {
        let sectionArray = statusArray[section]
        return sectionArray.count
    }
    
    func cell(tableView: UITableView,indexPath: IndexPath) -> UITableViewCell {

        // 1. 创建cell
        let sectionArray = statusArray[indexPath.section]
        let model = sectionArray[indexPath.row]
        let cell = createCell(model: model, tableView: tableView)
        cell.commendModel = model
        // 2.需要强制layout不然rowheight不对
        cell.layoutIfNeeded()
        
        if isContainerHot {
            if indexPath.row == ((hotCommendArray?.count)! - 1) {
                cell.isHotSectionBottom = true
            }else {
                cell.isHotSectionBottom = false
            }
        }else {
            cell.isHotSectionBottom = false
        }
        return cell
    }
    
    func hotFooter(section: Int) -> UIView? {
        if isContainerHot {
            if section == 0 {
                // 1. 初始化
                let container = UIView()
                container.backgroundColor = kHomeBackColor
                let noticeLabel = UILabel()
                noticeLabel.text = "更多热门评论>>"
                noticeLabel.font = UIFont.systemFont(ofSize: 15)
                noticeLabel.textColor = knavibarcolor
                container.addSubview(noticeLabel)
                let leftLine = UIView()
                leftLine.backgroundColor = ktableCellLineColor
                container.addSubview(leftLine)
                let rightLine = UIView()
                rightLine.backgroundColor = ktableCellLineColor
                container.addSubview(rightLine)
                // 2. 位置初始化
                noticeLabel.snp.makeConstraints { (make) in
                    make.center.equalTo(container)
                }
                leftLine.snp.makeConstraints { (make) in
                    make.left.equalTo(container)
                    make.right.equalTo(noticeLabel.snp.left).offset(-5)
                    make.centerY.equalTo(noticeLabel)
                    make.height.equalTo(0.5)
                }
                rightLine.snp.makeConstraints { (make) in
                    make.right.equalTo(container)
                    make.left.equalTo(noticeLabel.snp.right).offset(5)
                    make.centerY.equalTo(noticeLabel)
                    make.height.equalTo(0.5)
                }
                return container
            }
        }
        return nil
    }
    
    func footerHeight(section: Int) -> CGFloat {
        if isContainerHot {
            if section == 0 {
                return 20
            }
        }
        return 0
    }
    
}

extension ZHNplayerCommendViewModel {
    fileprivate func createCell(model: playCommendModel, tableView: UITableView) -> ZHNcommendTableViewCell{
        if model.replies != nil && (model.replies?.count)! > 0{
            if model.replies?.count == 1 {
                return ZHNcommendTwoReplayCell.towSecCommendCell(tableView: tableView)
            }else if model.replies?.count == 2{
                return ZHNcommendThirdReplayCell.thirdSecCommendCell(tableView: tableView)
            }else {
                return ZHNcommendFourReplayCell.fourSecCommendCell(tableView: tableView)
            }
        }else {
            return ZHNcommendTableViewCell.commendCell(tableView: tableView)
        }
    }
    
    func jsonToModel(result: Any) {
        // 1. 解析数据
        let resultJson = JSON(result)
        let hotArrayStr = ZHNjsonHelper.getjsonArrayString(key: "hots", json: resultJson["data"].dictionaryObject!)
        let normalArrayStr = ZHNjsonHelper.getjsonArrayString(key: "replies", json: resultJson["data"].dictionaryObject!)
        
        // 2. 字典转模型
        if let temphotArray = JSONDeserializer<playCommendModel>.deserializeModelArrayFrom(json: hotArrayStr) as? [playCommendModel]{
            if self.hotCommendArray == nil {
                self.hotCommendArray = temphotArray
                if temphotArray.count > 0 {
                    self.isContainerHot = true
                    self.sectionCount = 2
                }
            }
        }
        if let tempCommendArray = JSONDeserializer<playCommendModel>.deserializeModelArrayFrom(json: normalArrayStr) as? [playCommendModel] {
            if self.normalCommendArray == nil {
                self.normalCommendArray = tempCommendArray
            }else {
                let old = self.normalCommendArray?.last
                let new = tempCommendArray.last
                if old?.floor != new?.floor {
                    self.normalCommendArray! += tempCommendArray
                }
            }
        }
        
        // 3. 计算一下row count
        if self.isContainerHot {
            self.statusArray.append(self.hotCommendArray!)
            self.statusArray.append(self.normalCommendArray!)
        }else {
            guard let normalCommendArray = self.normalCommendArray else {return}
            self.statusArray.append(normalCommendArray)
        }
    }
}


