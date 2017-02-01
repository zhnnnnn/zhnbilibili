//
//  ZHNplayerPageListTableViewCell.swift
//  zhnbilibili
//
//  Created by 张辉男 on 16/12/30.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

fileprivate let kpageCellKey = "kpageCellKey"

class ZHNplayerPageListTableViewCell: ZHNcustomLineTableViewCell {
    
    /// 点击的事件
    var pageSelectedAction: ((_ cid: Int,_ index: Int)->Void)?
    
    /// page的数据数组
    var pagesArray: [pageDetailModel]? {
        didSet{
            if let count = pagesArray?.count {
                numberLabel.text = "(\(count))"
            }
            contentCollectionView.reloadData()
        }
    }
    
    /// 当前选择的cell
    var selectedIndex: Int = 0
    
    // MARK - 懒加载的控件
    fileprivate lazy var noticeLabel: UILabel = {
        let noticeLabel = UILabel()
        noticeLabel.text = "分集"
        noticeLabel.font = UIFont.systemFont(ofSize: 15)
        return noticeLabel
    }()
    lazy var numberLabel: UILabel = {
        let numberLabel = UILabel()
        numberLabel.textColor = UIColor.lightGray
        numberLabel.font = UIFont.systemFont(ofSize: 14)
        return numberLabel
    }()
    lazy var contentCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 20
        flowLayout.itemSize = CGSize(width: kscreenWidth/3, height: 60)
        flowLayout.scrollDirection = .horizontal
        let contentCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: flowLayout)
        contentCollectionView.delegate = self
        contentCollectionView.dataSource = self
        contentCollectionView.register(pageCell.self, forCellWithReuseIdentifier: kpageCellKey)
        contentCollectionView.backgroundColor = kHomeBackColor
        contentCollectionView.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        return contentCollectionView
    }()
    
    // MARK - life cycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(noticeLabel)
        self.addSubview(numberLabel)
        self.addSubview(contentCollectionView)
        self.backgroundColor = kHomeBackColor
        self.selectionStyle = .none
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        noticeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.top.equalTo(self).offset(5)
        }
        numberLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(noticeLabel)
            make.left.equalTo(noticeLabel.snp.right).offset(5)
        }
        contentCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(noticeLabel.snp.bottom).offset(10)
            make.left.right.equalTo(self)
            make.bottom.equalTo(self).offset(-5)
        }
    }
    
    class func instanceCell(tableView: UITableView) -> ZHNplayerPageListTableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "pagelist")
        if cell == nil {
            cell = ZHNplayerPageListTableViewCell(style: .default, reuseIdentifier: "pagelist")
        }
        return cell as! ZHNplayerPageListTableViewCell
    }
}

//======================================================================
// MARK:- 数据源
//======================================================================
extension ZHNplayerPageListTableViewCell: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = pagesArray?.count  else {return 0}
        return count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: kpageCellKey, for: indexPath) as! pageCell
        let page = pagesArray?[indexPath.row]
        cell.contentLabel.text = page?.part
        if indexPath.row == selectedIndex {
            cell.selectedCell()
        }else {
            cell.normalCell()
        }
        return cell
    }
}

//======================================================================
// MARK:- 代理方法
//======================================================================
extension ZHNplayerPageListTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        collectionView.reloadData()
        let model = pagesArray?[indexPath.row]
        guard let cid = model?.cid else {return}
        pageSelectedAction!(cid,indexPath.row+1)
    }
}

//======================================================================
// MARK:- 自定义cell
//======================================================================
class pageCell: UICollectionViewCell {
   
    lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.font = UIFont.systemFont(ofSize: 13)
        contentLabel.numberOfLines = 0
        return contentLabel
    }()
    
    // MARK - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(contentLabel)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor.white
        self.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        }
    }
    
    // MARK - 公共的方法
    func normalCell() {
        contentLabel.textColor = UIColor.black
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func selectedCell() {
        contentLabel.textColor = knavibarcolor
        self.layer.borderColor = knavibarcolor.cgColor
    }
}

