//
//  DisPatchQueue+afrer.swift
//  zhnbilibili
//
//  Created by zhn on 16/11/23.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

extension DispatchQueue {
    
    class func  afer(time:Double,action:@escaping ()->()){
        let when = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: when, execute: {
            action()
        })
    }
}
