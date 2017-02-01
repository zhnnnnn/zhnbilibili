//
//  ZHNbangumiHeadTagView.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/22.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit

class ZHNbangumiHeadTagView: UIView {
    
    
    var detailModel: ZHNbangumiDetailModel? {
        didSet {
            
            var tagNameArray = [String]()
            if let tags = detailModel?.tags {
                for tag in tags {
                    tagNameArray.append(tag.tag_name)
                }
            }
            
            if let brief = detailModel?.brief {
                contentLabel.text = brief
                labelHeight = brief.heightWithConstrainedWidth(width: kscreenWidth - 20, font: UIFont.systemFont(ofSize: 14))
                tagViewHeight = tagListHeightHelper.calculateContentHeight(tagNameArray)
            }
            
            tagListView.tags.addObjects(from: tagNameArray)
        }
    }
    // 计算的高度
    var labelHeight: CGFloat = 0
    var tagViewHeight: CGFloat = 0
    // MARK - 懒加载控件
    lazy var titleLeftLabel: UILabel = {
        let titleLeftLabel = UILabel()
        titleLeftLabel.text = "详情"
        return titleLeftLabel
    }()
    
    lazy var titleRightArrowImageView: UIImageView = {
        let titleRightArrowImageView = UIImageView()
        titleRightArrowImageView.image = UIImage(named: "more_arrow")
        titleRightArrowImageView.contentMode = .center
        return titleRightArrowImageView
    }()
    
    lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.textColor = UIColor.lightGray
        contentLabel.numberOfLines = 0
        return contentLabel
    }()
    
    lazy var tagListView: JCTagListView = {
        let tagListView = JCTagListView(frame: CGRect.zero)
        tagListView.tagCornerRadius = 14
        tagListView.tagStrokeColor = UIColor.white
        tagListView.tagBackgroundColor = UIColor.white
        return tagListView
    }()
    
    lazy var tagListHeightHelper: JCCollectionViewTagFlowLayout = {
        let tagListHeightHelper = JCCollectionViewTagFlowLayout()
        return tagListHeightHelper
    }()
    
    lazy var lineView: UIImageView = {
        let lineView = UIImageView()
        lineView.backgroundColor = kcellLineColor
        return lineView
    }()

    // MARK - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(titleLeftLabel)
        self.addSubview(titleRightArrowImageView)
        self.addSubview(contentLabel)
        self.addSubview(tagListView)
        self.addSubview(lineView)
        self.backgroundColor = kHomeBackColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLeftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(15)
            make.top.equalTo(self).offset(15)
        }
        titleRightArrowImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLeftLabel)
            make.right.equalTo(self).offset(-10)
            make.size.equalTo(CGSize(width: 25, height: 25))
        }
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.top.equalTo(titleLeftLabel.snp.bottom).offset(15)
            make.height.equalTo(labelHeight)
        }
        tagListView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(contentLabel.snp.bottom).offset(5)
            make.height.equalTo(tagViewHeight)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
    
    
    /// 计算行高
    func caculateContentHeight() -> CGFloat {
        return labelHeight + tagViewHeight + 60
    }
}
