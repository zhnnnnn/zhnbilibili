//
//  ZHNplayerDetailStatusTableViewCell.swift
//  zhnbilibili
//
//  Created by 张辉男 on 16/12/29.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

let kcollectColor = knavibarcolor
let kshareColor = UIColor.ZHNcolor(red: 12, green: 194, blue: 100, alpha: 1)
let kcoinColor = UIColor.ZHNcolor(red: 245, green: 191, blue: 25, alpha: 1)
let kdownloadColor = UIColor.ZHNcolor(red: 127, green: 189, blue: 247, alpha: 1)

class ZHNplayerDetailStatusTableViewCell: ZHNcustomLineTableViewCell {

    // label的点击
    var labelTapAction: ((_ all: Bool)->Void)?
    // MARK - 属性赋值
    var detailModel: playDetailModel? {
        didSet{
            if let title = detailModel?.title {
                titleLabel.text = title
            }
            if let desc = detailModel?.desc {
                descLabel.text = desc
                let contraintHeight = desc.heightWithConstrainedWidth(width: kscreenWidth - 20, font: descLabel.font) + 10
                descFullLabnelContraint.constant = contraintHeight
            }
            if let stat = detailModel?.stat {
                playNumberLabel.text = stat.view.returnShowString()
                danmuCoutLabel.text = stat.danmaku.returnShowString()
                shareCountLabel.text = " \(stat.share.returnShowString()) "
                coinCountLabel.text = " \(stat.coin.returnShowString()) "
                collectCountLabel.text = " \(stat.favorite.returnShowString()) "
            }
        }
    }
    // 判断是否显示了全部的deslabel
    var isFullDes = false
    
    // MARK - 控件
    // 基础控件
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playNumberLabel: UILabel!
    @IBOutlet weak var danmuCoutLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    // 按钮组里面的label
    @IBOutlet weak var shareCountLabel: UILabel!
    @IBOutlet weak var coinCountLabel: UILabel!
    @IBOutlet weak var collectCountLabel: UILabel!
    // 按钮组里面的按钮
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var sendCoinButton: UIButton!
    @IBOutlet weak var collectButton: UIButton!
    @IBOutlet weak var downLoadButton: UIButton!
    // icon (为了图片换个颜色)
    @IBOutlet weak var playCountImageView: UIImageView!
    @IBOutlet weak var danmuImageView: UIImageView!
    // 为了收放descLabel效果
    @IBOutlet weak var desLabelContraint: NSLayoutConstraint!
    @IBOutlet weak var descFullLabnelContraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 1. 文字颜色初始化
        shareCountLabel.textColor = kshareColor
        coinCountLabel.textColor = kcoinColor
        collectCountLabel.textColor = kcollectColor
        // 2. 按钮图片的初始化
        shareButton.setBackgroundImage(UIImage(named: "iphonevideoinfo_share")?.withTintColor(kshareColor), for: .normal)
        shareButton.setBackgroundImage(UIImage(named: "iphonevideoinfo_share")?.withTintColor(kshareColor), for: .highlighted)
        sendCoinButton.setBackgroundImage(UIImage(named: "iphonevideoinfo_bp")?.withTintColor(kcoinColor), for: .normal)
        sendCoinButton.setBackgroundImage(UIImage(named: "iphonevideoinfo_bp")?.withTintColor(kcoinColor), for: .highlighted)
        collectButton.setBackgroundImage(UIImage(named: "iphonevideoinfo_fav")?.withTintColor(kcollectColor), for: .normal)
        collectButton.setBackgroundImage(UIImage(named: "iphonevideoinfo_fav")?.withTintColor(kcollectColor), for: .highlighted)
        downLoadButton.setBackgroundImage(UIImage(named: "iphonevideoinfo_dl")?.withTintColor(kdownloadColor), for: .normal)
        downLoadButton.setBackgroundImage(UIImage(named: "iphonevideoinfo_dl")?.withTintColor(kdownloadColor), for: .highlighted)
        // 3. icon图片的初始化
        playCountImageView.image = UIImage(named: "misc_playCount_new")?.withTintColor(UIColor.lightGray)
        danmuImageView.image = UIImage(named: "misc_danmakuCount_new")?.withTintColor(UIColor.lightGray)
        // 4. 自身属性的初始化
        self.backgroundColor = kHomeBackColor
        self.selectionStyle = .none
        // 5. 增加一个手势
        descLabel.isUserInteractionEnabled = true
        let tapGes = UITapGestureRecognizer {[weak self] in
            self?.labelTapAction!((self?.isFullDes)!)
        }
        descLabel.addGestureRecognizer(tapGes)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        println(descLabel.getLastLinePosition())
    }
    
    func isFull() {
        desLabelContraint.priority = 999
        descFullLabnelContraint.priority = 1000
    }
    
    func isNormal() {
        desLabelContraint.priority = 1000
        descFullLabnelContraint.priority = 999
    }
    
    class  func instanceCell(tableView: UITableView) -> ZHNplayerDetailStatusTableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ZHNplayerDetailStatusTableViewCell")
        if cell ==  nil {
            cell = Bundle.main.loadNibNamed("ZHNplayerDetailStatusTableViewCell", owner: nil, options: nil)!.last as! UITableViewCell?
        }
        return cell as! ZHNplayerDetailStatusTableViewCell
    }
}
