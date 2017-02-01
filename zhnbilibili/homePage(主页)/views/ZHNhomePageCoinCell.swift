//
//  ZHNhomePageCoinCell.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/14.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit

class ZHNhomePageCoinCell: ZHNhomePageArchiveCell {

    var coinModel: ZHNhomePageCoinModel? {
        didSet {
            guard let coinCount = coinModel?.count else {return}
            guard let _ = coinModel?.item else {return}
            contentCollectionView.reloadData()
            count = coinCount
        }
    }

    // MARK - life cycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 1. 标题上的数据设置
        name = "最近投币"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZHNhomePageCoinCell {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = coinModel?.count else {return 0}
        let fitCount = count > 2 ? 2 : count
        return fitCount
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: karchiveCollectionViewCellReuseKey, for: indexPath) as! ZHNhomePageArchiveCollectionViewCell
        cell.statusModel = coinModel?.item?[indexPath.row]
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let model = coinModel?.item?[indexPath.row] else {return}
        ZHNnotificationHelper.homePageSelectedNormalNotification(item: model)
    }
}
