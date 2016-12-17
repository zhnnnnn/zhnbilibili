//
//  ZHNplayFullScreenMenuViewActionModel.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/11.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class ZHNplayFullScreenMenuViewActionModel: ZHNplayBaseActionModel {

}

extension ZHNplayFullScreenMenuViewActionModel: ZHNliveFullscreenMenuViewDelegate {
    func backAction() {
        guard let playerVC = currentViewController as? ZHNPlayerBaseViewController else {return}
        playerVC.resignFullScreen()
    }
}
