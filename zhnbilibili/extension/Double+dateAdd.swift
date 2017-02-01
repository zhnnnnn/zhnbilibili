//
//  Int+dateAdd.swift
//  zhnbilibili
//
//  Created by 张辉男 on 16/12/30.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

extension Double {

    func showTime() -> String {
        let currentTimeInterval = TimeInterval(self)
        let selfDate = Date(timeIntervalSince1970: currentTimeInterval)
        let dateComponent = Calendar.current.dateComponents([.day], from: selfDate, to: Date())
        guard let day = dateComponent.day else {return ""}
        if day == 0 {
            return "今天投递"
        }else {
            return "\(day)天前投递"
        }
    }
    
    func commendTime() -> String {
        let currentTimeInterval = TimeInterval(self)
        let selfDate = Date(timeIntervalSince1970: currentTimeInterval)
        let dateComponent = Calendar.current.dateComponents([.minute], from: selfDate, to: Date())
        guard let minute = dateComponent.minute else {return ""}
        let hour = minute / 60
        if hour == 0 {
            return "\(minute)分钟前"
        }else {
            if hour < 24 {
                return "\(hour)小时前"
            }else {
                let day = hour / 24
                if day > 0 {
                   return "\(day)天前"
                }else {
                    return ""
                }
            }
        }
        
    }
}
