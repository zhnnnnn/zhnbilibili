//
//  slideMenu.swift
//  zhnbilibili
//
//  Created by zhn on 16/11/17.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

@objc protocol slideMenuDelegate {
    @objc optional func selectedIndex(index:Int)
}

class slideMenu: UIView {
    
    
    struct slideMenuTitleColor {
        var red:CGFloat = 0
        var green:CGFloat = 0
        var blue:CGFloat = 0
    }
    
    // 当前显示的index
    fileprivate var showingIndex = 0
    
    //  容器的scrollview
    fileprivate var contentScrollView:UIScrollView?

    // label 数组
    fileprivate var labelArray = [UILabel]()
    
    // 计算frame需要的一些变量
    fileprivate var titleFrameArray = [CGRect]()
    fileprivate var titleWidthArray = [CGFloat]()
    fileprivate var titleMaxX:CGFloat = 0
    fileprivate var titleY:CGFloat = 0
    
    fileprivate var lineFeedIndex:Int = 0 // 记录需要换行的位置
    
    // 一些常量
    fileprivate var oldMenuScrollviewContentX:CGFloat = 0
    
        // 滑块的常量
    fileprivate var ksliderVPadding:CGFloat = 3
    fileprivate var ksliderHeight:CGFloat = 2
        // 标题的常量
    fileprivate var Kpadding:CGFloat = 0
    fileprivate var kVerticalPadding:CGFloat = 15
    fileprivate var kfont:CGFloat = 15
    fileprivate var KnormalColor = slideMenuTitleColor()
    fileprivate var KhightLightColor = slideMenuTitleColor()
    fileprivate var ksildeColor = UIColor.white
    fileprivate var konlyHorizon = false // 是否换行显示
    
    // 滑动变化标题颜色需要的常量
    fileprivate var kredDelta:CGFloat = 0
    fileprivate var kgreenDelta:CGFloat = 0
    fileprivate var kblueDelta:CGFloat = 0
    
    // padding是否自动计算内容是否铺满（只在竖直显示的情况下有效）
    // 计算的策略是标题相加的宽度没有超过frame.width的情况下会均分计算出kpadding,如果不能的话还是用padding去计算，所以padding还是要赋值
    fileprivate var keaqulPadding = true
    
    // 代理
    weak var delegate:slideMenuDelegate?
    // menu的标题数组
    var titleArray:[String]?
    
    // MARK: - 懒加载
    lazy var slider: UIView = {
        let slider = UIView()
        return slider
    }()
    
    lazy var menuBackScrollView: UIScrollView = {
        let backScrollView = UIScrollView()
        backScrollView.bounces = false
        return backScrollView
    }()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    deinit {
        // 移除监听
        contentScrollView?.removeObserver(self, forKeyPath: "contentOffset")
    }
}

//======================================================================
// MARK:- 私有方法
//======================================================================
extension slideMenu {
    
    fileprivate func initSubViews() {
        
        var superView:UIView?
        if konlyHorizon {
            self.addSubview(menuBackScrollView)
            menuBackScrollView.frame = bounds
            superView = menuBackScrollView
        }else{
            superView = self
        }
        
        // 1.添加label控件
        if let tempArray = titleArray {
        
            let delta = (contentScrollView?.contentSize.width)!/CGFloat(tempArray.count)
            for i in 0..<(tempArray.count){
                let label = UILabel()
                label.tag = i
                label.isUserInteractionEnabled = true
                label.textAlignment = NSTextAlignment.center
                let tapGes = UITapGestureRecognizer(tap: {[weak self] in
                    self?.delegate?.selectedIndex!(index: label.tag)
                    let visableRect = CGRect(x: delta*CGFloat(i), y: 0, width: (self?.contentScrollView?.zhnWidth)!, height: (self?.contentScrollView?.zhnheight)!)
                    self?.contentScrollView?.scrollRectToVisible(visableRect, animated: true)
                })
                label.addGestureRecognizer(tapGes)
                label.text = tempArray[i]
                label.font = UIFont.systemFont(ofSize: kfont)
                labelArray.append(label)
                superView?.addSubview(label)
                
                // 标题颜色的设置
                if i == 0{
                    label.textColor = UIColor.ZHNcolor(red: KhightLightColor.red, green: KhightLightColor.green, blue: KhightLightColor.blue, alpha: 1.0)
                }else{
                    label.textColor = UIColor.ZHNcolor(red: KnormalColor.red, green: KnormalColor.green, blue: KnormalColor.blue, alpha: 1.0)
                }
            }
        }
        
        // 2.计算布局
        let tempStr = "吊"
        let fitHeight = tempStr.heightWithConstrainedWidth(width: 100, font: UIFont.systemFont(ofSize: kfont))
        
        menuBackScrollView.contentSize = menuScrollViewContentSize(height: fitHeight)

        guard let titleArray = titleArray else {return}
        for i in 0..<(titleArray.count){
            let str = titleArray[i]
            
            if konlyHorizon { // 水平显示（超出边界的情况滑动来显示）
                let fitwidth = str.widthWithConstrainedHeight(height: fitHeight, font: UIFont.systemFont(ofSize: kfont))
                var x = Kpadding + titleMaxX
                if titleMaxX == 0{
                    x = 0
                }
                let currentRect = CGRect(x: x, y: titleY, width: fitwidth, height: fitHeight)
                let maxX = currentRect.maxX
                // 缓存frame 和 宽度（后面用来计算frame）
                titleFrameArray.append(currentRect)
                titleWidthArray.append(fitwidth)
                titleMaxX = maxX
            }else{// 竖直显示 (超出边界的情况换行来显示)
                
                // 如果需要自适应的话就重新计算一下padding
                if keaqulPadding {
                    Kpadding = countPadding(height: fitHeight)
                }
                
                // 先生成一个frame 主要是用来计算
                let fitwidth = str.widthWithConstrainedHeight(height: fitHeight, font: UIFont.systemFont(ofSize: kfont))
                var x:CGFloat = 0
                if titleMaxX != 0 {
                    x = titleMaxX + Kpadding
                }
                
                let currentRect = CGRect(x: x, y: titleY, width: fitwidth, height: fitHeight)
                let maxX = currentRect.maxX
                
                if maxX > self.zhnWidth{ // 需要换行的情况
                    titleMaxX = 0
                    titleY += fitHeight + kVerticalPadding
                    var addWidth:CGFloat = 0
                    for width in titleWidthArray {
                        addWidth += width
                    }
                    let newPadding = (self.zhnWidth - addWidth)/(CGFloat(i) - 1)
                    let firstRect = titleFrameArray[lineFeedIndex]
                    var tempMaxX:CGFloat = firstRect.maxX
                    for j in lineFeedIndex+1..<i { // 之前的控件重新设置位置
                        let rect = titleFrameArray[j]
                        let x = tempMaxX + newPadding
                        let newRect = CGRect(x: x, y: rect.origin.y, width: rect.size.width, height: rect.size.height)
                        tempMaxX = newRect.maxX
                        titleFrameArray.replaceSubrange(Range(j...j), with: [newRect])
                    }
                    
                    // 记录下需要换行的位置
                    lineFeedIndex = i
                    
                    // 重新生成一个计算后的位置
                    if titleMaxX == 0 {
                        x = 0
                    }else{
                        x = titleMaxX + Kpadding
                    }
                    
                    let fitRect = CGRect(x: x, y: titleY, width: fitwidth, height: fitHeight)
                    titleFrameArray.append(fitRect)
                    titleWidthArray.append(fitwidth)
                    titleMaxX = fitRect.maxX
                    
                }else{ // 不需要换行的情况下
                    
                    // 缓存frame 和 宽度（后面用来计算frame）
                    titleFrameArray.append(currentRect)
                    titleWidthArray.append(fitwidth)
                    titleMaxX = maxX
                }
                
            }
        }
        
        // 3.label位置赋值
        for item in labelArray.enumerated(){
            item.element.frame = titleFrameArray[item.offset]
        }
        
        // 4.初始化滑块的位置
        superView?.addSubview(slider)
        let firstRect = titleFrameArray.first!
        slider.frame = CGRect(x: firstRect.origin.x, y: firstRect.maxY + ksliderVPadding, width: firstRect.width, height: ksliderHeight)
    }
    
    // 计算自适应padding的情况下的 padding
    fileprivate func countPadding(height:CGFloat) -> CGFloat{
        var addedWidth:CGFloat = 0
        for i in 0..<(titleArray!.count){
            let str = titleArray![i]
            let width = str.widthWithConstrainedHeight(height: height, font: UIFont.systemFont(ofSize: kfont))
            addedWidth += width
            // 如果是需要换行的情况下返回一个 设置的padding值
            if addedWidth > self.zhnWidth {
                return Kpadding
            }
        }
        
        let autoPadding = (self.zhnWidth - addedWidth)/(CGFloat(titleArray!.count) - 1)
        return autoPadding
    }
    
    // 计算不换行情况下menu scrollview的contentsize
    fileprivate func menuScrollViewContentSize(height:CGFloat) -> CGSize {
        var addedWidth:CGFloat = 0
        for i in 0..<(titleArray!.count){
            let str = titleArray![i]
            let width = str.widthWithConstrainedHeight(height: height, font: UIFont.systemFont(ofSize: kfont))
            addedWidth += width
        }
        addedWidth += CGFloat(((titleArray?.count)!-1)) * Kpadding
        return CGSize(width: addedWidth, height: self.zhnheight)
    }
    
}


//======================================================================
// MARK:- 公共方法
//======================================================================
extension slideMenu{
    
    /// 全能的初始化方法
    ///
    /// - parameter frame:           menu的frame
    /// - parameter titles:          menu的标题
    /// - parameter padding:         menu标题的间距(默认是15)
    /// - parameter normalColr:      menu标题的普通颜色
    /// - parameter hightLightColor: menu标题的选中颜色
    /// - parameter font:            menu标题的字体大小
    /// - parameter sliderColor:     menu的滑块的颜色
    /// - parameter onlyHorizon:     menu是否需要换行显示（true代表只水平显示）
    /// - parameter scrollView:      menu需要对应的scrollview
    /// - parameter autoPadding:     menu标题的padding是否根据frame来自动计算(需要设置一个padding值，如果有换行的情况就用这个padding去显示去计算)
    ///
    /// - returns: 滑动的menu
    convenience init(frame:CGRect,titles:[String],padding:CGFloat,normalColr:slideMenuTitleColor,hightLightColor:slideMenuTitleColor,font:CGFloat,sliderColor:UIColor,onlyHorizon:Bool = false,scrollView:UIScrollView,autoPadding:Bool) {
        self.init()
        self.frame = frame
        titleArray = titles
        kfont = font
        Kpadding = padding
        KnormalColor = normalColr
        ksildeColor = sliderColor
        konlyHorizon = onlyHorizon
        keaqulPadding = autoPadding
        KhightLightColor = hightLightColor
        slider.backgroundColor = sliderColor
        contentScrollView = scrollView
        scrollView.bounces = false
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
        
        // 颜色常量设置
        kredDelta = KhightLightColor.red - KnormalColor.red
        kgreenDelta = KhightLightColor.green - KnormalColor.green
        kblueDelta = KhightLightColor.blue - KnormalColor.blue
        
        // 控初始化了
        initSubViews()
    }

}

//======================================================================
// MARK:- scrollview的KVO
//======================================================================
extension slideMenu{
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "contentOffset" else {return}
        
        let offsetX = (contentScrollView?.contentOffset.x)!
        let scrollWidth = (contentScrollView?.contentSize.width)!
        // 每一页对应的宽度
        let pageDelta = scrollWidth/CGFloat((titleArray?.count)!)
        // 显示的位置 = 页数 + 百分比
        let floatDelta = offsetX / pageDelta
            // 页数
        let index = Int(floatDelta)
            // 百分比
        let percent = floatDelta - CGFloat(index)
        
        // 当前显示的index(percent = 0 的情况下设置这个index便于计算)
        if percent == 0 {
            showingIndex = index
        }
        
        // 超出数组的边界处理
        guard index < (titleArray?.count)! - 1  else {return}
        
        let leftRect = titleFrameArray[index]
        let rightRect = titleFrameArray[index+1]
        
        let leftShowLabel = labelArray[index]
        let rigtShowLabel = labelArray[index+1]
        
        // 标题的颜色变化
        if showingIndex == index {// 往右滑动
            leftShowLabel.textColor = UIColor.ZHNcolor(red: KhightLightColor.red - percent * kredDelta, green:  KhightLightColor.green - percent * kgreenDelta, blue:  KhightLightColor.blue - percent * kblueDelta, alpha: 1.0)
            rigtShowLabel.textColor = UIColor.ZHNcolor(red: KnormalColor.red + percent * kredDelta, green:  KnormalColor.green + percent * kgreenDelta, blue:  KnormalColor.blue + percent * kblueDelta, alpha: 1.0)
        }else{// 往左滑
            rigtShowLabel.textColor = UIColor.ZHNcolor(red: KnormalColor.red + percent * kredDelta, green:  KnormalColor.green + percent * kgreenDelta, blue:  KnormalColor.blue + percent * kblueDelta, alpha: 1.0)
            leftShowLabel.textColor = UIColor.ZHNcolor(red: KhightLightColor.red - percent * kredDelta, green:  KhightLightColor.green - percent * kgreenDelta, blue:  KhightLightColor.blue - percent * kblueDelta, alpha: 1.0)
        }
        
        // 滑块位置的变化
        if leftRect.origin.y == rightRect.origin.y {// 不用换行显示的情况下
            
            // 位置的变化
            let x = (rightRect.origin.x - leftRect.origin.x) * percent + leftRect.origin.x
            let y = leftRect.maxY + ksliderVPadding
            let width = (rightRect.width - leftRect.width) * percent + leftRect.width
            let slidingRect = CGRect(x: x, y: y, width: width, height: ksliderHeight)
            slider.frame = slidingRect
            
            // menu水平显示的时候需要滑动到最中间
            if konlyHorizon{
                // title 滑动到中间
                var offsetX:CGFloat = 0
                var pointX:CGFloat = 0
                if showingIndex == index {// 右滑
                    offsetX =  rigtShowLabel.frame.midX - self.zhnWidth/2
                    if percent == 0 {
                        oldMenuScrollviewContentX = leftShowLabel.frame.midX - self.zhnWidth/2
                    }
                    pointX = (offsetX - oldMenuScrollviewContentX)*percent + oldMenuScrollviewContentX
                }else{// 左滑
                    offsetX = leftShowLabel.frame.midX - self.zhnWidth/2
                    if percent == 0 {
                        oldMenuScrollviewContentX = rigtShowLabel.frame.midX - self.zhnWidth/2
                    }
                    pointX = oldMenuScrollviewContentX - (oldMenuScrollviewContentX - offsetX)*(1-percent)
                }
                
                // 超过了最小值
                if pointX < 0{
                    pointX = 0
                }
                // 超过了最大值
                if pointX > (menuBackScrollView.contentSize.width - menuBackScrollView.zhnWidth){
                    pointX = (menuBackScrollView.contentSize.width - menuBackScrollView.zhnWidth)
                }
                // 赋值
                menuBackScrollView.setContentOffset(CGPoint(x: pointX, y: 0), animated: false)
             }
            
          }else{// 需要换行显示的情况下
            
             // bilibili 的换行策略是在换行的临界处滑了就先让滑块先换行
             var tempRect = leftRect
             if showingIndex == index {
                 tempRect = rightRect
             }else{
                 tempRect = leftRect
             }
            
            if index == (titleArray?.count)! - 2 {
                tempRect = rightRect
            }
            
             // 停止滑动的时候没有达到要换行的情况(回到未换行的状态)
             if showingIndex == index && percent == 0 {
                 tempRect = leftRect
             }

             // 赋值新的位置
             let x = tempRect.origin.x
             let y = tempRect.maxY + ksliderVPadding
             let width = tempRect.width
             let slidingRect = CGRect(x: x, y: y, width: width, height: ksliderHeight)
             slider.frame = slidingRect
           }
     }
}



