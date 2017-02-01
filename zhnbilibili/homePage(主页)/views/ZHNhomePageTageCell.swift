//
//  ZHNhomePageTageCell.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/14.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit

class ZHNhomePageTageCell: ZHNhomePageBaseTableViewCell {

    // MARK - 属性
    var taglist: [tagModel]? {
        didSet {
            var tagNameArray = [String]()
            guard let taglist = taglist else {return}
            for tag in taglist {
                tagNameArray.append(tag.tag_name)
            }
            tagListView.tags.addObjects(from: tagNameArray)
            name = "TA关注的标签"
            count = tagNameArray.count
        }
    }
    
    // MARK - 懒加载控件
    lazy var tagListView: JCTagListView = {
        let tagListView = JCTagListView()
        tagListView.tagBackgroundColor = UIColor.white
        tagListView.tagCornerRadius = 14
        tagListView.tagStrokeColor = UIColor.white
        tagListView.backgroundColor = kHomeBackColor
        return tagListView
    }()
    
    // MARK - life cycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(tagListView)
        self.selectionStyle = .none
        self.backgroundColor = kHomeBackColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tagListView.snp.makeConstraints { (make) in
            make.top.equalTo(headNoticeView.snp.bottom)
            make.left.right.equalTo(self)
            make.bottom.equalTo(lineView.snp.top)
        }
    }
}
