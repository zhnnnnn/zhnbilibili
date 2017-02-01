//
//  ZHNnormalPlayerDetailTableViewController.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/12.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

@objc protocol ZHNnormalPlayerDetailTableViewControllerDelegate {
    @objc func ZHNnormalPlayerDetailTableViewControllerSelectedNewPlay(aid: Int)
    @objc func ZHNnormalPlayerDetailTableViewControllerSelectedPage(cid: Int,index: Int)
}

class ZHNnormalPlayerDetailTableViewController: UITableViewController {

    /// 点击了播放之后再切换会对一条输入条，导致计算的数据也不太相同需要特殊处理
    var watched = false
    /// 数据model
    var detailModel: playDetailModel? {
        didSet{
            statusVM.detailModel = detailModel
            tableView.reloadData()
            let max = (knormalPlayerHeight - knavibarheight) * 2
            let current = tableView.contentSize.height - tableView.zhnheight
            if max > current {
                tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: (max - current)/3, right: 0)
            }else {
                tableView.contentInset = UIEdgeInsets.zero
            }
        }
    }
    /// 代理
    weak var delegate: ZHNnormalPlayerDetailTableViewControllerDelegate?
    
    // MARK - 懒加载
    lazy var statusVM = ZHNplayerDetailViewModel()
    
    // MARK - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = kHomeBackColor
        tableView.separatorStyle = .none
        statusVM.delegate = self
    }
    
    deinit {
        println("detailTableViewController ---------- 被销毁了")
    }
}

// MARK - datasource delegate
extension ZHNnormalPlayerDetailTableViewController {
    /// 数据源
    override func numberOfSections(in tableView: UITableView) -> Int {
        return statusVM.creatSectionCount()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusVM.createRowCount(section: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return statusVM.createCell(indexPath: indexPath, tableView: tableView)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return statusVM.createHeight(section: indexPath.section)
    }
}

// MARK - 各点击事件的响应
extension ZHNnormalPlayerDetailTableViewController: ZHNplayerDetailViewModelDelegate {
    func ZHNplayerDetailViewModelSelectedRelates(aid: Int) {
        delegate?.ZHNnormalPlayerDetailTableViewControllerSelectedNewPlay(aid: aid)
    }
    func ZHNplayerDetailViewModelReloadDetailCell(isfull: Bool) {
        statusVM.isfullDes = !isfull
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
    }
    func ZHNplayerDetailViewModelSelectedPage(cid: Int,index: Int) {
        delegate?.ZHNnormalPlayerDetailTableViewControllerSelectedPage(cid: cid,index: index)
    }
    func ZHNplayerDetailViewModelPushToHomePage(mid: Int) {
        let homePageVC = ZHNhomePageViewController()
        homePageVC.mid = mid
        navigationController?.pushViewController(homePageVC, animated: true)
    }
}


