//
//  hairLineConstraint.swift
//  zhnbilibili
//
//  Created by 张辉男 on 16/12/30.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class hairLineConstraint: NSLayoutConstraint {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if self.constant == 1 {
            self.constant = 1/UIScreen.main.scale
        }
    }
}
