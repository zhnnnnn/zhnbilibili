//
//  ZHNplayerUrlLoadingBackView.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/8.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

@objc protocol ZHNplayerUrlLoadingbackViewDelegate {
    @objc optional func popViewControllerAction()
    @objc optional func fullScreenAction()
    @objc optional func copyMessageAction()
}

class ZHNplayerUrlLoadingBackView: UIView {
    
    /// 代理
    weak var delegate: ZHNplayerUrlLoadingbackViewDelegate?
    
    // MARK: - 懒加载控件
    lazy var noticeTableView: playerNoticeTableView = {
        let noticeTableView = playerNoticeTableView()
        return noticeTableView
    }()
    
    lazy var urlLoadingBackButton: UIButton = {
        let urlLoadingBackButton = UIButton()
        urlLoadingBackButton.setImage(UIImage(named: "hd_icnav_back_dark"), for: .normal)
        urlLoadingBackButton.setImage(UIImage(named: "hd_icnav_back_dark"), for: .highlighted)
        urlLoadingBackButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        return urlLoadingBackButton
    }()
    
    lazy var urlLoadingFullScreenButon: UIButton = {
        let urlLoadingFullScreenButon = UIButton()
        urlLoadingFullScreenButon.setImage(UIImage(named: "player_fullScreen_iphone-1"), for: .normal)
        urlLoadingFullScreenButon.setImage(UIImage(named: "player_fullScreen_iphone-1"), for: .highlighted)
        urlLoadingFullScreenButon.addTarget(self, action: #selector(fullScreenAction), for: .touchUpInside)
        return urlLoadingFullScreenButon
    }()
    
    lazy var urlLoadingCopyMessageButton: UIButton = {
        let urlLoadingCopyMessageButton = UIButton()
        urlLoadingCopyMessageButton.setTitle("复制信息", for: .normal)
        urlLoadingCopyMessageButton.setTitle("复制信息", for: .highlighted)
        urlLoadingCopyMessageButton.setTitleColor(UIColor.black, for: .normal)
        urlLoadingCopyMessageButton.setTitleColor(UIColor.black, for: .highlighted)
        urlLoadingCopyMessageButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        urlLoadingCopyMessageButton.addTarget(self, action: #selector(copyAction), for: .touchUpInside)
        return urlLoadingCopyMessageButton
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(noticeTableView)
        self.addSubview(urlLoadingBackButton)
        self.addSubview(urlLoadingFullScreenButon)
        self.addSubview(urlLoadingCopyMessageButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let gifImageView = UIImageView.createPlayLoadingGif()
        self.addSubview(gifImageView)
        gifImageView.startAnimating()
        gifImageView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        noticeTableView.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.bottom.equalTo(self)
            make.width.equalTo(200)
            make.height.equalTo(60)
        }
      
        urlLoadingBackButton.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.top.equalTo(self).offset(25)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        
        urlLoadingFullScreenButon.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(self).offset(-10)
            make.size.equalTo(CGSize(width: 25, height: 25))
        }
        
        urlLoadingCopyMessageButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(urlLoadingBackButton)
            make.right.equalTo(self).offset(-10)
        }
    }
}

//======================================================================
// MARK:- target action
//======================================================================
extension ZHNplayerUrlLoadingBackView {
    
    @objc fileprivate func backAction() {
        guard let delegate = delegate else {return}
        guard let method = delegate.popViewControllerAction else {return}
        method()
    }
    
    @objc fileprivate func fullScreenAction() {
        guard let delegate = delegate else {return}
        guard let method = delegate.fullScreenAction else {return}
        method()
    }
    
    @objc fileprivate func copyAction() {
        guard let delegate = delegate else {return}
        guard let method = delegate.copyMessageAction else {return}
        method()
    }
}

//======================================================================
// MARK:- 展示信息的view
//======================================================================

class playerNoticeTableView: UIView,UITableViewDataSource,UITableViewDelegate{
    
    var titleArray = ["ABC12345","获取视频信息...","成功...","正在初始化设置...","正在初始化弹幕...","正在初始化播放器..."]
    
    fileprivate lazy var contentTableView: UITableView = {
        let contentTableView = UITableView()
        contentTableView.dataSource = self
        contentTableView.delegate = self
        contentTableView.separatorStyle = .none
        contentTableView.backgroundColor = kHomeBackColor
        contentTableView.isScrollEnabled = false
        contentTableView.isUserInteractionEnabled = false
        return contentTableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(contentTableView)
        self.backgroundColor = UIColor.blue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    // MARK: - tableview datasource delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = titleArray[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
        cell.textLabel?.textColor = UIColor.lightGray
        cell.backgroundColor = kHomeBackColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20
    }
    
    // MARK: - 公共方法
    func scrollToBottom() {
        let indexPath = IndexPath(row: titleArray.count - 1, section: 0)
        contentTableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}

