//
//  ZHNnormalFullScreenBottom.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/16.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class ZHNnormalFullScreenBottom: UIView {

    // 返回的action
    var backAction: (()->Void)?
    // MARK - 懒加载控件
    lazy var fullTimeLabel: UILabel = {
        let fullTimeLabel = UILabel()
        fullTimeLabel.textColor = UIColor.white
        fullTimeLabel.font = UIFont.systemFont(ofSize: 12)
        fullTimeLabel.text = "00:00"
        return fullTimeLabel
    }()
    lazy var currentTimeLabel: UILabel = {
        let currentTimeLabel = UILabel()
        currentTimeLabel.text = "00:00"
        currentTimeLabel.textColor = UIColor.white
        currentTimeLabel.font = UIFont.systemFont(ofSize: 12)
        return currentTimeLabel
    }()
    lazy var seekTimeSlider: playCustomSlider = {
        let seekTimeSlider = playCustomSlider()
        seekTimeSlider.minimumTrackTintColor = knavibarcolor
        seekTimeSlider.maximumTrackTintColor = UIColor.clear
        seekTimeSlider.setThumbImage(UIImage(named: "icmpv_thumb_light"), for: .normal)
        return seekTimeSlider
    }()
    lazy var seekedTimeProgress: UIProgressView = {
        let seekedTimeProgress = UIProgressView()
        seekedTimeProgress.progressTintColor = UIColor.ZHNcolor(red: 188, green: 122, blue: 141, alpha: 1)
        seekedTimeProgress.backgroundColor = UIColor.lightGray
        return seekedTimeProgress
    }()
    
    @IBOutlet weak var gaoqinButton: UIButton!
    @IBOutlet weak var danmuButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(fullTimeLabel)
        self.addSubview(currentTimeLabel)
        self.addSubview(seekedTimeProgress)
        self.addSubview(seekTimeSlider)
        self.backgroundColor = UIColor.ZHNcolor(red: 0, green: 0, blue: 0, alpha: 0.7)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        currentTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(danmuButton.snp.right).offset(15)
            make.centerY.equalTo(danmuButton)
        }
        fullTimeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(gaoqinButton.snp.left).offset(-15)
            make.centerY.equalTo(gaoqinButton)
        }
        seekTimeSlider.snp.makeConstraints { (make) in
            make.left.equalTo(currentTimeLabel.snp.right).offset(15)
            make.right.equalTo(fullTimeLabel.snp.left).offset(-15)
            make.centerY.equalTo(gaoqinButton).offset(13)
            make.height.equalTo(50)
        }
        seekedTimeProgress.snp.makeConstraints { (make) in
            make.left.equalTo(currentTimeLabel.snp.right).offset(15)
            make.right.equalTo(fullTimeLabel.snp.left).offset(-15)
            make.centerY.equalTo(gaoqinButton)
        }
    }
    
    
    @IBAction func resignFullScreenAction(_ sender: AnyObject) {
        guard let action = backAction else {return}
        action()
    }
    
    @IBAction func danmuAction(_ sender: AnyObject) {
        
    }
    
    class func instanceView() -> ZHNnormalFullScreenBottom{
        return Bundle.main.loadNibNamed("ZHNnormalFullScreenBottom", owner: self, options: nil)?.last as! ZHNnormalFullScreenBottom
    }
}
