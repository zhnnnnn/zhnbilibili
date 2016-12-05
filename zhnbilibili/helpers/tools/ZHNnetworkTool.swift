//
//  ZHNnetworkTool.swift
//  zhnbilibili
//
//  Created by zhn on 16/11/17.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit
import Alamofire

enum MethodType {
    case get
    case post
}

class ZHNnetworkTool {
    
    @discardableResult // 返回值可以不接受（ 返回的DataRequest有cancle方法能取消请求）
    class func requestData(_ type : MethodType, URLString : String, parameters : [String : Any]? = nil, finishedCallback :  @escaping (_ result : Any) -> () , errorCallBack : @escaping (_ faliue : Error) -> ()) -> DataRequest{
        
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        
        return Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { (response) in
            
            // 失败的回调
            guard let result = response.result.value else {
                if let error = response.result.error{
                    println(error)
                    errorCallBack(error)
                }
                return
            }
            
            // 成功的回调
            finishedCallback(result)
        }
    }
    
}
