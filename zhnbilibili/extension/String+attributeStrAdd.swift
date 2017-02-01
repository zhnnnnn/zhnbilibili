//
//  String+attributeStrAdd.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/4.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit

extension String {

    static func elecAttributes(count: Int) -> NSAttributedString {
        let str = "等\(count)人本月为我充电"
        let attributedString = NSMutableAttributedString(string: str)
        let selfToNSString = str as NSString
        // 2
        let firstAttributes = [NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName: UIFont.systemFont(ofSize: 11)] as [String : Any]
        let secondAttributes = [NSForegroundColorAttributeName: knavibarcolor, NSFontAttributeName: UIFont.systemFont(ofSize: 11)] as [String : Any]
        let thirdAttributes = [NSForegroundColorAttributeName: UIColor.lightGray,  NSFontAttributeName: UIFont.systemFont(ofSize: 11)] as [String : Any]
        
        // 3
        attributedString.addAttributes(firstAttributes, range: selfToNSString.range(of: "等"))
        attributedString.addAttributes(secondAttributes, range: selfToNSString.range(of: "\(count)"))
        attributedString.addAttributes(thirdAttributes, range: selfToNSString.range(of: "人本月为我充电"))
        
        return attributedString
    }
}
