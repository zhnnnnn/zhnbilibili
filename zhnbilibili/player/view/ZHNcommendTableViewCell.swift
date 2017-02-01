//
//  ZHNcommendTableViewCell.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/2.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit

class ZHNcommendTableViewCell: UITableViewCell {
    
    
    var isHotSectionBottom = false {
        didSet {
            if isHotSectionBottom {
                cellLineView.isHidden = true
            }else {
                cellLineView.isHidden = false
            }
        }
    }
    
    // 为了方便子类赋值
    public let nameFont = UIFont.systemFont(ofSize: 15)
    public let timeFont = UIFont.systemFont(ofSize: 12)
    public let nameColr = UIColor.darkGray
    public let timeColor = UIColor.lightGray
    public let contentFont = UIFont.systemFont(ofSize: 15)
    
    var commendModel: playCommendModel? {
        didSet {
            //1. 加载数据
            initStatus()
        }
    }
    
    // MARK - 懒加载控件
    lazy var headImageView: UIImageView = {
        let headImageView = UIImageView()
        headImageView.contentMode = .scaleAspectFill
        headImageView.aliCornerRadius = 15
        headImageView.clipsToBounds = true
        return headImageView
    }()
    lazy var levelIconImageView: UIImageView = {
        let levelIconImageView = UIImageView()
        levelIconImageView.contentMode = .scaleAspectFill
        return levelIconImageView
    }()
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        nameLabel.textColor = UIColor.darkGray
        return nameLabel
    }()
    lazy var floorLabel: UILabel = {
        let floorLabel = UILabel()
        floorLabel.font = UIFont.systemFont(ofSize: 12)
        floorLabel.textColor = UIColor.lightGray
        return floorLabel
    }()
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.textColor = UIColor.lightGray
        return timeLabel
    }()
    lazy var replyCoutIcon: UIImageView = {
        let replyCoutIcon = UIImageView()
        replyCoutIcon.image = UIImage(named: "circle_reply_ic")?.withTintColor(knavibarcolor)
        replyCoutIcon.contentMode = .scaleAspectFill
        return replyCoutIcon
    }()
    lazy var likeIcon: UIImageView = {
        let likeIcon = UIImageView()
        likeIcon.contentMode = .scaleAspectFill
        likeIcon.image = UIImage(named: "like")
        return likeIcon
    }()
    lazy var replayLabel: UILabel = {
        let replayLabel = UILabel()
        replayLabel.font = UIFont.systemFont(ofSize: 12)
        replayLabel.textColor = UIColor.lightGray
        return replayLabel
    }()
    lazy var likeLabel: UILabel = {
        let likeLabel = UILabel()
        likeLabel.font = UIFont.systemFont(ofSize: 12)
        likeLabel.textColor = UIColor.lightGray
        return likeLabel
    }()
    lazy var reportButton: UIButton = {
        let reportButton = UIButton()
        reportButton.setBackgroundImage(UIImage(named: "common_more"), for: .normal)
        reportButton.sizeToFit()
        return reportButton
    }()
    lazy var contentLabel: WTKAutoHighLightLabel = {
        let contentLabel = WTKAutoHighLightLabel()
        contentLabel.w_highColor = knavibarcolor
        contentLabel.w_normalColor = UIColor.ZHNcolor(red: 25, green: 25, blue: 25, alpha: 1)
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont.systemFont(ofSize: 15)
        return contentLabel
    }()
    
    lazy var cellLineView: UIImageView = {
        let cellLineView = UIImageView()
        cellLineView.backgroundColor = kcellLineColor
        return cellLineView
    }()
    
    // MARK - life cycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .none
        self.selectionStyle = .none
        self.backgroundColor = kHomeBackColor
        addUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initFrames()
    }
    
    //初始化方法
    class func commendCell(tableView: UITableView) -> ZHNcommendTableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ZHNcommendTableViewCell")
        if cell == nil {
            cell = ZHNcommendTableViewCell(style: .default, reuseIdentifier: "ZHNcommendTableViewCell")
        }
        return cell as! ZHNcommendTableViewCell
    }
}

// MARK - 私有方法
extension ZHNcommendTableViewCell {
    func initStatus() {
        // 1.加载头像
        if let avatar = commendModel?.member?.avatar {
            headImageView.sd_setImage(with: URL(string: avatar))
        }
        // 2.加载名字
        if let name = commendModel?.member?.uname {
            nameLabel.text = name
        }
        // 3.加载楼层
        if let floor = commendModel?.floor {
            floorLabel.text = "# \(floor)"
        }
        // 4.加载时间
        if let ctime = commendModel?.ctime {
            timeLabel.text = ctime.commendTime()
        }
        // 5.加载评论数
        if let reply = commendModel?.count {
            if reply == 0{
                replayLabel.isHidden = true
                replyCoutIcon.isHidden = true
            }else {
                replayLabel.isHidden = false
                replyCoutIcon.isHidden = false
            }
            replayLabel.text = "\(reply)"
        }
        // 6.加载点赞数
        if let like = commendModel?.like {
            likeLabel.text = "\(like)"
        }
        // 7.加载内容
        if let content = commendModel?.content?.message {
//            contentLabel.text = content
            contentLabel.wtk_setText(content)
        }
        // 8.加载等级
        if let level = commendModel?.member?.level_info?.current_level {
            levelIconImageView.image = UIImage(named: "misc_level_whiteLv\(level)")
        }
    }
    
    fileprivate func addUI() {
        self.addSubview(headImageView)
        self.addSubview(levelIconImageView)
        self.addSubview(nameLabel)
        self.addSubview(floorLabel)
        self.addSubview(timeLabel)
        self.addSubview(replyCoutIcon)
        self.addSubview(replayLabel)
        self.addSubview(likeIcon)
        self.addSubview(likeLabel)
        self.addSubview(reportButton)
        self.addSubview(contentLabel)
        self.addSubview(cellLineView)
        // 手势添加
        headImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer { [weak self] in
            guard let mid = self?.commendModel?.member?.mid else {return}
            ZHNnotificationHelper.recommendSelectedHomePage(mid: mid)
        }
        headImageView.addGestureRecognizer(tap)
    }
    
    fileprivate func initFrames() {
        headImageView.snp.makeConstraints { (make) in
            make.top.left.equalTo(self).offset(15)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        levelIconImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(headImageView)
            make.top.equalTo(headImageView.snp.bottom).offset(5)
            make.size.equalTo(CGSize(width: 15, height: 10))
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headImageView.snp.top)
            make.left.equalTo(headImageView.snp.right).offset(10)
        }
        floorLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(floorLabel)
            make.left.equalTo(floorLabel.snp.right).offset(10)
        }
        reportButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(nameLabel)
            make.right.equalTo(self).offset(-10)
        }
        likeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(reportButton)
            make.right.equalTo(reportButton.snp.left).offset(-15)
        }
        likeIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(reportButton)
            make.right.equalTo(likeLabel.snp.left).offset(-5)
        }
        replayLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(reportButton)
            make.right.equalTo(likeIcon.snp.left).offset(-25)
        }
        replyCoutIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(reportButton)
            make.right.equalTo(replayLabel.snp.left).offset(-5)
        }
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(floorLabel.snp.left)
            make.right.equalTo(reportButton.snp.right)
            make.top.equalTo(floorLabel.snp.bottom).offset(10)
            make.bottom.equalTo(self).offset(-20)
        }
        cellLineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
}

