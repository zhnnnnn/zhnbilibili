//
//  ZHNhomePageArchiveCell.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/13.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit

class ZHNhomePageArchiveCell: ZHNhomePageBaseTableViewCell {
    
    let karchiveCollectionViewCellReuseKey = "karchiveCollectionViewCellReuseKey"
    // MARK - 属性
    var archiveModel: ZHNhomePageArchiveModel? {
        didSet {
            if let archiveCount = archiveModel?.count {
                count = archiveCount
            }
            contentCollectionView.reloadData()
        }
    }
    // MARK - 懒加载
    lazy var contentCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: (kscreenWidth - 60)/2, height: 160)
        flowLayout.minimumLineSpacing = kpadding
        let contentCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        contentCollectionView.register(ZHNhomePageArchiveCollectionViewCell.self, forCellWithReuseIdentifier: self.karchiveCollectionViewCellReuseKey)
        contentCollectionView.contentInset = UIEdgeInsetsMake(0, 20, 0, 20)
        contentCollectionView.delegate = self
        contentCollectionView.dataSource = self
        contentCollectionView.backgroundColor = kHomeBackColor
        return contentCollectionView
    }()
    
    // MARK - life cycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 1. 标题上的数据设置
        name = "全部投稿"
        // 2.
        self.addSubview(contentCollectionView)
        contentCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(headNoticeView.snp.bottom)
            make.left.right.equalTo(self)
            make.bottom.equalTo(lineView.snp.top)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZHNhomePageArchiveCell: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = archiveModel?.count else {return 0}
        let fitCount = count > 6 ? 6 : count
        return fitCount
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: karchiveCollectionViewCellReuseKey, for: indexPath) as! ZHNhomePageArchiveCollectionViewCell
        cell.statusModel = archiveModel?.item?[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let model = archiveModel?.item?[indexPath.row] else {return}
        ZHNnotificationHelper.homePageSelectedNormalNotification(item: model)
    }
}

