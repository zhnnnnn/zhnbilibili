//
//  UITableViewCell+instanceMethod.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/14.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    /// 纯代码加载cell
    class func normalInstanceCell(tableView: UITableView) -> UITableViewCell {
        let classStr = String(describing: self)
        var cell = tableView.dequeueReusableCell(withIdentifier: classStr)
        if cell == nil {
            cell = self.init(style: .default, reuseIdentifier: classStr)
        }
        return cell!
    }
    
    
    /// storyboard里加载cell
    class func storyBoardInstanceCell(tableView: UITableView) -> UITableViewCell {
        let classStr = String(describing: self)
        var cell = tableView.dequeueReusableCell(withIdentifier: classStr)
        if cell == nil {
            cell = Bundle.main.loadNibNamed(classStr, owner: self, options: nil)?.last as? UITableViewCell
        }
        return cell!
    }
}
