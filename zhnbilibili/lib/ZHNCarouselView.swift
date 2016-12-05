//
//  ZHNCarouselView.swift
//  zhnbilibili
//
//  Created by zhn on 16/11/23.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

@objc protocol ZHNcarouselViewDelegate {
    @objc optional func ZHNcarouselViewSelectedIndex(index: Int)
}

class ZHNCarouselView: UIView {
    
    // MARK: - 代理
    weak var delegate: ZHNcarouselViewDelegate?
    
    // MARK: - 外部需要赋值的属性
    // --- 必填 二选一 ---
    
    /// 网络图片数组
    var intnetImageArray: [String]?{
        didSet{
            praviteReload(imageAry: intnetImageArray)
        }
    }
    /// 本地图片数组
    var localImageArray: [String]?{
        didSet{
            praviteReload(imageAry: localImageArray)
        }
    }
    
    // --- 选填 ---
    
    /// 图片的placeholder
    var placeHoldeImage: UIImage?
    
    /// 图片轮播的时间间隔 (默认值是5)
    var timeIvatel:Int = 5 {
        didSet{
           addTimer()
        }
    }
    
    /// 选中的action
    var selectedAction:((_ index: Int)->())?
    
    // MARK: - 内部属性
    fileprivate var contentCollectonView: UICollectionView?
    fileprivate let kmaxSectionCount = 100
    fileprivate let kreuseKey = "ZHNCarouselViewCell"
    fileprivate var showingIndex = 0
    fileprivate var repeatTimer: Timer?
    fileprivate var arrayCount = 0
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        return pageControl
    }()
    
    // MARK: - life cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 1. 障眼法
        if arrayCount > 0{
            contentCollectonView?.scrollToItem(at: IndexPath(row: 0, section: kmaxSectionCount/2), at: .left, animated: false)
        }
        
        // 2. pagecontrol初始化
        // <1 小于0隐藏
        guard arrayCount > 1 else {
            pageControl.isHidden = true
            return
        }
        // <2 初始化
        pageControl.numberOfPages = arrayCount
        let pageSize = pageControl.size(forNumberOfPages: arrayCount)
        pageControl.frame = CGRect(x: frame.size.width - pageSize.width - 10, y: frame.size.height - pageSize.height + 10, width: pageSize.width, height: pageSize.height)
        pageControl.currentPageIndicatorTintColor = knavibarcolor
        
        
        // 3.添加
        self.addSubview(contentCollectonView!)
        self.addSubview(pageControl)
        
        // 添加timer
        repeatTimer?.invalidate()
        repeatTimer = nil
        if repeatTimer == nil{
            addTimer()
        }
    }
}

// MARK: - 公开方法
extension ZHNCarouselView {
    
    /// 初始化方法
    ///
    /// - parameter viewframe:              frame
    /// - parameter localImageStringArray:  本地图片数组 选填
    /// - parameter intentImageStringArray: 网络图片数组 选填
    /// - parameter selectAction:           点击的action
    ///
    /// - returns: 轮播
    convenience init(viewframe:CGRect,localImageStringArray:[String]? = nil,intentImageStringArray:[String]? = nil,selectAction:((_ index:Int)->())? = nil) {
        self.init()
        
        // 1. 赋值
        selectedAction = selectAction
        localImageArray = localImageStringArray
        intnetImageArray = intentImageStringArray
        frame = viewframe
        self.backgroundColor = UIColor.white
        // 2. ui初始化
        setupui()
    }
}

// MARK: - 私有方法
extension ZHNCarouselView {
    
    func setupui() {
        
        // 1.collectionview初始化
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = frame.size
        contentCollectonView?.collectionViewLayout = flowLayout
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        contentCollectonView = UICollectionView(frame: bounds, collectionViewLayout: flowLayout)
        contentCollectonView?.delegate = self
        contentCollectonView?.dataSource = self
        contentCollectonView?.register(carouselViewCell.self, forCellWithReuseIdentifier: kreuseKey)
        contentCollectonView?.isPagingEnabled = true
        contentCollectonView?.showsVerticalScrollIndicator = false
        contentCollectonView?.showsHorizontalScrollIndicator = false
        self.addSubview(contentCollectonView!)
    }
    
    @objc fileprivate func nextPage() {
        
        // 1. 先障眼法
        let resetitem = IndexPath(item: showingIndex, section: self.kmaxSectionCount/2)
        self.contentCollectonView?.scrollToItem(at: resetitem, at: .left, animated: false)
        
        // 2. 滑动到下一张
        var nextSection = kmaxSectionCount/2
        showingIndex += 1
        
        if showingIndex == self.arrayCount {
            showingIndex = 0
            nextSection += 1
        }
        
        // 当前pagecontrol显示的位置
        pageControl.currentPage = showingIndex

        let nextIndex = IndexPath(item: showingIndex, section: nextSection)
        self.contentCollectonView?.scrollToItem(at: nextIndex, at: .left, animated: true)
    }
    
    fileprivate func removeTimer() {
        repeatTimer?.invalidate()
        repeatTimer = nil
    }
    
    fileprivate func addTimer() {
        
        if (repeatTimer != nil) {return}
        
        // 1. 数据少于2不添加timer
        if arrayCount < 2 {
            return
        }
        
        // 2. 添加tiemr
        repeatTimer = Timer.scheduledTimer(timeInterval: TimeInterval(timeIvatel), target: self, selector: #selector(nextPage), userInfo: nil, repeats: true)
        RunLoop.main.add(repeatTimer!, forMode: .defaultRunLoopMode)
    }
    
    func praviteReload(imageAry: [String]?) {
        guard let count = imageAry?.count else {return}
        arrayCount = count
        if count == 1 {
            self.contentCollectonView?.isScrollEnabled = false
            removeTimer()
            pageControl.isHidden = true
        }else{
            self.contentCollectonView?.isScrollEnabled = true
            pageControl.isHidden = false
            addTimer()
        }
        DispatchQueue.main.async {
            self.contentCollectonView?.reloadData()
        }
    }
}

// MARK: - collectionview 代理方法
extension ZHNCarouselView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let action = selectedAction {
            action(indexPath.row)
        }
        if let delegate = delegate {
            if let method = delegate.ZHNcarouselViewSelectedIndex {
                method(indexPath.row)
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addTimer()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
        let page = Int(scrollView.contentOffset.x/scrollView.frame.size.width)%arrayCount
        self.pageControl.currentPage = page;
    }
}

// MARK: - collectionview 数据源方法
extension ZHNCarouselView: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return kmaxSectionCount
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // 1. 本地数组有值
        if let localImageArray = localImageArray {
            return localImageArray.count
        }
        
        // 2. 网络数组有值
        if let intnetImageArray = intnetImageArray {
            return intnetImageArray.count
        }
        
        // 3. 没有赋值
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 1. 获取cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kreuseKey, for: indexPath) as! carouselViewCell

        // 2. 本地数组有值,赋值本地图片数据
        if let localImageArray = localImageArray {
            // <1. 拿到图片string
            let imageString = localImageArray[indexPath.row]
            
            // <2. 判读string对应的图片存不存在
            if let image = UIImage(named: imageString) { // 存在
                cell.contentImageView.image = image
            }else{ // 不存在
                cell.contentImageView.image = placeHoldeImage
            }
        }
        
        // 3. 网络数组有值,赋值网络图片数据
        if let intnetImageArray = intnetImageArray {
            
            // <1. 拿到图片url
            let imageURLstring = intnetImageArray[indexPath.row]
            let imageURL = URL(string: imageURLstring)
    
            // <2. 赋值图片
            cell.contentImageView.kf.setImage(with: imageURL, placeholder: placeHoldeImage, options: nil, progressBlock: nil, completionHandler: nil)
        }
        return cell
    }
}


// MARK: - collectionViewcell （自定义就自定义这个cell咯）
fileprivate class carouselViewCell: UICollectionViewCell  {
    
    lazy var contentImageView: UIImageView = {
        let contentImageView = UIImageView()
        contentImageView.clipsToBounds = true
        contentImageView.contentMode = UIViewContentMode.scaleAspectFill
        contentImageView.backgroundColor = UIColor.clear
        return contentImageView
    }()
    
    lazy var placeHolder: UIImageView = {
        let placeHolder = UIImageView()
        placeHolder.image = UIImage(named: "default_img")
        placeHolder.contentMode = .center
        return placeHolder
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(placeHolder)
        self.addSubview(contentImageView)
        self.backgroundColor = UIColor.white
        placeHolder.backgroundColor = UIColor.white
    }
    
    fileprivate override func layoutSubviews() {
        super.layoutSubviews()
        contentImageView.frame = self.bounds
        placeHolder.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



