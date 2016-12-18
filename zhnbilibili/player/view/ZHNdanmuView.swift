//
//  ZHNdanmuView.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/18.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class ZHNdanmuView: UIView {

    // 快进快退的时间
    var predictedTime: TimeInterval = 0
    // 初始化弹幕的时间
    var startDate: Date?
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
        startDate = Date()
        renderer.start()
    }
}

//======================================================================
// MARK:- 私有方法
//======================================================================
extension ZHNdanmuView {
    fileprivate func walkTextScriptDes(model: danmuModel){
        let descriptor = BarrageDescriptor()
        let speed: NSNumber = 100
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
        descriptor.params["shadowColor"] = UIColor.darkGray
        descriptor.params["direction"] = direction;
        renderer.receive(descriptor)
    }
}

//======================================================================
// MARK:- 弹幕引擎的代理方法
//======================================================================
extension ZHNdanmuView: BarrageRendererDelegate {
    func time(for renderer: BarrageRenderer!) -> TimeInterval {
        guard let startDate = startDate else {return 0}
        var interval = Date().timeIntervalSince(startDate)
        interval += predictedTime
        return interval
    }
}
