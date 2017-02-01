//
//  ZHNhomePageSubscibeLiveCell.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/13.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit

class ZHNhomePageSubscibeLiveCell: UITableViewCell {

    class func sunscribeCell(tableView: UITableView) -> ZHNhomePageSubscibeLiveCell {
        let cell = ZHNhomePageSubscibeLiveCell.storyBoardInstanceCell(tableView: tableView) as! ZHNhomePageSubscibeLiveCell
        cell.backgroundColor = kHomeBackColor
        cell.selectionStyle = .none
        return cell
    }
}
