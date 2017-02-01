//
//  ZHNhomePageViewModel.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/11.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON


enum homePageSectionType {
    
    /// 头部的视图
    case card
    
    /// 订阅直播
    case live
    
    /// 充电
    case elec

    /// 投稿
    case archive
    
    /// 游戏
    case game
    case gamePravite
    
    /// 标签
    case tage
    case tagePravite
    
    /// 番剧
    case season
    case seasonPravite
    
    /// 收藏夹
    case favourite
    case favouritePravite
    
    /// 投币
    case coinVideo
    case coinVideoPravite
}


class ZHNhomePageViewModel {
    
    /// 显示的数据
    var homePageModel: ZHNHomePageModel?
    /// 行的类别的数组
    var rowTypeArray = [homePageSectionType]()
    
    /// 计算tag高度
    let tagCellHeightHelper = JCCollectionViewTagFlowLayout()
}

//======================================================================
// MARK:- 公共的方法
//======================================================================
extension ZHNhomePageViewModel {
    
    func requestData(mid: Int,finishAction:@escaping (()->Void)) {
        print("http://app.bilibili.com/x/v2/space?build=3970&device=phone&mobi_app=1&platform=ios&vmid=\(mid)")
        ZHNnetworkTool.requestData(.get, URLString: "http://app.bilibili.com/x/v2/space?build=3970&device=phone&mobi_app=1&platform=ios&vmid=\(mid)", finishedCallback: { (result) in
            let resultJSON = JSON(result)
            self.homePageModel = JSONDeserializer<ZHNHomePageModel>.deserializeFrom(dict: resultJSON["data"].dictionaryObject as NSDictionary?)
            self.dealRowTypeArray()
            finishAction()
        }) { (error) in
        }
    }
    
    func caluateRowCount() -> Int{
        return rowTypeArray.count
    }
    
    func dealCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let type = rowTypeArray[indexPath.row]
        switch type {
        case .card:
            let cell = ZHNhomePageCardCell.cardCell(tableView: tableView)
            cell.cardModel = homePageModel?.card
            return cell
        case .live:
            return ZHNhomePageSubscibeLiveCell.sunscribeCell(tableView: tableView)
        case .elec:
            let cell = ZHNhomePageElecCell.normalInstanceCell(tableView: tableView) as! ZHNhomePageElecCell
            cell.elecView.elecList = homePageModel?.elec?.list
            return cell
        case .archive:
            let cell = ZHNhomePageArchiveCell.normalInstanceCell(tableView: tableView) as! ZHNhomePageArchiveCell
            cell.archiveModel = homePageModel?.archive
            return cell
        case .coinVideo:
            let cell = ZHNhomePageCoinCell.normalInstanceCell(tableView: tableView) as! ZHNhomePageCoinCell
            cell.coinModel = homePageModel?.coin_archive
            return cell
        case .tage:
            let cell = ZHNhomePageTageCell.normalInstanceCell(tableView: tableView) as! ZHNhomePageTageCell
            cell.taglist = homePageModel?.tag
            return cell
        case .season:
            let cell = ZHNhomePageSeasonCell.normalInstanceCell(tableView: tableView) as! ZHNhomePageSeasonCell
            cell.seasonModel = homePageModel?.season
            return cell
        case .favourite:
            let cell = ZHNhomePageFavoriteCell.normalInstanceCell(tableView: tableView) as! ZHNhomePageFavoriteCell
            cell.favitateModel = homePageModel?.favourite
            return cell
        case .favouritePravite,.coinVideoPravite,.seasonPravite,.tagePravite,.gamePravite:
            let cell = ZHNhomePagePraviteCell.normalInstanceCell(tableView: tableView) as! ZHNhomePagePraviteCell
            cell.type = type
            return cell
        default:
            return UITableViewCell()
        }

    }
    
    func caluateRowHeight(row: Int) -> CGFloat {
        
        let type = rowTypeArray[row]
        switch type {
        case .card:
            if let sign = homePageModel?.card?.sign {
                return 140 + sign.heightWithConstrainedWidth(width: kscreenWidth - 20, font: UIFont.systemFont(ofSize: 14))
            }else {
                return 140
            }
        case .live:
            return 80
        case .elec:
            return 160
        case .archive:
            if (homePageModel?.archive?.count)! >= 5 {// 这里偷懒了啊
                return 160 * 3 + 15 * 2 + 60
            }else if ((homePageModel?.archive?.count)! >= 3 && (homePageModel?.archive?.count)! <= 4) {
                return 160 * 2 + 15 + 60
            }else {
                return 160 + 60
            }
        case .tage:
            var tagNameArray = [String]()
            guard let taglist = homePageModel?.tag else {return 0}
            for tag in taglist {
                tagNameArray.append(tag.tag_name)
            }
            return tagCellHeightHelper.calculateContentHeight(tagNameArray) + 30
        case .coinVideo:
            return 220
        case .season:
            return 210
        case .favourite:
            return 170
        case .game:
            return 0
        case .favouritePravite,.coinVideoPravite,.seasonPravite,.tagePravite,.gamePravite:
            return 44
        }
    }
}

//======================================================================
// MARK:- 私有方法
//======================================================================
extension ZHNhomePageViewModel {

    fileprivate func dealRowTypeArray() {
        // 1. 头部的视图
        rowTypeArray.append(.card)
        // 2. 直播
        rowTypeArray.append(.live)
        // 3. 充能
        if let _ = self.homePageModel?.elec {
            rowTypeArray.append(.elec)
        }
        // 4. 投稿
        rowTypeArray.append(.archive)
        // 5. 投币
        if self.homePageModel?.setting?.coins_video == 0 {
            rowTypeArray.append(.coinVideoPravite)
        }else {
            rowTypeArray.append(.coinVideo)
        }
        // 6. 收藏夹
        if self.homePageModel?.setting?.fav_video == 0 {
            rowTypeArray.append(.favouritePravite)
        }else {
            rowTypeArray.append(.favourite)
        }
        // 7. 番剧
        if self.homePageModel?.setting?.bangumi == 0 {
            rowTypeArray.append(.seasonPravite)
        }else {
            rowTypeArray.append(.season)
        }
        // 8. 标签
        if self.homePageModel?.setting?.tags == 0 {
            rowTypeArray.append(.tagePravite)
        }else {
            rowTypeArray.append(.tage)
        }
        // 9. 游戏
        if self.homePageModel?.setting?.played_game == 0 {
            rowTypeArray.append(.gamePravite)
        }else {
            rowTypeArray.append(.game)
        }
        
        // 处理空值
        var tempArray = [homePageSectionType]()
        for type in rowTypeArray {
            if (!dealEmptyStatus(type: type)) {
                tempArray.append(type)
            }
        }
        rowTypeArray = tempArray
    }
    
    fileprivate func dealEmptyStatus(type: homePageSectionType) -> Bool {
       
        switch type {
        case .archive:
            guard let count = homePageModel?.archive?.item?.count else {return true}
            if count > 0 {
                return false
            }else {
                return true
            }
        case .coinVideo:
            guard let count = homePageModel?.coin_archive?.item?.count else {return true}
            if count > 0 {
                return false
            }else {
                return true
            }
        case .favourite:
            guard let count = homePageModel?.favourite?.item?.count else {return true}
            if count > 0 {
                return false
            }else {
                return true
            }
        case .season:
            guard let count = homePageModel?.season?.item?.count else {return true}
            if count > 0 {
                return false
            }else {
                return true
            }
        case .tage:
            guard let count = homePageModel?.tag?.count else {return true}
            if count > 0 {
                return false
            }else {
                return true
            }
        case .elec:
            guard let count = homePageModel?.elec?.list?.count else {return true}
            if count > 0 {
                return false
            }else {
                return true
            }
        default:
            return false
        }
    }
}
