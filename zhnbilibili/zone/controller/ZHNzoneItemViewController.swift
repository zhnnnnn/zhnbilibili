//
//  ZHNzoneItemViewController.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/10.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit

class ZHNzoneItemViewController: UIViewController {

    var itemVM = ZHNzoneItemViewModel()
    var zoneItemModel: ZHNzoneModel?
    
    // MARK - 懒加载控件
    lazy var contentTableView: UITableView = {
        let contentTableView = UITableView(frame: CGRect.zero, style: .grouped)
        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.separatorStyle = .none
        contentTableView.backgroundColor = kHomeBackColor
        contentTableView.contentInset = UIEdgeInsetsMake(0, 0, 80, 0)
        return  contentTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentTableView)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        contentTableView.frame = view.bounds
        contentTableView.mj_header = ZHNDIYheader(refreshingBlock: {[weak self] in
            self?.requestData()
        })
        requestData()
    }
}

//======================================================================
// MARK:- 私有方法
//======================================================================
extension ZHNzoneItemViewController {
    fileprivate func requestData() {
        guard let tid = zoneItemModel?.tid else {return}
        itemVM.requestData(rid: tid) { [weak self] in
            self?.contentTableView.reloadData()
            self?.contentTableView.mj_header.endRefreshing()
        }
    }
}

//======================================================================
// MARK:- tableview delegate datasource
//======================================================================
extension ZHNzoneItemViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return itemVM.statusArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemVM.statusArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ZHNplayerRelatesTableViewCell.relatesCellWithTableView(tableView: tableView)
        let sectionArray = itemVM.statusArray[indexPath.section]
        let itemModel = sectionArray[indexPath.row]
        cell.playItemModel = itemModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ZHNzoneItemHeadr()
        if section == 0 {
            header.type = .recommend
        }else {
            header.type = .new
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionArray = itemVM.statusArray[indexPath.section]
        let itemModel = sectionArray[indexPath.row]
        let playerVC = ZHNnormalPlayerViewController()
        playerVC.itemModel = itemModel
        self.navigationController?.pushViewController(playerVC, animated: true)
    }
}
