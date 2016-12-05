//
//  Date+timeBucket.swift
//  zhnbilibili
//
//  Created by zhn on 16/11/28.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

extension Date {
    
    func getCustomDateString() -> String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: self)
        
        if hour >= 0 && hour < 6  {
            return timeStr(bucket: "凌晨")
        }
        
        if hour >= 6 && hour < 9 {
            return timeStr(bucket: "早上")
        }
        
        if hour >= 9 && hour < 11 {
            return timeStr(bucket: "上午")
        }
        
        if hour >= 11 && hour < 12 {
            return timeStr(bucket: "中午")
        }
        
        if hour >= 12 && hour < 18 {
            return timeStr(bucket: "下午")
        }
        
        if hour >= 18 && hour < 24 {
            return timeStr(bucket: "晚上")
        }
        
        return ""
    }
    
    
    func timeStr(bucket:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let timeStr = dateFormatter.string(from: self)
        return "\(bucket)\(timeStr)"
    }
}


