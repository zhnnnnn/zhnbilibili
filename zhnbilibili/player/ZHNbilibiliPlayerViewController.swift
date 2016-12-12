//
//  ZHNbilibiliPlayerViewController.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/6.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit
import IJKMediaFramework

class ZHNbilibiliPlayerViewController: UIViewController {

    // 直播的路径
    var liveString: String?
    // 播放器
    var player: IJKFFMoviePlayerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(liveString)
        guard let liveString = liveString else {return}
        guard let urlplayer = IJKFFMoviePlayerController(contentURLString: liveString, with: nil) else {return}
        player = urlplayer
        view.addSubview(urlplayer.view)
        urlplayer.view.frame = view.bounds
        urlplayer.prepareToPlay()
        urlplayer.scalingMode = .aspectFill

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
