//
//  ZHNplayerUrlLoadingBackViewActionModel.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/8.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class ZHNplayerUrlLoadingBackViewActionModel: ZHNplayBaseActionModel {
}

extension ZHNplayerUrlLoadingBackViewActionModel: ZHNplayerUrlLoadingbackViewDelegate {
    func popViewControllerAction() {
        guard let playerVC = currentViewController as? ZHNPlayerBaseViewController else {return}
        if playerVC.isfullScreen {
            guard let playerVC = currentViewController as? ZHNPlayerBaseViewController else {return}
            playerVC.resignFullScreen()
        } else {
            _ = currentViewController?.navigationController?.popViewController(animated: true)
        }
    }
    
    func fullScreenAction() {
        guard let playerVC = currentViewController as? ZHNPlayerBaseViewController else {return}
        if playerVC.isfullScreen {
            // 1.改变按钮的样式
            playerVC.playLoadingMenuView.urlLoadingFullScreenButon.setImage(UIImage(named: "player_fullScreen_iphone-1"), for: .normal)
            playerVC.playLoadingMenuView.urlLoadingFullScreenButon.setImage(UIImage(named: "player_fullScreen_iphone-1"), for: .highlighted)
            // 2. 退出全屏
            playerVC.resignFullScreen()
        } else {
            // 1.改变按钮的样式
            playerVC.playLoadingMenuView.urlLoadingFullScreenButon.setImage(UIImage(named: "player_window_black"), for: .normal)
            playerVC.playLoadingMenuView.urlLoadingFullScreenButon.setImage(UIImage(named: "player_window_black"), for: .highlighted)
            // 2. 发送通知
            NotificationCenter.default.post(name: kfullscreenActionNotification, object: nil)
        }
    }
    
    func copyMessageAction() {
        currentViewController?.noticeOnlyText("复制成功")
        DispatchQueue.afer(time: 2) {
            self.currentViewController?.clearAllNotice()
        }
    }
}
