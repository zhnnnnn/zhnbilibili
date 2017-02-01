//
//  ZHNplayerMenuBaseView.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/10.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit
import MediaPlayer

// 当前手势的方向
enum controlDirection {
    case left
    case right
}

// 当前手势控制的类型
enum controlType {
    case sound
    case light
    case playTime
}

// 滑动切换播放进度的通知
let kSwipeScreenToChangePlayTimeNotification = Notification.Name("kSwipeScreenToChangePlayTimeNotification")
let kSwipeScrrenBeginNotification = Notification.Name("kSwipeScrrenBeginNotification")
let kSwipeScreenEndNotification = Notification.Name("kSwipeScreenEndNotification")
let ktransKey = "ktransKey"

class ZHNplayerMenuBaseView: UIView {

    /// 动画的timer
    var animateTimer: SwiftTimer?
    
    /// 手势的方向 （左右控制亮度和音量）
    var direction: controlDirection?
    
    /// 手势控制的类型 (手势一次只能控制一个类型不能同时控制好几个)
    var controltype: controlType?
    
    /// 声音
    var screenVolum: CGFloat = 0
    var volumSlider: UISlider?
    
    // MARK: - 懒加载控件
    lazy var topContainerView: UIView = {
        let topContainerView = UIView()
        return topContainerView
    }()

    lazy var bottomContainerView: UIView = {
        let bottomContainerView = UIView()
        return bottomContainerView
    }()
    
    lazy var controlsView: UIView = {
        let controlsView = UIView()
        return controlsView
    }()
    
    lazy var pauseNoticeLabel: UILabel = {
        let pauseNoticeLabel = UILabel()
        pauseNoticeLabel.text = "暂停播放"
        pauseNoticeLabel.font = UIFont.systemFont(ofSize: 10)
        pauseNoticeLabel.textColor = UIColor.white
        pauseNoticeLabel.backgroundColor = UIColor.ZHNcolor(red: 0, green: 0, blue: 0, alpha: 0.3)
        pauseNoticeLabel.textAlignment = .center
        return pauseNoticeLabel
    }()
    
    
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(controlsView)
        self.addSubview(topContainerView)
        self.addSubview(bottomContainerView)
        self.addSubview(pauseNoticeLabel)
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 1. 初始化位置
        controlsView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        topContainerView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.height.equalTo(self).multipliedBy(0.5)
        }
        bottomContainerView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(self).multipliedBy(0.5)
        }
        // 2. 添加timer
        addTimer(needStart: false)
        // 3. 添加手势
        addTapGesture()
        addPanGesture()
        // 4. 初始化音量的控制
        initVolumeControl()
    }
}

//======================================================================
// MARK:- 公共方法
//======================================================================
extension ZHNplayerMenuBaseView {
    // 暂停播放的提示效果
    func noticePauseState(pause: Bool) {
        // 1. 提示的字体
        pauseNoticeLabel.text = pause == true ? "暂停播放":"继续播放"
        // 2. 初始化位置
        pauseNoticeLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self).offset(60)
            make.height.equalTo(0)
        }
        // 3. 执行动画
        DispatchQueue.afer(time: 0.2) {
            UIView.animate(withDuration: 0.5, animations: {
                self.pauseNoticeLabel.snp.remakeConstraints { (make) in
                    make.left.right.equalTo(self)
                    make.top.equalTo(self).offset(60)
                    make.height.equalTo(20)
                }
                self.layoutIfNeeded()
                self.pauseNoticeLabel.layoutIfNeeded()
                
            }) { (complete) in
                DispatchQueue.afer(time: 0.2, action: {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.pauseNoticeLabel.snp.remakeConstraints { (make) in
                            make.left.right.equalTo(self)
                            make.top.equalTo(self).offset(60)
                            make.height.equalTo(0)
                        }
                        self.layoutIfNeeded()
                        self.pauseNoticeLabel.layoutIfNeeded()
                        }, completion: { (complete) in
                    })
                })
            }
        }
    }
    
    // 添加timer
    func addTimer(needStart: Bool) {
        // 1.先移除之前的timer
        removeTimer()
        // 2.再添加timer
        animateTimer = SwiftTimer(interval: .seconds(15)) { (timer) in
            self.disMissAnimate()
        }
        if needStart {
            animateTimer?.start()
        }
    }
    
}

//======================================================================
// MARK:- 私有方法
//======================================================================
extension ZHNplayerMenuBaseView {
    
    // menu dismiss的效果
    fileprivate func disMissAnimate() {
        UIView.animate(withDuration: 1, animations: {
            // 1. 位移动画
            self.topContainerView.transform = self.topContainerView.transform.translatedBy(x: 0, y: -50)
            self.bottomContainerView.transform = self.bottomContainerView.transform.translatedBy(x: 0, y: 50)
            // 2. 透明度动画
            self.topContainerView.alpha = 0
            self.bottomContainerView.alpha = 0
            // 3. 隐藏statusbar
            //
            // 我播放普通视频界面的显示细节地方用的是viewcontroller。。。这里就会有一个问题，当statubar隐藏的之前view的frame的y就是-20,这时候显示是正常的但是statubar隐藏掉之后y还是-20就会有问题会上移。。。用view的情况下应该不会有这个问题。这里懒的重新修改了。。不知道大家有没有方法让这个上移效果没有
            //
//            UIApplication.shared.isStatusBarHidden = true
            
        }) { (complete) in
            self.topContainerView.transform = CGAffineTransform.identity
            self.bottomContainerView.transform = CGAffineTransform.identity
        }
    }
    
    // 移除timer
    fileprivate func removeTimer() {
        animateTimer = nil
    }
    
    // 添加点击的手势
    fileprivate func addTapGesture() {
        let tapGes = UITapGestureRecognizer { [weak self] in
            // 1. 处理timer
            var curretAlpha: CGFloat = 0
            if self?.topContainerView.alpha == 0 {
                curretAlpha = 1
                self?.addTimer(needStart: true)
                UIApplication.shared.isStatusBarHidden = false
            }else{
                curretAlpha = 0
                self?.removeTimer()
//                UIApplication.shared.isStatusBarHidden = true
            }
            // 2. 处理显示
            UIView.animate(withDuration: 0.5, animations: {
                self?.bottomContainerView.alpha = curretAlpha
                self?.topContainerView.alpha = curretAlpha
            })
        }
        self.addGestureRecognizer(tapGes)
    }
    
    // 添加拖动的手势
    fileprivate func addPanGesture() {
        let pangesture = UIPanGestureRecognizer(target: self, action: #selector(panAction(panGes:)))
        self.addGestureRecognizer(pangesture)
    }
    
    // 拿到控制音量的slider
    fileprivate func initVolumeControl() {
        let volumView = MPVolumeView()
        volumSlider = nil
        for view in volumView.subviews {
            if view is UISlider {
                volumSlider = view as? UISlider
                break
            }
        }
    }
}

//======================================================================
// MARK:- target action
//======================================================================
extension ZHNplayerMenuBaseView {
    @objc func panAction(panGes: UIPanGestureRecognizer) {
        
        if panGes.state == UIGestureRecognizerState.began {
            
            // 1.先判断一下是在左边还是右边
            let locationX = panGes.location(in: controlsView).x
            if locationX <= controlsView.zhnWidth/2 { // 左边 (控制亮度)
                direction = .left
            } else { // 右边 (控制声音)
                direction = .right
            }
            
            // 2.发送手势开始的通知
            NotificationCenter.default.post(name: kSwipeScrrenBeginNotification, object: nil, userInfo: nil)
            
        }else if panGes.state == UIGestureRecognizerState.changed {
            
            // 1. 判断当前控制的类型
            let transX = panGes.translation(in: controlsView).x
            let transY = panGes.translation(in: controlsView).y
            if controltype == nil {
                if transX != 0 {
                    controltype = .playTime
                }
                
                if transY != 0 {
                    if direction == .left {
                        controltype = .light
                    }else {
                        controltype = .sound
                    }
                }
            }
            
            // 2. 执行响应的操作
            if controltype == .light {// 音量的调节
                let delta = transY / 10000
                UIScreen.main.brightness -= delta
            }else if controltype == .sound {// 亮度的调节 （亮度调节展示的view需要自己实现。。。这里偷懒先放一放）
                let delta = transY / 10000
                volumSlider?.value -= Float(delta)
            }else if controltype == .playTime {
                NotificationCenter.default.post(name: kSwipeScreenToChangePlayTimeNotification, object: nil, userInfo: [ktransKey:Float(transX)])
            }
            
        }else if panGes.state == UIGestureRecognizerState.ended || panGes.state == UIGestureRecognizerState.cancelled {
            controltype = nil
            NotificationCenter.default.post(name: kSwipeScreenEndNotification, object: nil, userInfo: nil)
        }
    }
}




