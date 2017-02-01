//
//  ZHNhomePageBaseTableViewCell.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/13.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit

class ZHNhomePageBaseTableViewCell: UITableViewCell {

    // MARK - 属性
    var count: Int = 0 {
        didSet {
            headNoticeView.coutLabel.text = "\(count)"
        }
    }
    var name: String = "" {
        didSet {
            headNoticeView.nameLabel.text = name
        }
    }
    
    // MARK - 懒加载控件
    lazy var headNoticeView: ZHNhomePageRowHeadView = {
        let headNoticeView = ZHNhomePageRowHeadView()
        return headNoticeView
    }()
    
    lazy var lineView: UIImageView = {
        let lineView = UIImageView()
        lineView.backgroundColor = ktableCellLineColor
        return lineView
    }()
    
    // MARK - life cycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(headNoticeView)
        self.addSubview(lineView)
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headNoticeView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(self)
            make.height.equalTo(30)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
}
