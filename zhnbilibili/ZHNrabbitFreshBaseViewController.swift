//
//  ZHNrabbitFreshBaseViewController.swift
//  zhnbilibili
//
//  Created by zhn on 16/11/16.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class ZHNrabbitFreshBaseViewController: UIViewController {
    
    // MARK: - 常量变量
    fileprivate var dragging: Bool = false
    fileprivate var isinherit: Bool = true
    fileprivate var freshing: Bool = false // 是否在刷新状态
    fileprivate let knavibarHeight: CGFloat = 50
    fileprivate let krabbitEarWidth: CGFloat = 35
    fileprivate let krabbitEarHeight: CGFloat = 6
    fileprivate let kfreshMinHeight: CGFloat = 50// 兔耳朵开始显示的高度
    fileprivate let KfreshMaxHeight: CGFloat = 100// 兔耳朵转动到最大值90度的高度
    fileprivate let knoticelabelCenterY: CGFloat = 40
    fileprivate let kscrollViewCornerRadius: CGFloat = 10
    fileprivate let screenWidth = UIScreen.main.bounds.width
    
    fileprivate var animateTimer:Timer?
    var contentScrollView:UIScrollView?
    
    // MARK: - 懒加载    
    fileprivate lazy var containerView: UIView = {
        let tempView = UIView()
        tempView.backgroundColor = UIColor.clear
        return tempView
    }()
    
    fileprivate lazy var rabbitEarMaskView: UIView = {[unowned self] in
        let maskView = UIView()
        maskView.backgroundColor = UIColor.clear
        maskView.layer.cornerRadius = self.kscrollViewCornerRadius
        return maskView
        }()
    
    lazy var rabbitEarMaskTopView: UIView = {[unowned self] in
        let maskTopView = UIView()
        maskTopView.clipsToBounds = true
        maskTopView.backgroundColor = kHomeBackColor
        maskTopView.layer.cornerRadius = self.kscrollViewCornerRadius
        return maskTopView
        }()
    
    
    fileprivate lazy var leftRabbitEar: UIView = {[unowned self] in
        
        let tempRabbitEar = UIImageView()
        tempRabbitEar.backgroundColor = UIColor.ZHNcolor(red: 241, green: 241, blue: 241, alpha: 1)
        tempRabbitEar.layer.cornerRadius = self.krabbitEarHeight/2
        return tempRabbitEar
        }()
    
    fileprivate lazy var rightRabbitEar: UIView = {[unowned self] in
        let tempRabbitEar = UIImageView()
        tempRabbitEar.backgroundColor = UIColor.ZHNcolor(red: 241, green: 241, blue: 241, alpha: 1)
        tempRabbitEar.layer.cornerRadius = self.krabbitEarHeight/2
        return tempRabbitEar
        }()
    
    fileprivate lazy var firstSingleView: UIImageView = {
        let firstSingleView = UIImageView()
        firstSingleView.backgroundColor = UIColor.clear
        firstSingleView.layer.borderColor = UIColor.white.cgColor
        firstSingleView.layer.borderWidth = 0.3
        firstSingleView.layer.cornerRadius = 2
        return firstSingleView
    }()
    
    fileprivate lazy var secondSingleView: UIImageView = {
        let secondSingleView = UIImageView()
        secondSingleView.backgroundColor = UIColor.clear
        secondSingleView.layer.borderColor = UIColor.white.cgColor
        secondSingleView.layer.borderWidth = 0.3
        secondSingleView.layer.cornerRadius = 2
        return secondSingleView
    }()
    
    fileprivate lazy var noticeLabel: UILabel = {
        let noticeLabel = UILabel()
        noticeLabel.text = "再用点力!"
        noticeLabel.textAlignment = NSTextAlignment.center
        noticeLabel.textColor = UIColor.ZHNcolor(red: 244, green: 169, blue: 191, alpha: 1)
        noticeLabel.font = UIFont.systemFont(ofSize: 12)
        noticeLabel.alpha = 0
        return noticeLabel
    }()
    
    fileprivate lazy var gifImageView: UIImageView = {
        let tempGif = UIImageView.createRabbitReFreshGif();
        return tempGif
    }()
    
    fileprivate lazy var gifNoticeLabel: UILabel = {
        let gifLabel = UILabel()
        gifLabel.text = "正在加载.."
        gifLabel.textColor = UIColor.lightGray
        gifLabel.font = UIFont.systemFont(ofSize: 12)
        gifLabel.textAlignment = NSTextAlignment.center
        gifLabel.isHidden = true
        return gifLabel
    }()
    // MARK: - 控制器的生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 加载ui
        self.setupUI()
        
        // 隐藏navibar之后默认滑动返回失效,可以通过设置代理 重载gestureRecognizerShouldBegin方法来使滑动返回返回继续生效
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
    }
    
    deinit {
        contentScrollView?.removeObserver(self, forKeyPath: "contentOffset", context: nil)
        print(" rabbitfreshcontroller -- 销毁了")
    }
}

//========================================================================
// MARK:- 私有方法
//========================================================================
extension ZHNrabbitFreshBaseViewController {
    
    // 设置控件的transform
    fileprivate func valueTransform(trans:CGFloat,rota:CGFloat){
        var Ltransform = CGAffineTransform.identity
        Ltransform = Ltransform.rotated(by: rota)
        
        var Rtransform = CGAffineTransform.identity
        Rtransform = Rtransform.rotated(by: -rota)
        
        leftRabbitEar.transform = Ltransform
        rightRabbitEar.transform = Rtransform
    }
    
    // 初始化ui
    fileprivate func setupUI() {
        
        // 1.初始化scrollview
        contentScrollView = setUpScrollView()
        contentScrollView?.layer.cornerRadius = kscrollViewCornerRadius
        contentScrollView?.delegate = self
        contentScrollView?.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
        contentScrollView?.backgroundColor = UIColor.clear
        assert(isinherit, "ZHNrabbitFreshBaseViewController的子类需要重载setUpScrollView方法")
        
        view.backgroundColor = knavibarcolor
        
        // 2.展示gifview的父控件
        view.addSubview(rabbitEarMaskView)
        rabbitEarMaskView.frame = CGRect(x: 0, y: knavibarHeight, width: view.zhnWidth, height: view.zhnheight)
        
        // 3.左耳
        rabbitEarMaskView.addSubview(leftRabbitEar)
        leftRabbitEar.frame = CGRect(x: screenWidth/2 - (krabbitEarWidth) + 5, y: 10, width: krabbitEarWidth, height: krabbitEarHeight)
        leftRabbitEar.layer.anchorPoint = CGPoint(x: 1, y: 0.5)
        
        // 4.右耳
        rabbitEarMaskView.addSubview(rightRabbitEar)
        rightRabbitEar.frame = CGRect(x: screenWidth/2 - 5, y: 10, width: krabbitEarWidth, height: krabbitEarHeight)
        rightRabbitEar.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
        
        // 5.滑动view的父控件
        view.addSubview(containerView)
        containerView.frame = view.bounds
        
        // 6.滑动控件
        containerView.addSubview(contentScrollView!)
        contentScrollView?.frame = CGRect(x: 0, y: knavibarHeight, width: view.zhnWidth, height: view.zhnheight)
        
        // 7.展示gif的view
        rabbitEarMaskView.addSubview(rabbitEarMaskTopView)
        rabbitEarMaskTopView.frame = rabbitEarMaskView.bounds
    
        // 8.信号动画view
        // 1
        rabbitEarMaskView.addSubview(firstSingleView)
        firstSingleView.center = CGPoint(x: rabbitEarMaskView.zhnCenterX, y: -20)
        firstSingleView.bounds = CGRect(x: 0, y: 0, width: 8, height: 4)
        firstSingleView.isHidden = true
        // 2
        rabbitEarMaskView.addSubview(secondSingleView)
        secondSingleView.center = CGPoint(x: rabbitEarMaskView.zhnCenterX, y: -20)
        secondSingleView.bounds = CGRect(x: 0, y: 0, width: 8, height: 4)
        secondSingleView.isHidden = true
        
        // 9.刷新gifview
        rabbitEarMaskTopView.addSubview(gifImageView)
        gifImageView.center = CGPoint(x: rabbitEarMaskTopView.zhnCenterX, y: 15)
        gifImageView.bounds = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        rabbitEarMaskTopView.addSubview(gifNoticeLabel)
        gifNoticeLabel.center =  CGPoint(x: rabbitEarMaskTopView.zhnCenterX, y: 35)
        gifNoticeLabel.bounds = CGRect(x: 0, y: 0, width: 100, height: 30)
        
        // 10.下拉提示文字label
        view.addSubview(noticeLabel)
        noticeLabel.center = CGPoint(x: view.center.x, y: knoticelabelCenterY)
        noticeLabel.bounds = CGRect(x: 0, y: 0, width: 100, height: 30)
    }
    
    // 设置动画的定时器
    fileprivate func setTimer(){
        
        // 1. 添加kongj
        rabbitEarMaskView.addSubview(firstSingleView)
        rabbitEarMaskView.addSubview(secondSingleView)
        // 2. 先添加一次动画
        self.addAnimation()
        
        // 3. 定时间添加定间隔的动画
        animateTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(timerAnimation), userInfo: nil, repeats: true)
        RunLoop.current.add(animateTimer!, forMode: RunLoopMode.commonModes)
    }
    
    // 添加动画
    fileprivate func addAnimation(){
        
        // 1.信号动画
        self.firstSingleView.isHidden = false
        UIView.animate(withDuration: 1, animations: {
            self.firstSingleView.transform = self.firstSingleView.transform.scaledBy(x: 16, y: 16)
            self.firstSingleView.alpha = 0
            }, completion: { (completed) in
                self.firstSingleView.transform = CGAffineTransform.identity
                self.firstSingleView.alpha = 1
                self.firstSingleView.isHidden = true
        })
        
        let when = DispatchTime.now() + 0.3
        DispatchQueue.main.asyncAfter(deadline: when, execute: {
            self.secondSingleView.isHidden = false
            UIView.animate(withDuration: 1, animations: {
                self.secondSingleView.transform = self.secondSingleView.transform.scaledBy(x: 16, y: 16)
                self.secondSingleView.alpha = 0
                }, completion: { (complete) in
                    self.secondSingleView.transform = CGAffineTransform.identity
                    self.secondSingleView.alpha = 1
                    self.secondSingleView.isHidden = true
            })
        })
        
        // 2.耳朵动画
        self.leftRabbitEar.layer.add(self.creatAnimation(right: false), forKey: "left")
        self.rightRabbitEar.layer.add(self.creatAnimation(right: true), forKey: "right")
    }
    
    // 生成keyframe动画
    fileprivate func creatAnimation(right:Bool) -> CAKeyframeAnimation{
        var delta:CGFloat = 1
        if right {
            delta = -1
        }
        let earAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        earAnimation.values = [delta*CGFloat(M_PI_2),delta*CGFloat(M_PI_4),delta*CGFloat(M_PI_2),delta*CGFloat(M_PI_4),delta*CGFloat(M_PI_2)]
        earAnimation.keyTimes = [0,0.25,0.5,0.75,1]
        earAnimation.duration = 0.75
        return earAnimation
    }
    
    // 刷新动画结束 清空状态
    fileprivate func clearAnimation(){
        self.animateTimer?.invalidate()
        self.animateTimer = nil
        leftRabbitEar.layer.removeAllAnimations()
        rightRabbitEar.layer.removeAllAnimations()
        firstSingleView.removeFromSuperview()
        secondSingleView.removeFromSuperview()
        gifImageView.stopAnimating()
        gifNoticeLabel.isHidden = true
        gifNoticeLabel.text = "正在加载.."
        gifImageView.center = CGPoint(x: rabbitEarMaskTopView.zhnCenterX, y: 15)
        gifNoticeLabel.center =  CGPoint(x: rabbitEarMaskTopView.zhnCenterX, y: 35)
    }
    
}

//======================================================================
// MARK:- target action
//======================================================================
extension ZHNrabbitFreshBaseViewController {
    @objc fileprivate func timerAnimation() {
        addAnimation()
    }
}

//==========================================================================
// MARK:- 公开的方法
//==========================================================================
extension ZHNrabbitFreshBaseViewController {
    
    // 外部必须重载这个方法来满足实现不同的布局的 collectionview 或者说是 tableview
   func setUpScrollView() -> UIScrollView {
        isinherit = false
        return UIScrollView()
    }
    
    // 结束刷新
    func endRefresh(loadSuccess:Bool) {
    
        // 1.获取动画时长
        var delaytime:Double = 0
        if freshing {
            delaytime = 0.7
        }
        let deadlineTime = DispatchTime.now() + delaytime
        
        // 2.添加一个延时动画
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            // <1 成功还是失败
            loadSuccess == true ? (self.gifNoticeLabel.text = "加载成功") : (self.gifNoticeLabel.text = "加载失败")
            // <2 处理一直拉了放再拉再放的情况
            if !self.dragging {
                UIView.animate(withDuration: 0.2, animations: {
                    
                    self.contentScrollView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: self.knavibarHeight + 50, right: 0)
                    self.gifImageView.center = CGPoint(x: self.rabbitEarMaskTopView.zhnCenterX, y: -40)
                    self.gifNoticeLabel.center =  CGPoint(x: self.rabbitEarMaskTopView.zhnCenterX, y: -20)
                    
                    }, completion: { (completed) in
                        self.clearAnimation()
                        self.freshing = false
                })
            }
        }
    }
    
    // 开始刷新 （子类重载这个方法，刷新的逻辑在这里实现）
    func startRefresh() {
        println("子控制器需要重载这个方法")
    }
}

//==========================================================================
// MARK:- KVO
//==========================================================================
extension ZHNrabbitFreshBaseViewController {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        // 1.判断offset漫步满足条件
        let offsetY = contentScrollView!.contentOffset.y
        guard keyPath == "contentOffset" else {return}
        guard dragging else {return}
        
        // 2.移除动画timer
        if offsetY > -KfreshMaxHeight {
            self.clearAnimation()
        }
        
        // 3.耳朵旋转加位移(minheight 到 maxheight)
        let delta = (-offsetY - kfreshMinHeight)/(KfreshMaxHeight - kfreshMinHeight)
        let rota = CGFloat(M_PI_2)*delta
        if offsetY < -kfreshMinHeight && offsetY > -KfreshMaxHeight{
            
            // <1.耳朵旋转
            valueTransform(trans: (-offsetY - kfreshMinHeight), rota: rota)
            
            // <2.耳朵父控件位移
            rabbitEarMaskView.frame = CGRect(x: 0, y: knavibarHeight+(-offsetY - kfreshMinHeight), width: view.zhnWidth, height: view.zhnheight)
            
            // <3.提示label位移加透明度变化
            noticeLabel.text = "再用点力!"
            let noticeLabelDelta = (-offsetY - kfreshMinHeight) - 20
            if noticeLabelDelta > 0 {
                noticeLabel.center = CGPoint(x: kscreenWidth/2, y: knoticelabelCenterY+noticeLabelDelta)
                noticeLabel.alpha = (-offsetY - kfreshMinHeight-20)/(KfreshMaxHeight - kfreshMinHeight-20)
            }
        }
        
        // 4.耳朵只位移(> maxheight)
        if offsetY <= -KfreshMaxHeight {
            valueTransform(trans: (-offsetY - kfreshMinHeight), rota: CGFloat(M_PI_2))
            rabbitEarMaskView.frame = CGRect(x: 0, y: knavibarHeight+(-offsetY - kfreshMinHeight), width: view.zhnWidth, height: view.zhnheight)
            noticeLabel.text = "松手加载"
            if self.animateTimer == nil {
                setTimer()
            }
        }
    }
}

//============================================================================
// MARK:- scrollview delegate
//============================================================================
extension ZHNrabbitFreshBaseViewController : UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dragging = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        dragging = false
        // 1.移除动画
        self.clearAnimation()
        
        // 2.没有超过最小高度
        guard scrollView.contentOffset.y < -kfreshMinHeight else {return}
        
        // 3.没有到达需要fresh的高度的处理
        var noFresh:Bool = true
        
        // 4.达到了需要刷新的状态
        if scrollView.contentOffset.y < -KfreshMaxHeight {
//            if !freshing {
//                startRefresh()
//            }
            startRefresh()
            freshing = true
            noFresh = false
            gifImageView.startAnimating()
            gifNoticeLabel.isHidden = false
        }
        
        // 5.动画
        DispatchQueue.main.async {// 经过测试这里不用异步加载动画的情况下会有抖动(之前写过的下拉刷新不用异步，具体不是很清楚。。为什么会抖动是因为你设置了contentInset之后contentOffset也会改变，然后EndDragging之后会有bounce效果这个效果需要contentOffset做动画)
            UIView.animate(withDuration: 0.25, animations: {
                
                // 1.
                self.noticeLabel.center = CGPoint(x: kscreenWidth/2, y: self.knoticelabelCenterY)
                self.noticeLabel.alpha = 0
                
                // 2.
                self.rabbitEarMaskView.frame = CGRect(x: 0, y: self.knavibarHeight, width: self.view.zhnWidth, height:self.view.zhnheight)
                self.leftRabbitEar.transform = CGAffineTransform.identity
                self.rightRabbitEar.transform = CGAffineTransform.identity
                
                // 3.
                self.contentScrollView?.contentInset = UIEdgeInsets(top: self.kfreshMinHeight, left: 0, bottom: self.knavibarHeight+50, right: 0)
                self.contentScrollView?.setContentOffset(CGPoint(x: 0, y: -self.kfreshMinHeight), animated: false)
                
                
                }, completion: { (complete) in
                    if noFresh {
                        self.endRefresh(loadSuccess: true)
                    }
            })
        }
    }
}

//======================================================================
// MARK:- 右滑返回的代理方法
//======================================================================
extension ZHNrabbitFreshBaseViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
