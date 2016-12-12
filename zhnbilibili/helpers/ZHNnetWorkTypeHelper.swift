//
//  ZHNnetWorkTypeHelper.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/11.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class ZHNnetWorkTypeHelper {
    class func netWorkType() -> networkType {
        let tempDelegate = UIApplication.shared.delegate as? AppDelegate
        return (tempDelegate?.netWorktype)!
    }
}
