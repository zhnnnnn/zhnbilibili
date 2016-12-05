//
//  UIView+cornerradiusAdd.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/3.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable var zhn_cornerRadius:CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
