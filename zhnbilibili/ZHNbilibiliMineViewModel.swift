//
//  ZHNbilibiliMineViewModel.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/25.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit

class ZHNbilibiliMineViewModel: NSObject {

    var itemNameArray = [
        ["离线缓存","历史记录","我的收藏","我的关注","我的钱包","会员积分","游戏中心","主题选择","大会员","","",""],
        ["回复我的","@我的","收到的赞","私信","系统通知","","",""]
    ]
    
    var itemImageNameArray = [
    ["mine_download","mine_history","mine_favourite","mine_follow","mine_pocketcenter","mine_intergal","mine_gamecenter","mine_theme","mine_vipmember","","",""],
        ["mine_answerMessage","mine_shakeMe","mine_gotPrise","mine_privateMessage","mine_systemNotification","","",""]
    ]
    
    
    func caluateSectionCount() -> Int {
        return 2
    }
    
    func caluateRowCount(section: Int) -> Int {
        return itemNameArray[section].count
    }
    
    func cell(collectionView: UICollectionView,indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kmineViewRuseKey, for: indexPath) as! ZHNbilibiliMeCollectionCell
        cell.name = itemNameArray[indexPath.section][indexPath.row]
        cell.iconImageName = itemImageNameArray[indexPath.section][indexPath.row]
        return cell
    }
    
    func headOrFoot(collectionView: UICollectionView,kind: String,indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let headView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kmineViewHeadRuseKey, for: indexPath) as! ZHNbilibiliMeCollectionHeadView
            if indexPath.section == 0 {
                headView.title = "个人中心"
                headView.isTopHead = true
            }else {
                headView.title = "我的消息"
                headView.isTopHead = false
            }
            return headView
        }else {
            let footView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: kmineViewFootRuseKey, for: indexPath) as! ZHNbilibiliMeCollectionfootView
            footView.backgroundColor = kHomeBackColor
            return footView
        }
    }
    
    
}
