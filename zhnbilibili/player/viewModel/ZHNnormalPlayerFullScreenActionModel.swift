//
//  ZHNnormalPlayerFullScreenActionModel.swift
//  zhnbilibili
//
//  Created by 张辉男 on 16/12/28.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class ZHNnormalPlayerFullScreenActionModel: ZHNplayBaseActionModel {

}

extension ZHNnormalPlayerFullScreenActionModel: ZHNnormalFullScreenViewDelegate {
    func pauseAction(isPlaying: Bool) {
        guard let playerVC = currentViewController as? ZHNPlayerBaseViewController else {return}
        // 判断暂停还是播放
        if isPlaying {
            playerVC.player?.pause()
        }else{
            playerVC.player?.play()
        }
    }
    
    func backAction() {
        guard let playerVC = currentViewController as? ZHNPlayerBaseViewController else {return}
        playerVC.resignFullScreen()
    }
}
