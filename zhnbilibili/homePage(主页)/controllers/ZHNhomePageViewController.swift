//
//  ZHNhomePageViewController.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/11.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit

/// 点击了普通视跳转
let khomePageNormalPLayerSelectedNotification = NSNotification.Name(rawValue: "khomePageNormalPLayerSelectedNotification")
let khomePageSelectedAidKey = "khomePageSelectedAidKey"

class ZHNhomePageViewController: ZHNBaseViewController {

    let kbackImageHeight: CGFloat = 150
    // MARK - 属性
    // vm
    var homePageVM = ZHNhomePageViewModel()
    // 用户的id
    var mid: Int = 0
    
    // MARK - 懒加载控件
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
    lazy var backImageView: UIImageView = {
        let backImageView = UIImageView()
        backImageView.contentMode = .scaleAspectFill
        backImageView.clipsToBounds = true
        backImageView.image = UIImage(named: "space_head")
        return backImageView
    }()
    
    lazy var backButton: UIButton = {
        let backButton = UIButton()
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        let image = UIImage(named: "videoinfo_back")
        backButton.setImage(image, for: .normal)
        return backButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1. 加载ui
        setupUI()
        // 2. 初始化kvo
        addSelectedKVO()
        // 3. 加载数据
        homePageVM.requestData(mid: mid) { [weak self] in
            self?.tableView.reloadData()
            guard let title = self?.homePageVM.homePageModel?.card?.name else {return}
            self?.naviBar.titleLabel.text = title
            if let backImageUrl = self?.homePageVM.homePageModel?.images?.imgUrl {
                if backImageUrl.characters.count > 5 {
                    let url = URL(string: backImageUrl)
                    self?.backImageView.sd_setImage(with: url)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//======================================================================
// MARK:- tableview 代理方法 数据源方法
//======================================================================
extension ZHNhomePageViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homePageVM.caluateRowCount()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return homePageVM.dealCell(tableView: tableView, indexPath: indexPath)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return homePageVM.caluateRowHeight(row: indexPath.row)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y + self.kbackImageHeight
        let max = kbackImageHeight - knavibarHeight
        let delta = offsetY/max
        if delta >= 0 && delta <= 1 {
            naviBar.alpha = delta
        }else if delta > 1{
            naviBar.alpha = 1
        }else if delta < 0 {
            naviBar.alpha = 0
        }
        backImageView.snp.updateConstraints { (make) in
            make.height.equalTo(kbackImageHeight - offsetY)
        }
    }
}

//======================================================================
// MARK:- 私有方法
//======================================================================
extension ZHNhomePageViewController {
    fileprivate func setupUI() {
        view.backgroundColor = kHomeBackColor
        naviBar.isHidden = false
        naviBar.alpha = 0
        naviBar.backgroundColor = UIColor.white
        naviBar.layer.shadowColor = UIColor.lightGray.cgColor
        naviBar.layer.shadowOpacity = 0.5
        naviBar.layer.shadowOffset = CGSize(width: 3, height: 3)
        naviBar.titleLabel.textColor = UIColor.black
        let backImage = UIImage(named: "common_back_v2")?.withTintColor(UIColor.black)
        naviBar.backArrowButton.setImage(backImage, for: .normal)
        naviBar.backArrowButton.setImage(backImage, for: .highlighted)
        
        view.insertSubview(backImageView, belowSubview: naviBar)
        backImageView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.height.equalTo(kbackImageHeight)
        }
        
        view.insertSubview(tableView, belowSubview: naviBar)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalTo(view)
            make.top.equalTo(view).offset(-20)
        }
        
        view.insertSubview(backButton, belowSubview: naviBar)
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(15)
            make.top.equalTo(view).offset(25)
            make.size.equalTo(CGSize(width: 25, height: 25))
        }
        
        tableView.contentInset = UIEdgeInsetsMake((self.kbackImageHeight), 0, 0, 0)
        tableView.contentOffset = CGPoint(x: 0, y: -self.kbackImageHeight)
    }
    
    fileprivate func addSelectedKVO() {
        NotificationCenter.default.addObserver(self, selector: #selector(choseToPlay(notifocation:)), name: khomePageNormalPLayerSelectedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(selectedBangumi(notification:)), name: kbangumiSelectedNotification, object: nil)
    }
}

//======================================================================
// MARK:- target action
//======================================================================
extension ZHNhomePageViewController {
    @objc func backAction() {
       _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func choseToPlay(notifocation: Notification) {
        let item = notifocation.userInfo?[khomePageSelectedAidKey]
        let playerVC = ZHNnormalPlayerViewController()
        playerVC.itemModel = item as? itemDetailModel
        self.navigationController?.pushViewController(playerVC, animated: true)
    }
    
    @objc func selectedBangumi(notification: Notification) {
        /// 数据有问题不知为何
        let itemModel = notification.userInfo?[kbangumiModelKey] as! HomeBangumiDetailModel
        let bangumiVC = ZHNbangumiDetailViewController()
        bangumiVC.bangumiDetailModel = itemModel
        _ = navigationController?.pushViewController(bangumiVC, animated: true)
    }
}


