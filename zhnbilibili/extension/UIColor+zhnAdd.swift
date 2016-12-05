//
//  UIColor+zhnAdd.swift
//  bilibiliFresh
//
//  Created by zhn on 16/11/15.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

extension UIColor{
    class func ZHNcolor(red:CGFloat,green:CGFloat,blue:CGFloat,alpha:CGFloat) -> UIColor {
       return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
}
