//
//  ZHNforwardBackforwardNoticeView.swift
//  zhnbilibili
//
//  Created by 张辉男 on 16/12/28.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class ZHNforwardBackforwardNoticeView: UIView {

    var translate: Float = 0 {
        didSet{
            deailImageView()
            dealPlayTimeLabel()
            dealForwardTimeLabel()
            dealProgressView()
        }
    }
    
    var needGoingPlayTime: TimeInterval = 0
    var currentPlayTime: TimeInterval = 0
    var maxPlayTime: TimeInterval = 0
    var oldTrans: Float = 0
    
    // MARK - 控件
    @IBOutlet weak var noticeImageView: UIImageView!
    @IBOutlet weak var playTimeLabel: UILabel!
    @IBOutlet weak var forwardTimeLabel: UILabel!
    @IBOutlet weak var forwardSpeedLabel: UILabel!
    @IBOutlet weak var playPercentProgress: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        playPercentProgress.backgroundColor = UIColor.darkGray
        playPercentProgress.progressTintColor = knavibarcolor
        noticeImageView.image = UIImage(named: "play_forward_icon")
    }
    
    class func instanceView() -> ZHNforwardBackforwardNoticeView {
        return Bundle.main.loadNibNamed("ZHNforwardBackforwardNoticeView", owner: self, options: nil)?.last as! ZHNforwardBackforwardNoticeView
    }
}

// MARK - 私有方法
extension ZHNforwardBackforwardNoticeView {
    fileprivate func deailImageView() {
        
        if translate > oldTrans{
            noticeImageView.image = UIImage(named: "play_forward_icon")
        }else {
            noticeImageView.image = UIImage(named: "play_retreat_icon")
        }
        oldTrans = translate
    }
    // 处理当前时间
    fileprivate func dealPlayTimeLabel() {
        println(currentPlayTime)
        // 1. 处理滑动值
        needGoingPlayTime = currentPlayTime + (TimeInterval(translate) * 0.5)
        println(currentPlayTime)
        if needGoingPlayTime < 0{
            needGoingPlayTime = 0
        }else if needGoingPlayTime > maxPlayTime {
            needGoingPlayTime = maxPlayTime
        }
        // 2. 赋值
        playTimeLabel.text = "\(needGoingPlayTime.timeString()):\(maxPlayTime.timeString())"
    }
    // 处理增加的秒数
    fileprivate func dealForwardTimeLabel() {
        let second = TimeInterval(translate) * 0.5
        if second >= 0 {
            forwardTimeLabel.text = "+\((second).format(f: ".0"))秒"
        }else {
            forwardTimeLabel.text = "\((second).format(f: ".0"))秒"
        }
    }
    // 处理滑动速度
    fileprivate func dealForwardSpeedLabel() {
        
    }
    // 处理progress
    fileprivate func dealProgressView() {
        let percent = needGoingPlayTime/maxPlayTime
        playPercentProgress.progress = Float(percent)
    }
}

