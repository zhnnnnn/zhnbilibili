//
//  ZHNLog.swift
//  zhnbilibili
//
//  Created by zhn on 16/11/17.
//  Copyright © 2016年 zhn. All rights reserved.
//

import Foundation

func println( _ item:@autoclosure () -> Any) {
    #if DEBUG
        print(item())
    #endif
}
