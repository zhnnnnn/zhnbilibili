//
//  ZHNnetworkTool.swift
//  zhnbilibili
//
//  Created by zhn on 16/11/17.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

enum MethodType {
    case get
    case post
}

class ZHNnetworkTool {
    
    /// 接口返回的是json
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
    
    /// 接口返回的是data
    @discardableResult // 返回值可以不接受（ 返回的DataRequest有cancle方法能取消请求）
    class func dataReponeseRequestdata(_ type : MethodType, URLString : String, parameters : [String : Any]? = nil, finishedCallback :  @escaping (_ result : Any) -> () , errorCallBack : @escaping (_ faliue : Error) -> ()) -> DataRequest{
        
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        
        return Alamofire.request(URLString, method: method, parameters: parameters).responseString(completionHandler: { (response) in
            guard let result = response.result.value else {return}
            let nsResult = result as NSString
            let startString = "seasonListCallback("
            let tempString = nsResult.substring(from: startString.characters.count) as NSString
            let length = tempString.length - 2
            let resultString = tempString.substring(to: length) as NSString
            finishedCallback(resultString)
        })
    
    }
}
