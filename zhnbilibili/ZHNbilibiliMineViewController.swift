//
//  ZHNbilibiliMineViewController.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/23.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit

let kmineViewRuseKey = "kmineViewRuseKey"
let kmineViewHeadRuseKey = "kmineViewHeadRuseKey"
let kmineViewFootRuseKey = "kmineViewFootRuseKey"

class ZHNbilibiliMineViewController: UIViewController {

    let kpadding: CGFloat = 1
    let ktopMargin: CGFloat = 150
    // vm
    let mineVM = ZHNbilibiliMineViewModel()
    // MARK - 懒加载控件
    lazy var contentCollectionView: UICollectionView = { [weak self] in
        let flowLayout = UICollectionViewFlowLayout()
        let heightWidth = (kscreenWidth - 3*1)/4
        flowLayout.itemSize = CGSize(width: heightWidth, height: heightWidth)
        flowLayout.minimumLineSpacing = (self?.kpadding)!
        flowLayout.minimumInteritemSpacing = (self?.kpadding)!
        let contentCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        contentCollectionView.register(ZHNbilibiliMeCollectionCell.self, forCellWithReuseIdentifier: kmineViewRuseKey)
        contentCollectionView.register(ZHNbilibiliMeCollectionHeadView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kmineViewHeadRuseKey)
        contentCollectionView.register(ZHNbilibiliMeCollectionfootView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: kmineViewFootRuseKey)
        contentCollectionView.backgroundColor = UIColor.clear
        contentCollectionView.layer.cornerRadius = 10
        contentCollectionView.showsVerticalScrollIndicator = false
        contentCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0)
        contentCollectionView.delegate = self
        contentCollectionView.dataSource = self
        return contentCollectionView
    }()
    
    lazy var backView: UIView = {
        let backView = UIView()
        backView.backgroundColor = kHomeBackColor
        backView.layer.cornerRadius = 10
        return backView
    }()
    
    lazy var loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.setTitleColor(knavibarcolor, for: .normal)
        loginButton.backgroundColor = UIColor.white
        loginButton.setTitle("登录", for: .normal)
        loginButton.layer.cornerRadius = 5
        return loginButton
    }()
    
    lazy var registButton: UIButton = {
        let registButton = UIButton()
        registButton.setTitle("注册", for: .normal)
        registButton.backgroundColor = UIColor.ZHNcolor(red: 247, green: 117, blue: 156, alpha: 1)
        registButton.setTitleColor(UIColor.white, for: .normal)
        registButton.layer.cornerRadius = 5
        return registButton
    }()
    
    // MARK - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = knavibarcolor
        
        view.addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(view).offset(ktopMargin)
        }
        
        view.addSubview(contentCollectionView)
        contentCollectionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(view).offset(ktopMargin)
        }
        
        view.addSubview(registButton)
        registButton.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(70)
            make.right.equalTo(view.snp.centerX).offset(-15)
            make.size.equalTo(CGSize(width: 120, height: 40))
        }
        
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(registButton.snp.top)
            make.left.equalTo(view.snp.centerX).offset(15)
            make.size.equalTo(CGSize(width: 120, height: 40))
        }
    }

}

//======================================================================
// MARK:- delegate datasource
//======================================================================
extension ZHNbilibiliMineViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return mineVM.caluateSectionCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mineVM.caluateRowCount(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return mineVM.cell(collectionView: collectionView, indexPath: indexPath)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: kscreenWidth, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: kscreenWidth, height: 30)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return mineVM.headOrFoot(collectionView: collectionView, kind: kind, indexPath: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY <= 0 {
            let delta = ktopMargin - offsetY
            backView.snp.updateConstraints({ (make) in
                make.top.equalTo(view).offset(delta)
                make.left.right.bottom.equalTo(view)
            })
        }else {
            backView.snp.updateConstraints({ (make) in
                make.top.equalTo(view).offset(ktopMargin)
                make.left.right.bottom.equalTo(view)
            })
        }
    }
}



//======================================================================
// MARK:- collectionView cell
//======================================================================
class ZHNbilibiliMeCollectionCell: UICollectionViewCell {
    
    var name: String = "" {
        didSet {
            nameLabel.text = name
        }
    }
    var iconImageName: String = "" {
        didSet {
            iconImageView.image = UIImage(named: iconImageName)
        }
    }
    
    // MARK - 懒加载控件
    fileprivate lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.contentMode = .scaleAspectFill
        return iconImageView
    }()
    
    fileprivate lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        return nameLabel
    }()
    
    // MARK - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(iconImageView)
        self.addSubview(nameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-10)
            make.size.equalTo(CGSize(width: 35, height: 35))
        }
        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(iconImageView.snp.bottom).offset(5)
        }
    }
}

//======================================================================
// MARK:- headview
//======================================================================
class ZHNbilibiliMeCollectionHeadView: UICollectionReusableView {
    
    // 标题
    var title: String = "" {
        didSet {
            nameLabel.text = title
        }
    }
    
    var isTopHead = false {
        didSet {
            if isTopHead {
                backView.zhn_cornerRadius = 10
            }else {
                backView.zhn_cornerRadius = 0
            }
        }
    }
    
    // MARK - 懒加载控件
    fileprivate lazy var backView: UIView = {
        let backView = UIView()
        backView.backgroundColor = UIColor.white
        return backView
    }()
    
    fileprivate lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        return nameLabel
    }()
    
    fileprivate lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = kHomeBackColor
        return lineView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(backView)
        self.addSubview(nameLabel)
        self.addSubview(lineView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.centerY.equalTo(self)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(1)
        }
    }
}

//======================================================================
// MARK:- footview
//======================================================================
class ZHNbilibiliMeCollectionfootView: UICollectionReusableView {
}


