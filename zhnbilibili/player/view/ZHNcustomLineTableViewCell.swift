//
//  ZHNcustomLineTableViewCell.swift
//  zhnbilibili
//
//  Created by 张辉男 on 16/12/31.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class ZHNcustomLineTableViewCell: UITableViewCell {

    lazy var lineView: UIImageView = {
        let lineView = UIImageView()
        lineView.backgroundColor = UIColor.ZHNcolor(red: 217, green: 217, blue: 217, alpha: 1)
        return lineView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubview(lineView)
        lineView.frame = CGRect(x: 10, y: frame.height-1, width: frame.width-20, height: 1/UIScreen.main.scale)
    }
}
