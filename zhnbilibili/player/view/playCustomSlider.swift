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
        let newBounds = CGRect(x: rect.origin.x, y: rect.origin.y, width: 100, height: 100)
        return super.thumbRect(forBounds: newBounds, trackRect: rect, value: value)
    }
}
