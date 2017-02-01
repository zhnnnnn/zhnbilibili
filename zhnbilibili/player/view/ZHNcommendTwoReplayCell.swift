//
//  ZHNcommendTwoReplayCell.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/4.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit

class ZHNcommendTwoReplayCell: ZHNcommendTableViewCell {
    
    lazy var twoSeclineView: UIView = {
        let towSeclineView = UIView()
        towSeclineView.backgroundColor = ktableCellLineColor
        return towSeclineView
    }()
    lazy var twoSecNameLabel: UILabel = {
        let twoSecNameLabel = UILabel()
        return twoSecNameLabel
    }()
    lazy var twoSecTimeLabel: UILabel = {
        let twoSecTimeLabel = UILabel()
        return twoSecTimeLabel
    }()
    lazy var twoSecContentLabel: WTKAutoHighLightLabel = {
        let twoSecContentLabel = WTKAutoHighLightLabel()
        twoSecContentLabel.w_highColor = knavibarcolor  
        twoSecContentLabel.numberOfLines = 0
        return twoSecContentLabel
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(twoSecNameLabel)
        self.addSubview(twoSeclineView)
        self.addSubview(twoSecTimeLabel)
        self.addSubview(twoSecContentLabel)
        twoSecNameLabel.font = nameFont
        twoSecNameLabel.textColor = nameColr
        twoSecTimeLabel.font = timeFont
        twoSecTimeLabel.textColor = timeColor
        twoSecContentLabel.font = contentFont
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(floorLabel.snp.left)
            make.right.equalTo(reportButton.snp.right)
            make.top.equalTo(floorLabel.snp.bottom).offset(10)
    
        }
        twoSeclineView.snp.makeConstraints { (make) in
            make.left.equalTo(contentLabel)
            make.right.equalTo(contentLabel)
            make.top.equalTo(contentLabel.snp.bottom).offset(20)
            make.height.equalTo(0.5)
        }
        twoSecNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentLabel)
            make.top.equalTo(twoSeclineView.snp.bottom).offset(10)
        }
        twoSecTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(twoSecNameLabel.snp.right).offset(10)
            make.centerY.equalTo(twoSecNameLabel)
        }
        twoSecContentLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentLabel)
            make.top.equalTo(twoSecNameLabel.snp.bottom).offset(10)
            make.bottom.equalTo(self).offset(-20)
        }
    }
    
    override func initStatus() {
        super.initStatus()
        guard let commend = commendModel?.replies?.first else {return}
        // 名字
        if let name = commend.member?.uname {
            twoSecNameLabel.text = name
        }
        // 时间
        twoSecTimeLabel.text = commend.ctime.commendTime()
        // 内容
        if let content = commend.content?.message {
//            twoSecContentLabel.text = content 
            twoSecContentLabel.wtk_setText(content)
        }
    }
    
    
    //初始化方法
    class func towSecCommendCell(tableView: UITableView) -> ZHNcommendTwoReplayCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ZHNcommendTwoReplayCell")
        if cell == nil {
            cell = ZHNcommendTwoReplayCell(style: .default, reuseIdentifier: "ZHNcommendTwoReplayCell")
        }
        return cell as! ZHNcommendTwoReplayCell
    }
}
