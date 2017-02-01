//
//  ZHNplayerDetailViewModel.swift
//  zhnbilibili
//
//  Created by 张辉男 on 16/12/30.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

let kdetailSectionHeight: CGFloat = 40

@objc protocol ZHNplayerDetailViewModelDelegate {
    @objc func ZHNplayerDetailViewModelSelectedRelates(aid: Int)
    @objc func ZHNplayerDetailViewModelReloadDetailCell(isfull: Bool)
    @objc func ZHNplayerDetailViewModelSelectedPage(cid: Int,index: Int)
    @objc func ZHNplayerDetailViewModelPushToHomePage(mid: Int)
}


enum sectionType {
    /// 顶部视频信息
    case topDetail
    /// 分集
    case pageDetail
    /// 用户数据
    case personDetail
    /// 标签
    case tagListDetail
    /// 相关数据
    case relatesDetail
    /// 就是个标题
    case relatesTitle
}

class ZHNplayerDetailViewModel: NSObject {
    
    /// 代理
    weak var delegate: ZHNplayerDetailViewModelDelegate?
    /// 是否是显示全部的deslabel
    var isfullDes = false
    /// 详细的数据
    var detailModel: playDetailModel? {
        didSet{
            
            // 计算section内row的数量
            for i in 0..<5 {
                if i == 4 {
                    if let relatesCount = detailModel?.relates?.count {
                        rowCountArray.append(relatesCount)
                    }else {
                        rowCountArray.append(0)
                    }
                }else {
                    rowCountArray.append(1)
                }
            }
            sectionCount = 5
            
            // 分集存不存在
            if ((detailModel?.pages) != nil) {
                if (detailModel?.pages?.count)! > 1 {
                    sectionCount = 6
                    rowCountArray.insert(1, at: 1)
                }
            }
            
            // 判断section的排列组合
            if sectionCount == 5 {
                sectionTypeArray = [.topDetail,.personDetail,.tagListDetail,.relatesTitle,.relatesDetail]
            }else if sectionCount == 6 {
                sectionTypeArray = [.topDetail,.pageDetail,.personDetail,.tagListDetail,.relatesTitle,.relatesDetail]
            }
        }
    }
    
    lazy var JCheightHelper: JCCollectionViewTagFlowLayout = {
        let JCheightHelper = JCCollectionViewTagFlowLayout()
        return JCheightHelper
    }()
    var sectionCount: Int = 0
    var rowCountArray = [Int]()
    var sectionTypeArray = [sectionType]()
}

//======================================================================
// MARK:- 公开的方法
//======================================================================
extension ZHNplayerDetailViewModel {
    
    /// 组的数量
    func creatSectionCount() -> Int {
        return sectionCount
    }
    
    /// 每组行的数量
    func createRowCount(section: Int) -> Int {
        return rowCountArray[section]
    }
    
    /// cell
    func createCell(indexPath: IndexPath,tableView: UITableView) -> UITableViewCell {
        let type = sectionTypeArray[indexPath.section]
        switch type {
        case .topDetail:
            let cell = ZHNplayerDetailStatusTableViewCell.instanceCell(tableView: tableView)
            cell.detailModel = detailModel
            cell.labelTapAction = {[weak self] (isfull: Bool) in
                self?.delegate?.ZHNplayerDetailViewModelReloadDetailCell(isfull: isfull)
            }
            
            /// 判断是否全屏
            if isfullDes {
                cell.isFull()
            }else {
                cell.isNormal()
            }
            cell.isFullDes = isfullDes
            return cell
            
        case .pageDetail:
            let cell = ZHNplayerPageListTableViewCell.instanceCell(tableView: tableView)
            cell.pagesArray = detailModel?.pages
            cell.pageSelectedAction = { [weak self] (cid: Int,index: Int) in
                self?.delegate?.ZHNplayerDetailViewModelSelectedPage(cid: cid,index: index)
            }
            return cell
            
        case .personDetail:
            let cell = ZHNplayerPersonDetailTableViewCell.instanceCell(tableView: tableView)
            cell.headTapAction = {[weak self] in
               self?.delegate?.ZHNplayerDetailViewModelPushToHomePage(mid: (self?.detailModel?.owner?.mid)!)
            }
            cell.detailModel = detailModel
            cell.clipsToBounds = true
            if detailModel?.elec == nil {
                cell.noElecCell()
            }
            return cell
            
        case .tagListDetail:
            let cell = ZHNplayerTagListTableViewCell.instanceCell(tableView: tableView)
            cell.tagValueList = tagListArray()
            return cell
            
        case .relatesDetail:
            let cell = ZHNplayerRelatesTableViewCell.relatesCellWithTableView(tableView: tableView)
            cell.detailModel = detailModel?.relates?[indexPath.row]
            cell.tapAction = { [weak self] (status: relatesModel) in
                self?.delegate?.ZHNplayerDetailViewModelSelectedRelates(aid: status.aid)
            }
            return cell
        case .relatesTitle:
            /// 这个高度的计算不是太准，有时候误差挺大
            return ZHNplayerRelatesTitleTableViewCell.instanceCell(tableView: tableView)
        }
    }
    
    func createHeight(section: Int) -> CGFloat {
        let type = sectionTypeArray[section]
        switch type {
        case .topDetail:
            if isfullDes {
                let height = (detailModel?.desc.heightWithConstrainedWidth(width: kscreenWidth - 20, font: UIFont.systemFont(ofSize: 12)))!
                if height > 34 {
                    return 210 + height - 10
                }else{
                    return 210
                }
            }
            return 210
        case .pageDetail:
            return 115
        case .personDetail:
            if detailModel?.elec != nil {
                return 230
            }else{
                return 70
            }
        case .tagListDetail:
            return JCheightHelper.calculateContentHeight(tagListArray()) + 40
        case .relatesDetail:
            return 100
        case .relatesTitle:
            return 40
        }
    }
}

//======================================================================
// MARK:- 私有的方法
//======================================================================
extension ZHNplayerDetailViewModel {
    fileprivate func tagListArray() -> [String] {
        var array = [String]()
        if let tags = detailModel?.tag {
            for tag in tags {
                array.append(tag.tag_name)
            }
        }
        return array
    }
}
