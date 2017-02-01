//
//  playCustomSlider.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/16.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class playCustomSlider: UISlider {

    // 滑块的高度
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let bounds = super.trackRect(forBounds: bounds)
        return CGRect(x: bounds.origin.x, y: (bounds.origin.y - 3)/2 , width: bounds.size.width, height: 3)
    }
    
    // 滑块的触摸范围
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        let widthHeight: CGFloat = 50
        let oldRect = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        let thumbCenter = CGPoint(x: oldRect.origin.x + (oldRect.width)/2, y: oldRect.origin.y + (oldRect.height)/2)
        let newRect = CGRect(x: thumbCenter.x - widthHeight/2, y: thumbCenter.y - widthHeight/2, width: widthHeight, height: widthHeight)
        return newRect
    }
    

}
