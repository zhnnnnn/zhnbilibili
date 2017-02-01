//
//  ZHNbilibiliWebViewController.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/5.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit
import WebKit


class ZHNbilibiliWebViewController: UIViewController {

    // 展示的url
    var urlString:String?
    
    // MARK: - 懒加载控件
    lazy var contentWebView: WKWebView = {
        let contentWebView = WKWebView()
        contentWebView.navigationDelegate = self
        return contentWebView
    }()
    
    lazy var navibar: customNaviBar = {
        let navibar = customNaviBar()
        let leftButton = UIButton()
        leftButton.setTitle("取消", for: .normal)
        leftButton.setTitle("取消", for: .highlighted)
        leftButton.addTarget(self, action: #selector(pravitePopViewController), for: .touchUpInside)
        navibar.leftItem = leftButton
        return navibar
    }()
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1. 初始化ui
        setupUI()
        // 2. 加载url
        loadRequest()
    }

}

extension ZHNbilibiliWebViewController {
    fileprivate func setupUI() {
        view.addSubview(contentWebView)
        view.addSubview(navibar)
        
        navibar.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.height.equalTo(64)
        }
        
        contentWebView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(view).offset(44)
        }
        
        navibar.titleLabel.text = urlString
    }
    
    fileprivate func loadRequest() {
        guard let urlString = urlString else {return}
        guard let url = URL(string: urlString) else {return}
        let request = URLRequest(url: url)
        contentWebView.load(request)
    }
    
}

//======================================================================
// MARK:- wkwebview delegate
//======================================================================
extension ZHNbilibiliWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        navibar.titleLabel.text = webView.title
    }
}

//======================================================================
// MARK:- target action
//======================================================================
extension ZHNbilibiliWebViewController {
    @objc fileprivate func pravitePopViewController() {
        _ = navigationController?.popViewController(animated: true)
    }
}

