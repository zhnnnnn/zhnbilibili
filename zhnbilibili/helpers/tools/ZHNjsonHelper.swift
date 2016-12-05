//
//  ZHNjsonHelper.swift
//  zhnbilibili
//
//  Created by zhn on 16/11/21.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class ZHNjsonHelper {

     // 获取json array 的字符串（字典转模型需要的）
    class func getjsonArrayString(key:String,json:Any) -> String? {
        
        // 1.any -> dict
        guard let jsonDict = json as? [String:Any] else {return nil}
        
        // 2.dict -> array
        guard let jsonArray = jsonDict[key] as? NSArray else {return nil}
        
        // 3.array -> string
        guard let jsonString = jsonArray.arrayToString() else {return nil}
        
        // 4.返回 string
        return jsonString
    }
    
    
}
