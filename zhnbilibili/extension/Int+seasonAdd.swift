//
//  Int+seasonAdd.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/4.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

extension Int {
    
    func seasionIconImage() -> UIImage {
        // 1. 冬天
        if self == 1 {
           return UIImage(named: "season_winter_icon")!
        }
        // 2. 春天
        if self == 2 {
            return UIImage(named: "season_spring_icon")!
        }
        // 3. 夏天
        if self == 3 {
            return UIImage(named: "season_summer_icon")!
        }
        // 4. 秋天
        if self == 4 {
            return UIImage(named: "season_autumn_icon")!
        }
        return UIImage(named: "season_autumn_icon")!
    }
    
    func seasionMoth() -> String {
        // 1. 冬天
        if self == 1 {
            return "1"
        }
        // 2. 春天
        if self == 2 {
            return "4"
        }
        // 3. 夏天
        if self == 3 {
            return "7"
        }
        // 4. 秋天
        if self == 4 {
            return "10"
        }
        return ""
    }
    
}
