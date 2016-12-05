//
//  HomeLiveShowViewController.swift
//  zhnbilibili
//
//  Created by zhn on 16/11/28.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit


let khomeLiveheadReuseKey = "khomeLiveheadReuseKey"
let khomeLiveFootReuseKey = "khomeLiveFootReuseKey"

class HomeLiveShowViewController: ZHNrabbitFreshBaseViewController {

    
    // MARK: - 私有属性
    fileprivate lazy var liveVM: HomeLiveViewModel = HomeLiveViewModel()
    
    // MARK: - 懒加载控件
    fileprivate lazy var maincollectionView: UICollectionView = {[unowned self] in
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = klinePadding
        flowLayout.minimumInteritemSpacing = kpadding
        let mainCollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.showsVerticalScrollIndicator = false
        // 注册cell foot head
        mainCollectionView.register(liveShowCell.self, forCellWithReuseIdentifier: kliveCellreuseKey)
        mainCollectionView.register(homeLivehead.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: khomeLiveheadReuseKey)
        mainCollectionView.register(HomeLiveFoot.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: khomeLiveFootReuseKey)
        return mainCollectionView
    }()
    
    lazy var startLivIngButton: UIButton = {
        let startLivIngButton = UIButton()
        startLivIngButton.backgroundColor = UIColor.ZHNcolor(red: 250, green: 91, blue: 136, alpha: 1)
        startLivIngButton.frame = CGRect(x: kscreenWidth - 80, y: kscreenHeight - 130, width: 60, height: 60)
        startLivIngButton.layer.cornerRadius = 30
        startLivIngButton.imageView?.contentMode = .center
        startLivIngButton.setImage(UIImage(named: "goLive"), for: .normal)
        startLivIngButton.setImage(UIImage(named: "goLive"), for: .highlighted)
        return startLivIngButton
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 加载数据
        loadDatas()
        
        liveVM.delegate = self
        view.addSubview(startLivIngButton)
    }
    
    // MARK: - 重写父类的方法
    //1. 初始化滑动view
    override func setUpScrollView() -> UIScrollView {
        return  maincollectionView
    }
    
    // 2. 刷新状态调用的方法
    override func startRefresh() {
        loadDatas()
    }
}

//======================================================================
// MARK:- 私有方法
//======================================================================
extension HomeLiveShowViewController {

    fileprivate func loadDatas() {
        liveVM.requestDatas(finishCallBack: {[weak self] in
            DispatchQueue.main.async {
                self?.maincollectionView.reloadData()
                self?.endRefresh(loadSuccess: true)
            }
            }, failueCallBack: {
                DispatchQueue.main.async {[weak self] in
                    self?.endRefresh(loadSuccess: false)
                }
        })
    }
}

extension HomeLiveShowViewController: HomeLiveViewModelDelegate{
    
    func HomeLiveViewModelReloadSetion(section: Int) {
        DispatchQueue.main.async {
            self.maincollectionView.reloadSections(IndexSet(integer: section))
        }
    }
}

//======================================================================
// MARK:- collectionView 的数据源
//======================================================================
extension HomeLiveShowViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return liveVM.statusModelArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return liveVM.returnRowCount(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { 
        return liveVM.createCell(collectionView: collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return liveVM.createHeadorFoot(kind: kind,collectionView: collectionView, indexPath: indexPath)
    }
    
}

//======================================================================
// MARK:- collectionView 的代理方法
//======================================================================
extension HomeLiveShowViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    }
    
}

//======================================================================
// MARK:- collectionView layout 的代理方法
//======================================================================
extension HomeLiveShowViewController: UICollectionViewDelegateFlowLayout{
    
    // 1. 每个section的inset
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: kpadding, bottom: 0, right: kpadding)
    }
    
    // 2.每个item的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return liveVM.calculateItemSize(indexPath: indexPath)
    }
    
    
    // 2.header的size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return liveVM.calculateHeadHeight(section:section)
    }
    
    // 3.footer的size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return liveVM.calculateFootHeight(section: section)
    }
}


