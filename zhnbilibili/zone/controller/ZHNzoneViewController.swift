//
//  ZHNzoneViewController.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/6.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit

let kzoneCellReuseKey = "kzoneCellReuseKey"
let khomeViewControllerShowLIVEnotification = Notification.Name("khomeViewShowLIVEnotification")
class ZHNzoneViewController: ZHNBaseViewController {
    
    // viewModel
    var zoneVM = ZHNzoneViewModel()
    // MARK - 懒加载控件
    lazy var contentCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize(width: kscreenWidth/3, height: (kscreenHeight - knavibarHeight)/6)
        let contentCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        contentCollectionView.backgroundColor = UIColor.white
        contentCollectionView.delegate = self
        contentCollectionView.dataSource = self
        contentCollectionView.register(ZHNzoneCollectionViewCell.self, forCellWithReuseIdentifier: kzoneCellReuseKey)
        contentCollectionView.layer.cornerRadius = 10
        contentCollectionView.backgroundColor = kHomeBackColor
        contentCollectionView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        return contentCollectionView
    }()
    // MARK - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1. 加载ui
        setupUI()
        // 2. 加载数据
        requestData()
    }
}

//======================================================================
// MARK:- 私有方法
//======================================================================
extension ZHNzoneViewController {
    
    fileprivate func setupUI() {
        view.addSubview(contentCollectionView)
        contentCollectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(knavibarHeight, 0, 0, 0))
        }
        view.backgroundColor = knavibarcolor    
        naviBar.titleLabel.text = "分区"
        naviBar.backArrowButton.isHidden = true
    }
    
    fileprivate func requestData() {
        zoneVM.requestData {[weak self] in
            self?.contentCollectionView.reloadData()
        }
    }
}

//======================================================================
// MARK:- collectionView delegate datasource
//======================================================================
extension ZHNzoneViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return zoneVM.zoneModelArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kzoneCellReuseKey, for: indexPath) as! ZHNzoneCollectionViewCell
        let model = zoneVM.zoneModelArray[indexPath.row]
        cell.statusModel = model
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 1. 拿到数据
        let zoneModel = zoneVM.zoneModelArray[indexPath.row]
        // 2. 赋值数据
        if zoneModel.name == "直播" {
            tabBarController?.selectedIndex = 0
            NotificationCenter.default.post(name: khomeViewControllerShowLIVEnotification, object: nil)
        }else if zoneModel.name == "游戏中心"{
        
        }else {
            let VC = ZHNzoneDetailViewController()
            VC.zoneModel = zoneModel
            navigationController?.pushViewController(VC, animated: true)
        }
    }
}
