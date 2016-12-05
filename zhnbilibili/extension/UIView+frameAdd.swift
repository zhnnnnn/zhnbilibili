//
//  UIView+frameAdd.swift
//  bilibiliFresh
//
//  Created by zhn on 16/11/15.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

extension UIView {
    
    
    // MARK: - 获取
    public var zhnX:CGFloat {
        return frame.origin.x
    }
    
    public var zhnY:CGFloat {
        return frame.origin.y
    }
    
    public var zhnWidth:CGFloat {
        return frame.size.width
    }
    
    public var zhnheight:CGFloat {
        return frame.size.height
    }
    
    public var zhnCenterX:CGFloat {
        return center.x
    }
    
    public var zhnCenterY:CGFloat {
        return center.y
    }
    
    
    // MARK: - 赋值
    func setX(X:CGFloat) {
        let oldRect = frame
        let newRect = CGRect(x: X, y: oldRect.origin.y, width: oldRect.width, height: oldRect.height)
        frame = newRect
    }
   
    func setY(Y:CGFloat) {
        let oldRect = frame
        let newRect = CGRect(x: oldRect.origin.x, y: Y, width: oldRect.width, height: oldRect.height)
        frame = newRect
    }
    
    func setWidth(W:CGFloat) {
        let oldRect = frame
        let newRect = CGRect(x: oldRect.origin.x, y: oldRect.origin.y, width: W,height:oldRect.height)
        frame = newRect
    }
    
    func setHeight(H:CGFloat) {
        let oldRect = frame
        let newRect = CGRect(x: oldRect.origin.x, y: oldRect.origin.y, width: oldRect.width, height: H)
        frame = newRect
    }
}
