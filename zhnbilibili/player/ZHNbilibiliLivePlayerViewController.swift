//
//  ZHNbilibiliLivePlayerViewController.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/6.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit


class ZHNbilibiliLivePlayerViewController: ZHNPlayerBaseViewController {
    
    var liveModel: homeLiveDetailModel? {
        didSet {
            detailView.detailModel = liveModel
            livePlayFullScreenMenuView.menuTop.detailModel = liveModel
        }
    }
    
    lazy var detailView: ZHNliveDetailView = {
        let detailView = ZHNliveDetailView.instanceView()
        return detailView
    }()
    
    override func viewDidLoad() {
        
        // 1. 需要先添加展示细节的view不然会把player遮挡住
        view.addSubview(detailView)
        detailView.frame = CGRect(x: 0, y: knormalPlayerHeight, width: kscreenWidth, height: 90)
        
        // 2. 调用父类的方法
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 加载player
        loadPlayer()
    }
}







