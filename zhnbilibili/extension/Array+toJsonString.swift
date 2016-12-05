//
//  Array+toJsonString.swift
//  zhnbilibili
//
//  Created by zhn on 16/11/21.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

extension NSArray {

    // array 转字符串
    func arrayToString() -> String? {
        let data = try?JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
        var dictStr:String? = nil
        if data != nil {
            dictStr = String(data: (data)!, encoding: String.Encoding.utf8)
        }
        return dictStr
    }
}
