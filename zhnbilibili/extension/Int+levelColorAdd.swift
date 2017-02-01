//
//  Int+levelColorAdd.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/12.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit




extension Int {
    
    func levelColor() -> UIColor {
        if self == 0 {
            return UIColor.ZHNcolor(red: 178, green: 178, blue: 178, alpha: 1)
        }
        
        if self == 1 {
            return UIColor.ZHNcolor(red: 178, green: 178, blue: 178, alpha: 1)
        }
        
        if self == 2 {
            return UIColor.ZHNcolor(red: 133, green: 216, blue: 163, alpha: 1)
        }
        
        if self == 3 {
            return UIColor.ZHNcolor(red: 130, green: 199, blue: 223, alpha: 1)
        }
        
        if self == 4 {
            return UIColor.ZHNcolor(red: 253, green: 163, blue: 106, alpha: 1)
        }
        
        if self == 5 {
            return UIColor.ZHNcolor(red: 252, green: 85, blue: 8, alpha: 1)
        }
        
        if self == 6 {
            return UIColor.ZHNcolor(red: 251, green: 0, blue: 7, alpha: 1)
        }
        
        if self == 7 {
            return UIColor.ZHNcolor(red: 219, green: 0, blue: 231, alpha: 1)
        }
        
        if self == 8 {
            return UIColor.ZHNcolor(red: 111, green: 0, blue: 247, alpha: 1)
        }
        
        if self == 9 {
            return UIColor.ZHNcolor(red: 17, green: 17, blue: 17, alpha: 1)
        }
        
        return UIColor.black
    }
    
    
}
