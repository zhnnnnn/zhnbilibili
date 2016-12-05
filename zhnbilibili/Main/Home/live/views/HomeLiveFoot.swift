//
//  HomeLiveFoot.swift
//  zhnbilibili
//
//  Created by zhn on 16/11/30.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class HomeLiveFoot: UICollectionReusableView {
    
    lazy var allLiveButton: UIButton = {
        let allButton = UIButton()
        allButton.layer.cornerRadius = 5
        allButton.setTitle("全部直播", for: .normal)
        allButton.setTitleColor(UIColor.black, for: .normal)
        allButton.setTitleColor(UIColor.black, for: .highlighted)
        allButton.backgroundColor = UIColor.white
        allButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        return allButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(allLiveButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        allLiveButton.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 10, left: 20, bottom: 15, right: 20))
        }
    }
}
