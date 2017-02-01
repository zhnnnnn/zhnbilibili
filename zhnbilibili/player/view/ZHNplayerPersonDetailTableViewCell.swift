//
//  ZHNplayerPersonDetailTableViewCell.swift
//  zhnbilibili
//
//  Created by 张辉男 on 16/12/30.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class ZHNplayerPersonDetailTableViewCell: ZHNcustomLineTableViewCell {

    // 头像的点击
    var headTapAction: (()->Void)?
    
    var detailModel: playDetailModel? {
        didSet{
            // 1. 涉及重用清空状态
            firstElecImageView.image = nil
            secondElecImageView.image = nil
            thirdElecImageView.image = nil
            fourElecImageView.image = nil
            bilibiliImageView.isHidden = false
            
            // 2. 赋值数据
            if let imageUrl = detailModel?.owner?.face {
                if let url = URL(string: imageUrl) {
                    headImageView.sd_setImage(with: url)
                    fixBugImageView.sd_setImage(with: url)
                }
            }
            if let name = detailModel?.owner?.name {
                nameLabel.text = name
            }
            if let ctime = detailModel?.ctime {
                ctimeLabel.text = ctime.showTime()
            }
            if let allelec = detailModel?.elec?.total {
                allElecCountLabel.text = "已有\(allelec)人为我充电"
            }
            if let mothelec = detailModel?.elec?.count {
                mothElecCountLabel.text = "\(mothelec)"
            }
            if let headArray = detailModel?.elec?.list {
                for e in headArray.enumerated() {
                    if e.offset < 4 {
                        let headImageView = headIconArray[e.offset]
                        let url = URL(string: e.element.avatar)
                        headImageView.sd_setImage(with: url)
                    }
                }
            }
        }
    }
    
    // 存放headicon数组
    var headIconArray = [UIImageView]()
    
    // MARK - 控件
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ctimeLabel: UILabel!
    @IBOutlet weak var allElecCountLabel: UILabel!
    @IBOutlet weak var mothElecCountLabel: UILabel!
    @IBOutlet weak var bilibiliImageView: UIImageView!
    
    @IBOutlet weak var firstElecImageView: UIImageView!
    @IBOutlet weak var secondElecImageView: UIImageView!
    @IBOutlet weak var thirdElecImageView: UIImageView!
    @IBOutlet weak var fourElecImageView: UIImageView!
    
    // 约束
    @IBOutlet weak var headImageViewContraint: NSLayoutConstraint!
    
    lazy var fixBugImageView: UIImageView = {
        let fixBugImageView = UIImageView()
        fixBugImageView.layer.cornerRadius = 20
        fixBugImageView.clipsToBounds = true
        fixBugImageView.contentMode = .scaleAspectFill
        fixBugImageView.isUserInteractionEnabled = true 
        let tapGes = UITapGestureRecognizer {[weak self] in
            if self?.headTapAction != nil {
                self?.headTapAction!()
            }
        }
        fixBugImageView.addGestureRecognizer(tapGes)
        return fixBugImageView
    }()
    
    // MARK - life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backgroundColor = kHomeBackColor
        self.addSubview(fixBugImageView)
        //
        headIconArray.append(firstElecImageView)
        headIconArray.append(secondElecImageView)
        headIconArray.append(thirdElecImageView)
        headIconArray.append(fourElecImageView)
        // 
        let tapGes = UITapGestureRecognizer {[weak self] in
            if self?.headTapAction != nil {
                self?.headTapAction!()
            }
        }
        headImageView.addGestureRecognizer(tapGes)
    }
    
    class func instanceCell(tableView: UITableView) -> ZHNplayerPersonDetailTableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ZHNplayerPersonDetailTableViewCell")
        if cell ==  nil {
            cell = Bundle.main.loadNibNamed("ZHNplayerPersonDetailTableViewCell", owner: nil, options: nil)!.last as! UITableViewCell?
        }
        return cell as! ZHNplayerPersonDetailTableViewCell
    }
    
    func noElecCell() {
        bilibiliImageView.isHidden = true
        headImageView.isHidden = true
        fixBugImageView.snp.makeConstraints { (make) in
            make.left.top.equalTo(self).offset(15)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
    }
}
