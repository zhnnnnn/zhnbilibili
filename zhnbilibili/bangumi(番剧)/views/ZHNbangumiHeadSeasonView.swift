//
//  ZHNbangumiHeadSeasonView.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/21.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit

let kbangumiheadSeasonReuseKey = "kbangumiheadSeasonReuseKey"
fileprivate let kseasonCollectionCellTitleFont = UIFont.systemFont(ofSize: 14)
class ZHNbangumiHeadSeasonView: UIView {

    
    var seasonArray: [ZHNbangumiSeasonModel]? {
        didSet {
            guard let seasonArray = seasonArray else {return}
            for season in seasonArray {
                let width = season.title.widthWithConstrainedHeight(height: 1000, font: kseasonCollectionCellTitleFont)
                itemWidthArray.append(width)
            }
            contentCollectionView.reloadData()
        }
    }
    
    /// 宽度数组
    var itemWidthArray = [CGFloat]()
    
    // MARK - 懒加载控件
    lazy var contentCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let contentCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        contentCollectionView.delegate = self
        contentCollectionView.dataSource = self
        contentCollectionView.backgroundColor = kHomeBackColor
        contentCollectionView.register(ZHNbangumiHeadSeasonCollectionViewCell.self, forCellWithReuseIdentifier: kbangumiheadSeasonReuseKey)
        contentCollectionView.contentInset = UIEdgeInsetsMake(0, 20, 0, 20)
        return contentCollectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(contentCollectionView)
        self.backgroundColor = kHomeBackColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(15)
            make.bottom.equalTo(self).offset(-15)
            make.left.right.equalTo(self)
        }
    }
}

//======================================================================
// MARK:- collectionview delegate datasource
//======================================================================
extension ZHNbangumiHeadSeasonView: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = seasonArray?.count else {return 0}
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kbangumiheadSeasonReuseKey, for: indexPath) as! ZHNbangumiHeadSeasonCollectionViewCell
        cell.seasonModel = seasonArray?[indexPath.row]
        if indexPath.row == 0 {
            cell.type = .left
            cell.isShowingSeason = true
        }else if indexPath.row == (seasonArray?.count)! - 1 {
            cell.type = .right
        }else {
            cell.type = .center
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = itemWidthArray[indexPath.row] + 30
        return CGSize(width: width, height: 40)
    }
}


//======================================================================
// MARK:- cell
//======================================================================
enum bangumiHeadSeasonCellType: String {
    case left = "season_seasonLeft"
    case right = "season_seasonRight"
    case center = "season_seasonMiddle"
    
}

class ZHNbangumiHeadSeasonCollectionViewCell: UICollectionViewCell {
    
    var seasonModel: ZHNbangumiSeasonModel? {
        didSet {
            if let title = seasonModel?.title {
                titleLabel.text = title
            }
        }
    }
    
    var type: bangumiHeadSeasonCellType = .left {
        didSet {
            switch type {
            case .left:
                let imageStr = bangumiHeadSeasonCellType.left.rawValue
                let image = UIImage(named: imageStr)?.zhnResizingImage()
                backImageView.image = image
            case .right:
                let imageStr = bangumiHeadSeasonCellType.right.rawValue
                let image = UIImage(named: imageStr)?.zhnResizingImage()
                backImageView.image = image
            case .center:
                let imageStr = bangumiHeadSeasonCellType.center.rawValue
                let image = UIImage(named: imageStr)?.zhnResizingImage()
                backImageView.image = image
            }
        }
    }
    
    var isShowingSeason = false {
        didSet {
            if !isShowingSeason {return}
            var imageStr = bangumiHeadSeasonCellType.left.rawValue
            imageStr = "\(imageStr)_s"
            let image = UIImage(named: imageStr)?.zhnResizingImage()
            backImageView.image = image
        }
    }
    
    // MARK - cell 属性
    lazy var backImageView: UIImageView = {
        let backImageView = UIImageView()
        return backImageView
    }()
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = kseasonCollectionCellTitleFont
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(backImageView)
        self.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
    }
    
}

