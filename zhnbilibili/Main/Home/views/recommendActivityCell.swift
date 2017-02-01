//
//  recommendActivityCell.swift
//  zhnbilibili
//
//  Created by zhn on 16/11/24.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class recommendActivityCell: UICollectionViewCell {
    
    let kactivityReuseKey = "kactivityReuseKey"
    // cell的宽高
    let cellheight: CGFloat = 150
    var cellWidth: CGFloat {
        return (kscreenWidth - kpadding)/2
    }
    
    var statusArray:[itemDetailModel]? {
        didSet{
            DispatchQueue.main.async {
               self.mainCollectionView.reloadData()
            }
        }
    }
    
    // MARK: - 懒加载
    lazy var mainCollectionView: UICollectionView = {[weak self] in
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        flowLayout.minimumLineSpacing = kpadding
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize(width: (self?.cellWidth)!, height: (self?.cellheight)!)
        let mainCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: kscreenWidth, height: 150), collectionViewLayout: flowLayout)
        mainCollectionView.backgroundColor = UIColor.white
        mainCollectionView.showsVerticalScrollIndicator = false
        mainCollectionView.showsHorizontalScrollIndicator = false
        mainCollectionView.contentInset = UIEdgeInsets(top: 0, left: kpadding, bottom: 0, right: kpadding)
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.backgroundColor = kHomeBackColor
        mainCollectionView.register(normalBaseCell.self, forCellWithReuseIdentifier: (self?.kactivityReuseKey)!)
        return mainCollectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(mainCollectionView)
        self.backgroundColor = kHomeBackColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mainCollectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 代理方法
extension recommendActivityCell:UICollectionViewDelegate {
    
}

// MARK: - 数据源
extension recommendActivityCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (statusArray?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 1. 生成cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kactivityReuseKey, for: indexPath) as! normalBaseCell
        // 2. 获取赋值数据
        let statusModel = statusArray?[indexPath.row]
        cell.statusModel = statusModel
        // 3. 返回cell
        return cell
    }
}

