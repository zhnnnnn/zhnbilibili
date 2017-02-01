//
//  UIimageView+gifAdd.swift
//  bilibiliFresh
//
//  Created by zhn on 16/11/16.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

extension UIImageView {
    
    // 兔耳朵动画的gif
    class func createRabbitReFreshGif() -> UIImageView{
        let gifImage = UIImageView()
        var gifImageArray = [UIImage]()
        for i in 0..<3{
            let image = UIImage(named: "common_rabbitBar_face\(i)")
            gifImageArray.append(image!)
        }
        gifImage.contentMode = UIViewContentMode.center
        gifImage.animationImages = gifImageArray
        gifImage.animationDuration = 0.5
        gifImage.animationRepeatCount = 0
        return gifImage
    }
    
    // 加载视频的gif
    class func createPlayLoadingGif() -> UIImageView {
        let gifImage = UIImageView()
        var gifImageArray = [UIImage]()
        for i in 1...5{
            let image = UIImage(named: "ani_loading_\(i)")
            gifImageArray.append(image!)
        }
        gifImage.contentMode = UIViewContentMode.center
        gifImage.animationImages = gifImageArray
        gifImage.animationDuration = 0.3
        gifImage.animationRepeatCount = 0
        return gifImage
    }
    
    class func createFreshingGif() -> UIImageView {
        let gifImage = UIImageView()
        var gifImageArray = [UIImage]()
        for i in 1...4 {
            let image = UIImage(named: "refresh_logo_\(i)")
            gifImageArray.append(image!)
        }
        gifImage.contentMode = UIViewContentMode.center
        gifImage.animationImages = gifImageArray
        gifImage.animationDuration = 0.3
        gifImage.animationRepeatCount = 0
        return gifImage
    }
    
}
