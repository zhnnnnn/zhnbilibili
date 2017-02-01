//
//  Int+coutdealAdd.swift
//  zhnbilibili
//
//  Created by zhn on 16/11/28.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

fileprivate let showingMaxCount:Int = 10000

extension Int {
    
    func returnShowString() -> String {
        
        if self > showingMaxCount{
            let newCount = Double(self)/Double(showingMaxCount)
            let formatter = String(format:"%.1f",newCount)
            let newStr = "\(formatter)万"
            return newStr
        }else{
            return "\(self)"
        }
    }
    
    func CHNweekDay() -> String {
        if self == 1 {
            return "一"
        }
        if self == 2 {
            return "二"
        }
        if self == 3 {
            return "三"
        }
        if self == 4 {
            return "四"
        }
        if self == 5 {
            return "五"
        }
        if self == 6 {
            return "六"
        }
        if self == 7 {
            return "日"
        }
        return ""
    }
}
