//
//  playerBlurView.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/13.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit
import DynamicBlurView

// 1.播放图标的位置常量
fileprivate let startImageBeginWidth: CGFloat = 60
fileprivate let startImageEndWidth: CGFloat = 30
fileprivate let startImageBeginHeight: CGFloat = 40
fileprivate let startImageEndHeight:CGFloat = 20
fileprivate let startImageBeginX: CGFloat = kscreenWidth - 80
fileprivate let startImageEndX: CGFloat = (kscreenWidth - startImageEndWidth)/2
fileprivate let startImageBeginY: CGFloat = knormalPlayerHeight - 60
fileprivate let startImageEndY: CGFloat = 30

class playerBlurView: UIView {

    /// 返回按你的action
    var backButtonAction: (()->Void)?
    /// 点击事件的action
    var tapAction: (()->Void)?
    /// 毛玻璃显示的本地图片
    var blurImage: UIImage? {
        didSet{
            backImageView.image = blurImage
            self.addUI()
        }
    }
    /// 毛玻璃显示的网络图片
    var blurImageString: String? {
        didSet{
            // 添加背景
            guard let blurImageString = blurImageString else {return}
            let url = URL(string: blurImageString)
            backImageView.sd_setImage(with: url)
            // 初始化ui
            self.addUI()
        }
    }
    
    
    var percent: CGFloat = 0 {
        didSet{
            /// 1.位置的改变
                // <1. 播放的图标
            let imageWidth = percent * (startImageBeginWidth - startImageEndWidth) + startImageEndWidth
            let imageHeight = percent * (startImageBeginHeight - startImageEndHeight) + startImageEndHeight
            let imageX = percent * (startImageBeginX - startImageEndX) + startImageEndX
            let imageY = percent * (startImageBeginY - startImageEndY) + startImageEndY
            self.startImageView.frame = CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeight)
                // <2. 背景
            self.backImageView.setHeight(H: knavibarheight + (knormalPlayerHeight - knavibarheight)*percent)
            self.blurMaskView.setHeight(H: self.backImageView.zhnheight)
                // <3. 标题
            self.titleLabel.center = CGPoint(x: (1-percent)*50 + kscreenWidth/2, y: 42)
            /// 2.标题透明度的改变
            if percent > 0.4 && percent <= 1 {
                self.titleLabel.alpha = (percent - 0.4)/0.6
            }else if percent >= 0 && percent < 0.2 {
                self.titleLabel.alpha = (0.2 - percent)*5
            }else {
                self.titleLabel.alpha = 0
            }
            /// 3.毛玻璃效果的变化
            self.blurMaskView.blurRadius = (1 - percent) * 50 + 10
        }
    }
    
    
    // MARK: - 懒加载控件
    fileprivate lazy var backButton: UIButton = {
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "videoinfo_back"), for: .normal)
        backButton.setImage(UIImage(named: "videoinfo_back"), for: .highlighted)
        backButton.addTarget(self, action: #selector(popViewAction), for: .touchUpInside)
        return backButton
    }()
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.text = "(null)"
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    fileprivate lazy var startImageView: UIImageView = {
        let startImageView = UIImageView()
        startImageView.image = UIImage(named: "player_start_iphone_window")
        startImageView.contentMode = .scaleAspectFill
        return startImageView
    }()
    fileprivate lazy var blurMaskView: DynamicBlurView = {
        let blurMaskView = DynamicBlurView()
        blurMaskView.blurRadius = 10
        blurMaskView.blendColor = UIColor.black
        return blurMaskView
    }()
    lazy var backImageView: UIImageView = {
        let backImageView = UIImageView()
        backImageView.contentMode = .scaleAspectFill
        backImageView.clipsToBounds = true
        return backImageView
    }()
    
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kHomeBackColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 添加手势
        guard let tapAction = tapAction else {return}
        let tapGes = UITapGestureRecognizer(tap: tapAction)
        self.addGestureRecognizer(tapGes)
    }
    
}

// MARK: - 私有方法
extension playerBlurView {
    fileprivate func addUI() {
        self.addSubview(backImageView)
        self.addSubview(blurMaskView)
        self.addSubview(backButton)
        self.addSubview(titleLabel)
        self.addSubview(startImageView)
        
        backImageView.frame = CGRect(x: 0, y: 0, width: kscreenWidth, height: knormalPlayerHeight)
        blurMaskView.frame = backImageView.frame
        startImageView.frame = CGRect(x: kscreenWidth - 80, y: knormalPlayerHeight - 60, width: 60, height: 40)
        titleLabel.center = CGPoint(x: kscreenWidth/2, y: 42)
        titleLabel.bounds = CGRect(x: 0, y: 0, width: 200, height: 30)
        backButton.center = CGPoint(x: 20, y: 30)
        backButton.sizeToFit()
    }
}

// MARK: - target action
extension playerBlurView {
    @objc fileprivate func popViewAction() {
        guard let action = backButtonAction else {return}
        action()
    }
}
