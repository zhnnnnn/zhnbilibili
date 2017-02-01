//
//  ZHNhomePageCardCell.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/12.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit

class ZHNhomePageCardCell: UITableViewCell {

    
    // MARK - 属性
    var cardModel: ZHNhomePageCardModel? {
        didSet {
            if let name = cardModel?.name {
                nameLabel.text = name
            }
            if let attention = cardModel?.attention {
                attentionLabel.text = "\(attention)"
            }
            if let fans = cardModel?.fans {
                fansLabel.text = "\(fans)"
            }
            if let content = cardModel?.sign {
                contentLabel.text = content
            }
            if let face = cardModel?.face {
                guard let url = URL(string: face) else {return}
                headImageView.sd_setImage(with: url)
            }
            if let level  = cardModel?.level_info?.current_level {
                levelImageView.image = UIImage(named: "misc_level_whiteLv\(level)")
                levelPercentView.backgroundColor = level.levelColor()
            }
            if let current = cardModel?.level_info?.current_exp  {
                guard let max = cardModel?.level_info?.next_exp else {return}
                if max == 0 {
                    levelPercentLabel.text = "\(current)/-"
                    levelPercentView.isHidden = true
                    levelPercentMaxView.backgroundColor = cardModel?.level_info?.current_level.levelColor()
                }else {
                    guard let min = cardModel?.level_info?.current_min else {return}
                    levelPercentLabel.text = "\(current)/\(max)"
                    let percent = CGFloat(current - min) / CGFloat(max - min)
                    levelPercentWIdthCons.constant = 30 + percent * (levelPercentWIdthCons.constant - 30)
                }
            }
            
            if let sex = cardModel?.sex {
                if sex == "男" {
                    sexImageView.image = UIImage(named: "misc_sex_male")
                }else if sex == "女" {
                    sexImageView.image = UIImage(named: "misc_sex_female")
                }else {
                    sexImageView.image = UIImage(named: "misc_sex_sox")
                }
            }
        }
    }
    
    
    // MARK - 控件
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var attentionLabel: UILabel!
    @IBOutlet weak var fansLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var sexImageView: UIImageView!
    @IBOutlet weak var levelImageView: UIImageView!
    @IBOutlet weak var levelPercentLabel: UILabel!
    @IBOutlet weak var levelPercentView: UIView!
    @IBOutlet weak var levelPercentMaxView: UIView!
    @IBOutlet weak var levelPercentWIdthCons: NSLayoutConstraint!
    
    class func cardCell(tableView: UITableView) -> ZHNhomePageCardCell {
        let cell = ZHNhomePageCardCell.storyBoardInstanceCell(tableView: tableView) as! ZHNhomePageCardCell
        cell.clipsToBounds = false
        cell.selectionStyle = .none
        return cell
    }
}
