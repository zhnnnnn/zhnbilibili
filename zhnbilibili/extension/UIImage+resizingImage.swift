//
//  UIImage+resizingImage.swift
//  
//
//  Created by zhn on 16/12/8.
//
//

import UIKit

extension UIImage {
    /// 处理拉伸的背景图片
    func zhnResizingImage() -> UIImage {
        let hinset = self.size.width / 2
        let vinset = self.size.height / 2
        return self.resizableImage(withCapInsets: UIEdgeInsetsMake(vinset, hinset, vinset, hinset), resizingMode: .stretch)
    }
}
