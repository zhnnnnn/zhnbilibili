//
//  ZHNplayNormalMenuViewActionModel.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/10.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class ZHNplayNormalMenuViewActionModel: ZHNplayBaseActionModel {

}

extension ZHNplayNormalMenuViewActionModel: ZHNlivePlayMenuNormalViewDelegate {
    
    func pauseAction(isPlaying: Bool) {
        guard let playerVC = currentViewController as? ZHNPlayerBaseViewController else {return}
        // 判断暂停还是播放
        if isPlaying {
            playerVC.player?.pause()
        }else{
            playerVC.player?.play()
        }
    }
    
    func popViewControllerAction() {
        _ = currentViewController?.navigationController?.popViewController(animated: true)
    }
    
    func shareAction() {
    }
    
    func fullScreenAction() {
        NotificationCenter.default.post(name: kfullscreenActionNotification, object: nil)
    }
}
