//
//  ZHNhomePageSeasonCell.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/15.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit


let kbangumiSelectedNotification = Notification.Name("kbangumiSelectedNotification")
let kbangumiModelKey = "kbangumiModelKey"
class ZHNhomePageSeasonCell: ZHNhomePageBaseTableViewCell {

    // MARK - 属性
    var seasonModel: ZHNhomePageSeasonModel? {
        didSet {
            contentCollectionView.reloadData()
            guard let seasonCount = seasonModel?.count else {return}
            count = seasonCount
        }
    }
    
    // MARK - 懒加载控件
    lazy var contentCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: (kscreenWidth - 50)/3, height: 160)
        flowLayout.minimumLineSpacing = kpadding
        let contentCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        contentCollectionView.delegate = self
        contentCollectionView.dataSource = self
        contentCollectionView.register(ZHNhomePageSeasonCollectionViewCell.self, forCellWithReuseIdentifier: "seasonCell")
        contentCollectionView.backgroundColor = kHomeBackColor
        return contentCollectionView
    }()
    
    // MARK - life cycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = kHomeBackColor
        name = "TA的追番"
        self.addSubview(contentCollectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(headNoticeView.snp.bottom)
            make.bottom.equalTo(lineView.snp.top)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
        }
    }

}

//======================================================================
// MARK:- UIcollectionview delegate datasource
//======================================================================
extension ZHNhomePageSeasonCell: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = seasonModel?.count else {return 0}
        return count > 3 ? 3 : count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = contentCollectionView.dequeueReusableCell(withReuseIdentifier: "seasonCell", for: indexPath) as! ZHNhomePageSeasonCollectionViewCell
        cell.detailModel = seasonModel?.item?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let itemModel = seasonModel?.item?[indexPath.row] else {return}
        ZHNnotificationHelper.bangumiItemSelected(bangumiModel: itemModel)
    }
}

