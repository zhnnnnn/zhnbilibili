//
//  ZHNplayerRelatesTitleTableViewCell.swift
//  zhnbilibili
//
//  Created by 张辉男 on 16/12/31.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

fileprivate let kreuseKey = "ZHNplayerRelatesTitleTableViewCell"

class ZHNplayerRelatesTitleTableViewCell: UITableViewCell {

    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "视频相关"
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.sizeToFit()
        return titleLabel
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(titleLabel)
        self.backgroundColor = kHomeBackColor
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(10)
        }
    }
    
    class func instanceCell(tableView: UITableView) -> ZHNplayerRelatesTitleTableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: kreuseKey)
        if cell == nil {
            cell = ZHNplayerRelatesTitleTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: kreuseKey)
        }
        return cell as! ZHNplayerRelatesTitleTableViewCell
    }
}
