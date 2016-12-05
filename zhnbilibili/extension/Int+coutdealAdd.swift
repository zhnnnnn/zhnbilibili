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
    
}
