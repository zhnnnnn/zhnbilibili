//
//  ZHNnormalPlayWindowMenuVIew.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/15.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class ZHNnormalPlayWindowMenuVIew: ZHNlivePlayNoramlMenuView {
    
    // 重新启动一个timer（因为block里面如果view是hidden的情况下是不捕获的）
    var restartTimerAction: (()->Void)?
    // MARK: - 懒加载控件
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.text = "wtffffffffffffffffff"
        titleLabel.textAlignment = .center
        return titleLabel
    }()
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
    lazy var currentMarkProgressView: UIProgressView = {
        let currentMarkProgressView = UIProgressView()
        currentMarkProgressView.backgroundColor = UIColor.clear
        currentMarkProgressView.progressTintColor = knavibarcolor
        currentMarkProgressView.isHidden = true
        return currentMarkProgressView
    }()
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        topContainerView.addSubview(titleLabel)
        bottomContainerView.addSubview(fullTimeLabel)
        bottomContainerView.addSubview(currentTimeLabel)
        bottomContainerView.addSubview(seekedTimeProgress)
        bottomContainerView.addSubview(seekTimeSlider)
        self.addSubview(currentMarkProgressView)
        topContainerView.addObserver(self, forKeyPath: "alpha", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 1.修改标题按钮图片
        backButton.setImage(UIImage(named: "videoinfo_back"), for: .normal)
        backButton.setImage(UIImage(named: "videoinfo_back"), for: .highlighted)
        // 2.加载位置
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(backButton)
            make.centerX.equalTo(self)
            make.width.equalTo(250)
            make.height.equalTo(30)
        }
        
        seekedTimeProgress.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(90)
            make.right.equalTo(self).offset(-115)
            make.centerY.equalTo(fullScreenButton)
        }
        
        seekTimeSlider.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(90)
            make.right.equalTo(self).offset(-115)
            make.centerY.equalTo(fullScreenButton).offset(12)
            make.height.equalTo(50)
        }
        
        currentTimeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(fullScreenButton)
            make.right.equalTo(seekTimeSlider.snp.left).offset(-8)
        }
        
        fullTimeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(fullScreenButton)
            make.left.equalTo(seekTimeSlider.snp.right).offset(8)
        }
        
        currentMarkProgressView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(2)
        }
    }
    
    deinit {
        topContainerView.removeObserver(self, forKeyPath: "alpha")
    }
}

// MARK: - kvo
extension ZHNnormalPlayWindowMenuVIew {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if self.isPlaying && self.topContainerView.alpha == 0 {
            currentMarkProgressView.isHidden = false
            guard let action = restartTimerAction else {return}
            action()
        }else {
            currentMarkProgressView.isHidden = true
            guard let action = restartTimerAction else {return}
            action()
        }
    }
}
