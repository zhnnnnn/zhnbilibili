//
//  HomebangumiViewController.swift
//  zhnbilibili
//
//  Created by zhn on 16/11/30.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

let kbangumiALLCellReuseKey = "kbangumiALLCellReuseKey"
let KbangumiBannerMenuReuseKey = "KbangumiBannerMenuReuseKey"
let kbangumiNormalHeadReuseKey = "kbangumiNormalHeadReuseKey"
let kbangumiBannerFootReuseKey = "kbangumiBannerFootReuseKey"
let kbangumiRecommendReusekey = "kbangumiRecommendReusekey"

class HomebangumiViewController: ZHNrabbitFreshBaseViewController {

    var bangumiVM = HomeBangumiViewModel()

    // MARK: - 懒加载控件
    fileprivate lazy var maincollectionView: UICollectionView = {[unowned self] in
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = kpadding
        let mainCollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.showsVerticalScrollIndicator = false
        
        // 注册cell foot head
        mainCollectionView.register(HomeBangumiNormalCell.self, forCellWithReuseIdentifier: kbangumiALLCellReuseKey)
        mainCollectionView.register(HomeBangumiRecommendCell.self, forCellWithReuseIdentifier: kbangumiRecommendReusekey)
        mainCollectionView.register(HomeBangumiTopView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: KbangumiBannerMenuReuseKey)
        mainCollectionView.register(HomeBangumiNormalHead.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kbangumiNormalHeadReuseKey)
        mainCollectionView.register(HomeBangumiTopFoot.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: kbangumiBannerFootReuseKey)
        return mainCollectionView
        }()
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // 加载数据
        loadDatas()
        
        NotificationCenter.default.addObserver(self, selector: #selector(carouselViewSelecLink(notification:)), name: kcarouselViewSelectedLiVENotification, object: nil)
    }

    // MARK: - 重载父类
    override func setUpScrollView() -> UIScrollView {
        return maincollectionView
    }

    override func startRefresh() {
        loadDatas()
    }
    
    // 移除监听
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}



//======================================================================
// MARK:- 私有方法
//======================================================================
extension HomebangumiViewController {
    
    fileprivate func loadDatas() {
        bangumiVM.requestDatas(finishCallBack: { [weak self] in
            DispatchQueue.main.async {
                self?.maincollectionView.reloadData()
                self?.endRefresh(loadSuccess: true)
            }
            }, failueCallBack: {
                DispatchQueue.main.async { [weak self] in
                    self?.maincollectionView.reloadData()
                    self?.endRefresh(loadSuccess: false)
                }
        })
    }
    
}

//======================================================================
// MARK:- collectionView 的数据源
//======================================================================
extension HomebangumiViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return bangumiVM.sectionCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bangumiVM.rowCount(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return bangumiVM.createCell(collectionView: collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return bangumiVM.createFootHeadView(kind: kind, collectionView: collectionView, indexPath: indexPath)
    }
    
}

//======================================================================
// MARK:- collectionView 的代理方法
//======================================================================
extension HomebangumiViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bangumiVC = ZHNbangumiDetailViewController()
        let model = bangumiVM.statusArray[indexPath.section]
        let modelArray = model as! Array<Any>
        let detailModel = modelArray[indexPath.row]
        if detailModel is HomeBangumiDetailModel {
            bangumiVC.bangumiDetailModel = (detailModel as! HomeBangumiDetailModel)
            _ = navigationController?.pushViewController(bangumiVC, animated: true)
        }else {
            let recommdendModel = detailModel as! HomeBangumiRecommendModel
            let bangumiWebVC = ZHNbilibiliWebViewController()
            bangumiWebVC.urlString = recommdendModel.link
            _ = navigationController?.pushViewController(bangumiWebVC, animated: true)
        }
    }
}

//======================================================================
// MARK:- collectionView layout 的代理方法
//======================================================================
extension HomebangumiViewController: UICollectionViewDelegateFlowLayout{
    
    // 1. 每个section的inset
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: kpadding, bottom: 0, right: kpadding)
    }
    
    // 2.每个item的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return bangumiVM.caluateItemSize(indexPath: indexPath)
    }
    
    // 3.header的size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return bangumiVM.caluateHeadSize(section: section)
    }
    
    // 4.footer的size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return bangumiVM.caluateFootSize(section: section)
    }
}

//======================================================================
// MARK:- banner 点击事件
//======================================================================
extension HomebangumiViewController {
    
    func carouselViewSelecLink(notification:Notification) {
        let userInfo = notification.userInfo
        guard let link = userInfo?[kcarouselSelectedUrlKey] as? String else {
            self.noticeError("url错误")
            return
        }
        let webController = ZHNbilibiliWebViewController()
        webController.urlString = link
        navigationController?.pushViewController(webController, animated: true)
    }
}


