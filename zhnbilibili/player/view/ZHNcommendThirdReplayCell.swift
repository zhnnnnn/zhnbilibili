//
//  ZHNcommendThirdReplayCell.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/4.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit

class ZHNcommendThirdReplayCell: ZHNcommendTwoReplayCell {

    lazy var thirdSeclineView: UIView = {
        let thirdSeclineView = UIView()
        thirdSeclineView.backgroundColor = ktableCellLineColor
        return thirdSeclineView
    }()
    lazy var thirdSecNameLabel: UILabel = {
        let thirdSecNameLabel = UILabel()
        return thirdSecNameLabel
    }()
    lazy var thirdSecTimeLabel: UILabel = {
        let thirdSecTimeLabel = UILabel()
        return thirdSecTimeLabel
    }()
    lazy var thirdSecContentLabel: WTKAutoHighLightLabel = {
        let thirdSecContentLabel = WTKAutoHighLightLabel()
        thirdSecContentLabel.w_highColor = knavibarcolor
        thirdSecContentLabel.numberOfLines = 0
        return thirdSecContentLabel
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(thirdSeclineView)
        self.addSubview(thirdSecNameLabel)
        self.addSubview(thirdSecTimeLabel)
        self.addSubview(thirdSecContentLabel)
        thirdSecNameLabel.font = nameFont
        thirdSecNameLabel.textColor = nameColr
        thirdSecTimeLabel.font = timeFont
        thirdSecTimeLabel.textColor = timeColor
        thirdSecContentLabel.font = contentFont
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        twoSecContentLabel.snp.remakeConstraints { (make) in
            make.left.right.equalTo(contentLabel)
            make.top.equalTo(twoSecNameLabel.snp.bottom).offset(10)
        }
        thirdSeclineView.snp.makeConstraints { (make) in
            make.left.equalTo(twoSecContentLabel)
            make.right.equalTo(twoSecContentLabel)
            make.top.equalTo(twoSecContentLabel.snp.bottom).offset(20)
            make.height.equalTo(0.5)
        }
        thirdSecNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(twoSecContentLabel)
            make.top.equalTo(thirdSeclineView.snp.bottom).offset(10)
        }
        thirdSecTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(thirdSecNameLabel.snp.right).offset(10)
            make.centerY.equalTo(thirdSecNameLabel)
        }
        thirdSecContentLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(twoSecContentLabel)
            make.top.equalTo(thirdSecNameLabel.snp.bottom).offset(10)
            make.bottom.equalTo(self).offset(-20)
        }
    }
    
    override func initStatus() {
        super.initStatus()
        guard let commend = commendModel?.replies?[1] else {return}
        // 名字
        if let name = commend.member?.uname {
            thirdSecNameLabel.text = name
        }
        // 时间
        thirdSecTimeLabel.text = commend.ctime.commendTime()
        // 内容
        if let content = commend.content?.message {
//            thirdSecContentLabel.text = content
            thirdSecContentLabel.wtk_setText(content)
        }
    }
    
    
    //初始化方法
    class func thirdSecCommendCell(tableView: UITableView) -> ZHNcommendThirdReplayCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ZHNcommendThirdReplayCell")
        if cell == nil {
            cell = ZHNcommendThirdReplayCell(style: .default, reuseIdentifier: "ZHNcommendThirdReplayCell")
        }
        return cell as! ZHNcommendThirdReplayCell
    }

}
