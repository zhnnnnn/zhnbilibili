//
//  ZHNcommendFourReplayCell.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/4.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit

class ZHNcommendFourReplayCell: ZHNcommendThirdReplayCell {

    lazy var fourSeclineView: UIView = {
        let fourSeclineView = UIView()
        fourSeclineView.backgroundColor = ktableCellLineColor
        return fourSeclineView
    }()
    lazy var fourSecNameLabel: UILabel = {
        let fourSecNameLabel = UILabel()
        return fourSecNameLabel
    }()
    lazy var fourSecTimeLabel: UILabel = {
        let fourSecTimeLabel = UILabel()
        return fourSecTimeLabel
    }()
    lazy var fourSecContentLabel: WTKAutoHighLightLabel = {
        let fourSecContentLabel = WTKAutoHighLightLabel()
        fourSecContentLabel.w_highColor = knavibarcolor 
        fourSecContentLabel.numberOfLines = 0
        return fourSecContentLabel
    }()
    lazy var allStatusLabel: UILabel = {
        let allStatusLabel = UILabel()
        allStatusLabel.text = "全部"
        allStatusLabel.textColor = knavibarcolor
        allStatusLabel.font = UIFont.systemFont(ofSize: 15)
        return allStatusLabel
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(fourSeclineView)
        self.addSubview(fourSecNameLabel)
        self.addSubview(fourSecTimeLabel)
        self.addSubview(fourSecContentLabel)
        self.addSubview(allStatusLabel)
        fourSecNameLabel.font = nameFont
        fourSecNameLabel.textColor = nameColr
        fourSecTimeLabel.font = timeFont
        fourSecTimeLabel.textColor = timeColor
        fourSecContentLabel.font = contentFont
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        thirdSecContentLabel.snp.remakeConstraints { (make) in
            make.left.right.equalTo(contentLabel)
            make.top.equalTo(thirdSecNameLabel.snp.bottom).offset(10)
        }
        fourSeclineView.snp.makeConstraints { (make) in
            make.left.equalTo(thirdSecContentLabel)
            make.right.equalTo(thirdSecContentLabel)
            make.top.equalTo(thirdSecContentLabel.snp.bottom).offset(20)
            make.height.equalTo(0.5)
        }
        fourSecNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(thirdSecContentLabel)
            make.top.equalTo(fourSeclineView.snp.bottom).offset(10)
        }
        fourSecTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(fourSecNameLabel.snp.right).offset(10)
            make.centerY.equalTo(fourSecNameLabel)
        }
        fourSecContentLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(thirdSecContentLabel)
            make.top.equalTo(fourSecNameLabel.snp.bottom).offset(10)
        }
        allStatusLabel.snp.makeConstraints { (make) in
            make.right.equalTo(fourSecContentLabel)
            make.top.equalTo(fourSecContentLabel.snp.bottom).offset(25)
            make.bottom.equalTo(self).offset(-15)
        }
    }
    
    override func initStatus() {
        super.initStatus()
        guard let commend = commendModel?.replies?[2] else {return}
        // 名字
        if let name = commend.member?.uname {
            fourSecNameLabel.text = name
        }
        // 时间
        fourSecTimeLabel.text = commend.ctime.commendTime()
        // 内容
        if let content = commend.content?.message {
//            fourSecContentLabel.text = content
            fourSecContentLabel.wtk_setText(content)
        }
        // 加载更多
        let count = (commendModel?.count)! - 3
        if count == 0 {
            allStatusLabel.isHidden = true
        }else {
            allStatusLabel.isHidden = false
            allStatusLabel.text = "查看更多\(count)条回复 >"
        }
    }
    
    
    //初始化方法
    class func fourSecCommendCell(tableView: UITableView) -> ZHNcommendFourReplayCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ZHNcommendFourReplayCell")
        if cell == nil {
            cell = ZHNcommendFourReplayCell(style: .default, reuseIdentifier: "ZHNcommendFourReplayCell")
        }
        return cell as! ZHNcommendFourReplayCell
    }

}
