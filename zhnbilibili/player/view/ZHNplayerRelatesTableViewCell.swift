//
//  ZHNplayerRelatesTableViewCell.swift
//  zhnbilibili
//
//  Created by 张辉男 on 16/12/29.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class ZHNplayerRelatesTableViewCell: ZHNcustomLineTableViewCell {
    
    // 点击的响应
    var tapAction: ((_ model: relatesModel)->Void)?
    
    // 数据
    var detailModel: relatesModel? {
        didSet{
            if let pic = detailModel?.pic {
                let url = URL(string: pic)
                showImageView.sd_setImage(with: url)
            }
            if let title = detailModel?.title {
                titleLabel.text = title
            }
            if let name = detailModel?.owner?.name {
                upNameLabel.text = name
            }
            if let danmu = detailModel?.stat?.danmaku {
                danmuNumberLabel.text = "\(danmu.returnShowString())"
            }
            if let playNumber = detailModel?.stat?.view {
                playNumberLabel.text = "\(playNumber.returnShowString())"
            }
        }
    }
    
    var playItemModel: itemDetailModel? {
        didSet{
            if let pic = playItemModel?.cover {
                let url = URL(string: pic)
                showImageView.sd_setImage(with: url)
            }
            if let title = playItemModel?.title {
                titleLabel.text = title
            }
            if let name = playItemModel?.name {
                upNameLabel.text = name
            }
            if let danmu = playItemModel?.danmaku {
                danmuNumberLabel.text = "\(danmu.returnShowString())"
            }
            if let playNumber = playItemModel?.play {
                playNumberLabel.text = "\(playNumber.returnShowString())"
            }
        }
    }
    
    
    // MARK - 控件
    @IBOutlet weak var showImageView: UIImageView!
    @IBOutlet weak var danmuNumberLabel: UILabel!
    @IBOutlet weak var playNumberLabel: UILabel!
    @IBOutlet weak var upNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if detailModel != nil {
            let tapGes = UITapGestureRecognizer {[weak self] in
                self?.tapAction!((self?.detailModel)!)
            }
            self.addGestureRecognizer(tapGes)
        }
    }
    
    class func relatesCellWithTableView(tableView: UITableView) -> ZHNplayerRelatesTableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "ZHNplayerRelatesTableViewCell")
        if cell == nil {
            cell = Bundle.main.loadNibNamed("ZHNplayerRelatesTableViewCell", owner: nil, options: nil)?.last as! ZHNplayerRelatesTableViewCell
        }
        cell?.backgroundColor = kHomeBackColor
        return cell as! ZHNplayerRelatesTableViewCell
    }
}
