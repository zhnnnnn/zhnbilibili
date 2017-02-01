//
//  ZHNnormalPlayerCommondTableViewController.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/12.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

/// 点击头像的通知
let krecommendControllerSelectedHomePageNotification = NSNotification.Name(rawValue: "krecommendControllerSelectedHomePageNotification")
let krecommendNotificationKey = "krecommendNotificationKey"

class ZHNnormalPlayerCommondTableViewController: UITableViewController {

    lazy var tempFooter: UIView = {
        let tempFooter = UIView()
        tempFooter.frame = CGRect(x: 0, y: 0, width: kscreenWidth, height: 1)
        tempFooter.backgroundColor = UIColor.clear
        return tempFooter
    }()
    // MARK - 属性
    var commendVM: ZHNplayerCommendViewModel = ZHNplayerCommendViewModel()
    var aid: Int = 0 {
        didSet{
            currentIndex = 1
            commendVM.reRequestData(aid: aid, page: currentIndex) {[weak self] in
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
    // 加载更多时候需要的index
    var currentIndex: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = kHomeBackColor
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = tempFooter
        tableView.separatorStyle = .none
        NotificationCenter.default.addObserver(self, selector: #selector(selectedHomePage(notification:)), name: krecommendControllerSelectedHomePageNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//======================================================================
// MARK:- collectionview delegate datasource
//======================================================================
extension ZHNnormalPlayerCommondTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return commendVM.dealSectionCount()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commendVM.dealRowCount(section: section)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return commendVM.cell(tableView: tableView, indexPath: indexPath)
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return commendVM.hotFooter(section: section)
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return commendVM.footerHeight(section: section)
    }
    // 加载更多
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.frame.height == scrollView.contentSize.height{
            self.commendVM.requestData(aid: (self.aid), page: (self.currentIndex)+1) {
                self.currentIndex += 1
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

//======================================================================
// MARK:- target action
//======================================================================
extension ZHNnormalPlayerCommondTableViewController {
    @objc func selectedHomePage(notification: Notification) {
        let mid = notification.userInfo?[krecommendNotificationKey] as! Int
        let homePageVC = ZHNhomePageViewController()
        homePageVC.mid = mid
        _ = self.navigationController?.pushViewController(homePageVC, animated: true)
    }
}

