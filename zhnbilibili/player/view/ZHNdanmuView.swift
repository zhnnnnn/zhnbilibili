//
//  ZHNdanmuView.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/18.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit
import IJKMediaFramework

class ZHNdanmuView: UIView {

    // 是否是全屏播放的状态(bilibili的弹幕是可以在全屏非全屏的切换当中改变字体大小的，但是这个库实现不了那种效果，它是预先缓存了数据了的。。。。。需要自己写个弹幕组件来满足这种效果)
    var isfullScreen: Bool = false
    // 当前的播放器
    var player: IJKFFMoviePlayerController?
    // 弹幕的数据
    var danmuModelArray: [danmuModel]? {
        didSet{
            guard let danmuModelArray = danmuModelArray else {return}
            for model in danmuModelArray {
                walkTextScriptDes(model: model)
            }
        }
    }
    
    // MARK: - 懒加载控件
    lazy var renderer: BarrageRenderer = {
        let renderer = BarrageRenderer()
        renderer.delegate = self
        renderer.redisplay = true
        return renderer
    }()
    
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubview(renderer.view)
    }
    
    deinit {
        self.renderer.stop()
    }
}

//======================================================================
// MARK:- 公开的方法
//======================================================================
extension ZHNdanmuView {
    func startRender() {
//        startDate = Date()
        renderer.start()
    }
    
    func endRender() {
        renderer.stop()
    }
}

//======================================================================
// MARK:- 私有方法
//======================================================================
extension ZHNdanmuView {
    fileprivate func walkTextScriptDes(model: danmuModel){
        let descriptor = BarrageDescriptor()
        let speed = NSNumber(value: model.danmuText.characters.count * 2 + 100)
        let direction: NSNumber = 1
        let delay = model.danmuShowingTime
        if model.danmuShowIngType == 1 {// 普通弹幕
            descriptor.spriteName = String(describing: BarrageWalkTextSprite.self)
            descriptor.params["speed"] = speed
            descriptor.params["delay"] = delay
        }else {// 悬浮弹幕
            let duration: NSNumber = 3
            let fadeinTime: NSNumber = 1
            let fadeoutTime: NSNumber = 1
            let side: NSNumber = 0
            descriptor.spriteName = String(describing: BarrageFloatTextSprite.self)
            descriptor.params["duration"] = duration
            descriptor.params["fadeInTime"] = fadeinTime
            descriptor.params["fadeOutTime"] = fadeoutTime
            descriptor.params["side"] = side
        }
        let hexColorString = String(model.danmuColor,radix:16)
        let textColor = UIColor.ColorHex(hex: hexColorString)
        descriptor.params["text"] = model.danmuText
        descriptor.params["textColor"] = textColor
        descriptor.params["shadowColor"] = UIColor.black
        descriptor.params["direction"] = direction;
        renderer.receive(descriptor)
    }
}

//======================================================================
// MARK:- 弹幕引擎的代理方法
//======================================================================
extension ZHNdanmuView: BarrageRendererDelegate {
    func time(for renderer: BarrageRenderer!) -> TimeInterval {
        let optionCurrentTime = player != nil ? player?.currentPlaybackTime : 0
        let currentTime = optionCurrentTime != nil ? optionCurrentTime : 0
        return currentTime!
    }
}
