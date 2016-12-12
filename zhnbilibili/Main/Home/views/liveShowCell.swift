//
//  liveShowCell.swift
//  zhnbilibili
//
//  Created by zhn on 16/11/28.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class liveShowCell: normalBaseCell {

    // 是否显示分类
    var isNeedShowArea = true
    
    var sonStatusModel: itemDetailModel? {
        
        didSet{
            playLabel.text = sonStatusModel?.online.returnShowString()
            nameLabel.text = sonStatusModel?.name
            if isNeedShowArea {
                liveAreaButton.isHidden = false
                liveAreaButton.setTitle(areabuttonString(), for: .normal)
                liveAreaButton.setTitle(areabuttonString(), for: .highlighted)
                titleLabel.text = liveTitleLabelString()
            }else{
                liveAreaButton.isHidden = true
            }
            
            // 角标
            if let cornerUrl = sonStatusModel?.corner {
                let imgURL = URL(string: cornerUrl)
                cornerImageView.isHidden = false
                cornerImageView.kf.setImage(with: imgURL)
            }else{
                cornerImageView.isHidden = true
            }
        }
    }
    
    
    // MARK: - 懒加载控件
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = celldetailLabelsFont
        nameLabel.textColor = UIColor.white
        return nameLabel
    }()
    
    lazy var playLabel: UILabel = {
        let playLabel = UILabel()
        playLabel.textColor = UIColor.white
        playLabel.font = celldetailLabelsFont
        return playLabel
    }()
    
    lazy var playIocnImageView: UIImageView = {
        let playIconImageView = UIImageView()
        playIconImageView.image = UIImage(named: "live_looking")
        playIconImageView.contentMode = .center
        return playIconImageView
    }()
    
    lazy var liveAreaButton: UIButton = {
        let liveAreaButton = UIButton()
        liveAreaButton.titleLabel?.font = knormalItemCellTitleFont
        liveAreaButton.setTitleColor(knavibarcolor, for: .normal)
        liveAreaButton.setTitleColor(knavibarcolor, for: .highlighted)
        return liveAreaButton
    }()
    
    lazy var cornerImageView: UIImageView = {
        let conerImageView = UIImageView()
        conerImageView.contentMode = .scaleAspectFill
        return conerImageView
    }()
    
    // 添加控件
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(nameLabel)
        self.addSubview(playLabel)
        self.addSubview(playIocnImageView)
        self.addSubview(liveAreaButton)
        self.addSubview(cornerImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 初始化位置
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playLabel.snp.makeConstraints { (make) in
            make.right.equalTo(maskImageView.snp.right).offset(-5)
            make.bottom.equalTo(maskImageView.snp.bottom).offset(-5)
        }
        
        playIocnImageView.snp.makeConstraints { (make) in
            make.right.equalTo(playLabel.snp.left).offset(-4)
            make.centerY.equalTo(playLabel)
            make.size.equalTo(CGSize(width: cellIconWidth, height: cellIconHeight))
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(maskImageView).offset(5)
            make.centerY.equalTo(playLabel)
        }
        
        liveAreaButton.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.left)
            make.top.equalTo(titleLabel.snp.top).offset(-1)
        }
        
        cornerImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentImageView.snp.top)
            make.right.equalTo(self.snp.right).offset(-10)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
    }
}

// MARK: - 私有方法
extension liveShowCell {
    
    fileprivate func areabuttonString() -> String {
        if let area = sonStatusModel?.area{
            return "#\(area)#"
        }else {
            return"##"
        }
    }
    
    fileprivate func liveTitleLabelString() -> String {
        
        var str = areabuttonString()
        if let titleStr = sonStatusModel?.title{
            var newTitleStr = titleStr
            for _ in str.characters {
                newTitleStr = "   \(newTitleStr)"
            }
            newTitleStr = "  \(newTitleStr)\n\n\n"
            return newTitleStr
        }else {
            return ""
        }
    }
}

