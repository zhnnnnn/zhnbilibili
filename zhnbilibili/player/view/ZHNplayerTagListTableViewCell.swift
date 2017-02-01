//
//  ZHNplayerTagListTableViewCell.swift
//  zhnbilibili
//
//  Created by 张辉男 on 16/12/30.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class ZHNplayerTagListTableViewCell: ZHNcustomLineTableViewCell {

    
    // tag的数组
    var tagValueList: [String]? {
        didSet{
            guard let tagValueList = tagValueList else {return}
            tagList.tags.removeAllObjects()
            tagList.tags.addObjects(from: tagValueList)
        }
    }

    // MARK - 懒加载控件
    lazy var noticeLabel: UILabel = {
        let noticeLabel = UILabel()
        noticeLabel.text = "标签相关"
        noticeLabel.font = UIFont.systemFont(ofSize: 15)
        return noticeLabel
    }()
    lazy var editLabel: UILabel = {
        let editLabel = UILabel()
        editLabel.text = "编辑"
        editLabel.font = UIFont.systemFont(ofSize: 13)
        editLabel.textColor = UIColor.lightGray
        editLabel.sizeToFit()
        return editLabel
    }()
    lazy var tagList: JCTagListView = {
        let tagList = JCTagListView()
        tagList.tagTextFont = UIFont.systemFont(ofSize: 13)
        tagList.tagBackgroundColor = UIColor.white
        tagList.tagStrokeColor = UIColor.ZHNcolor(red: 255, green: 255, blue: 255, alpha: 0.5)
        tagList.tagCornerRadius = 14
        return tagList
    }()
 
    // MARK - life cycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(noticeLabel)
        self.addSubview(editLabel)
        self.addSubview(tagList)
        self.selectionStyle = .none
        self.backgroundColor = kHomeBackColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        noticeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.top.equalTo(self).offset(5)
            make.height.equalTo(30)
        }
        editLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(noticeLabel.snp.centerY)
            make.right.equalTo(self).offset(-10)
        }
        tagList.snp.makeConstraints { (make) in
            make.top.equalTo(noticeLabel.snp.bottom)
            make.left.right.bottom.equalTo(self)
        }
    }
    
    class func instanceCell(tableView: UITableView) -> ZHNplayerTagListTableViewCell {
        return ZHNplayerTagListTableViewCell(style: .default, reuseIdentifier: "ZHNplayerTagListTableViewCell")
    }
}

