//
//  TimeInterval+playerAdd.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/16.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

extension TimeInterval {
    func timeString() -> String {
        let minute = Int(self / 60)
        let second = Int(self) % 60
        var minuteString = ""
        var secondString = ""
        // 分钟
        if minute < 10 {
            minuteString = "0\(minute)"
        }else {
            minuteString = "\(minute)"
        }
        // 秒
        if second < 10 {
            secondString = "0\(second)"
        }else {
            secondString = "\(second)"
        }
        
        return"\(minuteString):\(secondString)"
    }
    
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}
