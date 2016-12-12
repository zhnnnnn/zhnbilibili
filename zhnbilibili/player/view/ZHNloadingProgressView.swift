//
//  ZHNloadingProgressView.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/11.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class ZHNloadingProgressView: UIView {

    var progress: Int = 0{
        didSet{
            progressLabel.text = "\(progress)%"
        }
    }
    
    // MARK: - 懒加载控件
    fileprivate lazy var rotaingImageView: UIImageView = {
        let rotaingImageView = UIImageView()
        rotaingImageView.image = #imageLiteral(resourceName: "play_loading")
        return rotaingImageView
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "正在缓冲:"
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = UIColor.white
        return titleLabel
    }()
    
    fileprivate lazy var progressLabel: UILabel = {
        let progressLabel = UILabel()
        progressLabel.text = "0%"
        progressLabel.textColor = UIColor.white
        progressLabel.font = UIFont.systemFont(ofSize: 12)
        return progressLabel
    }()

    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(rotaingImageView)
        self.addSubview(titleLabel)
        self.addSubview(progressLabel)
        self.backgroundColor = UIColor.ZHNcolor(red: 0, green: 0, blue: 0, alpha: 0.7)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rotaingImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(10)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(rotaingImageView.snp.right).offset(10)
        }
        progressLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(titleLabel.snp.right).offset(5)
        }
    }
}

extension ZHNloadingProgressView {
    func startRotaing() {
        let rotaAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotaAnimation.toValue = M_PI * 8
        rotaAnimation.repeatCount = MAXFLOAT
        rotaAnimation.duration = 3
        rotaingImageView.layer.add(rotaAnimation, forKey: "rotaanimation")
    }
    
    func endRotaing() {
        rotaingImageView.layer.removeAllAnimations()
    }
}

