//
//  UIGestureRecognizer+zhnAdd.swift
//  zhnbilibili
//
//  Created by zhn on 16/11/17.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit
import ObjectiveC.runtime

extension UITapGestureRecognizer {
    
    typealias tapAction = @convention(block) ()->Void //  @convention貌似是会把闭包变成block
    // 存储的key值(oc 一般用_cmd来当值，不知道swift里有没有类似的，查了貌似没找到)
    fileprivate struct AssociatedKeys {
        static var DescriptiveName = "nsh_DescriptiveName"
    }
    
    convenience init(tap:tapAction) {
        self.init()
        // 闭包要先转成object不然要报错
        let dealObject: AnyObject = unsafeBitCast(tap, to: AnyObject.self)
        self.addTarget(self, action: #selector(action))
        objc_setAssociatedObject(self,&AssociatedKeys.DescriptiveName,dealObject, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func action() {
        let tap = self.getAction()
        tap()
    }
}

extension UITapGestureRecognizer {
   
    func getAction() -> tapAction{
        let action:AnyObject = objc_getAssociatedObject(self,&AssociatedKeys.DescriptiveName) as AnyObject
        let closure = unsafeBitCast(action, to: tapAction.self)
        return closure
    }
}
