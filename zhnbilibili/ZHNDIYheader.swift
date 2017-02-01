//
//  ZHNDIYheader.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/10.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit

class ZHNDIYheader: MJRefreshHeader {

    // MARK - 懒加载控件
    lazy var gifImageView: UIImageView = {
        let gifImageView = UIImageView.createFreshingGif()
        gifImageView.image = UIImage(named: "refresh_logo_1")
        return gifImageView
    }()
    lazy var arrowImageView: UIImageView = {
        let arrowImageView = UIImageView()
        arrowImageView.image = UIImage(named: "arrow")
        arrowImageView.contentMode = .scaleAspectFill
        return arrowImageView
    }()
    lazy var noticeLabel: UILabel = {
        let noticeLabel = UILabel()
        noticeLabel.font = UIFont.systemFont(ofSize: 14)
        noticeLabel.text = "再拉,再拉就刷给你看"
        noticeLabel.textAlignment = .center
        return noticeLabel
    }()
    lazy var loadingActivity: UIActivityIndicatorView = {
        let loadingActivity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        loadingActivity.isHidden = true
        return loadingActivity
    }()
    
    // MARK - 控件的初始化
    override func prepare() {
        super.prepare()
        self.mj_h = 85
        self.addSubview(gifImageView)
        self.addSubview(arrowImageView)
        self.addSubview(noticeLabel)
        self.addSubview(loadingActivity)
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        gifImageView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize(width: 150, height: 40))
        }
        noticeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(gifImageView.snp.bottom).offset(5)
            make.left.right.equalTo(gifImageView)
        }
        arrowImageView.snp.makeConstraints { (make) in
            make.right.equalTo(gifImageView.snp.left).offset(-5)
            make.bottom.equalTo(noticeLabel)
            make.size.equalTo(CGSize(width: 20, height: 30))
        }
        loadingActivity.snp.makeConstraints { (make) in
            make.centerY.equalTo(noticeLabel)
            make.right.equalTo(arrowImageView)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
    }
    
    
    // MARK - 拖拽
    override func scrollViewPanStateDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewPanStateDidChange(change)
    }
    
    override func scrollViewContentSizeDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewContentSizeDidChange(change)
    }
    
    override func scrollViewContentOffsetDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewContentOffsetDidChange(change)
    }
    
    override var state: MJRefreshState {
        didSet {
            switch state {
            case .idle: // 普通状态
                noticeLabel.text = "再拉,再拉就刷给你看"
                gifImageView.stopAnimating()
                clearRotaArrow()
                arrowImageView.isHidden = false
                loadingActivity.isHidden = true
            case .pulling: // 拉倒了刷新状态
                noticeLabel.text = "够了啦,松开人家嘛"
                rotaArrow()
            case .refreshing:// 松手刷新
                noticeLabel.text = "耍呀,耍呀,刷完了喵^w^"
                gifImageView.startAnimating()
                arrowImageView.isHidden = true
                loadingActivity.isHidden = false
                loadingActivity.startAnimating()
            default: break
            }
        }
    }
    
    
    fileprivate func rotaArrow() {
        UIView.animate(withDuration: 0.2, animations: {
            self.arrowImageView.transform = self.arrowImageView.transform.rotated(by: CGFloat(M_PI))
        }) { (complete) in
        }
    }
    
    fileprivate func clearRotaArrow() {
        UIView.animate(withDuration: 0.2, animations: {
            self.arrowImageView.transform = CGAffineTransform.identity
        }) { (complete) in
        }
    }
}
