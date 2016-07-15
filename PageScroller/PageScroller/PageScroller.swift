//
//  PageScroller.swift
//  BohaiWywl
//
//  Created by john on 16/7/13.
//  Copyright © 2016年 john. All rights reserved.
//
import UIKit
protocol cycleScrollViewDelegate {
    func clickImgIndex(index:NSNumber)
}
class PageScroller: UIView ,UIScrollViewDelegate{
    internal var  pageHiddern:Bool?
    internal var imageArr:[String]?
    internal var autoScroll:Bool?
    internal var urlArray:NSArray?
    internal var autoTime:NSTimeInterval?
    internal var deleagte:cycleScrollViewDelegate?
    internal var pageControlCurrentPageIndicatorTintColor:UIColor? //颜色
    internal var PageControlPageIndicatorTintColor:UIColor?
    
    private var  mainScrollView = UIScrollView()
    private var myTimer : NSTimer?
    private var pageHidden:Bool?
    private var imgCount:Int?
    private var Page:UIPageControl?
    private var loadingDispose = RACDisposable()
    private var mainRect:CGRect?
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override func drawRect(rect: CGRect) {
        mainRect = rect
        if imageArr?.count == 0 || imageArr?.count == 1 || imageArr == nil{
            let imageView = UIImageView.init(frame: mainRect!)
            imageView.image = UIImage.init(named: "adu")
            self.addSubview(imageView)
            return
        }
        print("imagearr is \(imageArr) count is\(imageArr?.count)")
        setScrollerView()
        setPageController()
        setImageView()
        setAutoScroller()
    }
    deinit{
        myTimer?.invalidate()
        myTimer = nil
    }
    func setScrollerView() ->Void{
        for  childView:UIView in (self.subviews) {
            childView.removeFromSuperview()
        }
        mainScrollView = UIScrollView.init(frame: mainRect!)
        self.addSubview(mainScrollView)
        mainScrollView.delegate = self
        print("image is \(imageArr)")
        imgCount = Int((imageArr?.count)!)
        mainScrollView.contentSize = CGSizeMake(mainRect!.size.width*(CGFloat(imgCount!) + 2), mainRect!.size.height)
        mainScrollView.userInteractionEnabled = true
        mainScrollView.showsVerticalScrollIndicator   = false
        mainScrollView.showsHorizontalScrollIndicator = false
        mainScrollView.contentOffset                  = CGPointMake(mainRect!.size.width, 0);
        mainScrollView.delegate = self
        mainScrollView.pagingEnabled = true
        mainScrollView.bounces                        = true
        mainScrollView.userInteractionEnabled         = true
        print("value is \(mainScrollView.contentSize.width)")
    }
    func setPageController(){
        Page = UIPageControl.init(frame: CGRectMake((mainRect!.size.width - 130)*CGFloat(0.5),mainRect!.size.height - 30 , 130, 15))
        self.addSubview(Page!)
        Page!.layer.cornerRadius = 7.5;
        Page!.layer.masksToBounds = true;
        Page!.numberOfPages                 = Int(imgCount!);
        Page!.currentPage                   = 0;
        Page!.defersCurrentPageDisplay      = true;
        Page!.currentPageIndicatorTintColor = pageControlCurrentPageIndicatorTintColor;
        Page!.pageIndicatorTintColor        = PageControlPageIndicatorTintColor;
    }
    
    func setImageView(){
        for index in 0..<(imgCount! + 2) {
            let sv = UIScrollView.init(frame: CGRectMake(CGFloat(index)*mainRect!.size.width, 0, mainRect!.size.width, mainRect!.size.height))
            let imageView = UIImageView.init(frame: CGRectMake(-1, -1, mainRect!.size.width + 2, mainRect!.size.height + 2))
            imageView.backgroundColor = UIColor.clearColor()
            if index == 0 {
                imageView.sd_setImageWithURL(NSURL.init(string: String(imageArr![imgCount!-1])), placeholderImage: nil)
                imageView.tag = imgCount! - 1
            }else if(index == imgCount! + 1){
                imageView.sd_setImageWithURL(NSURL.init(string: String(imageArr![0])), placeholderImage: nil)
                imageView.tag = 0
            }else{
                imageView.sd_setImageWithURL(NSURL.init(string: String(imageArr![index - 1])), placeholderImage: nil)
                imageView.tag  = index - 1
            }
            imageView.userInteractionEnabled = true
            sv.userInteractionEnabled = true
            sv.addSubview(imageView)
            mainScrollView.addSubview(sv)
            
            let  tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(PageScroller.imgClicked(_:)))
            imageView.addGestureRecognizer(tapGesture)
            imageView.userInteractionEnabled = true
            imageView.contentMode = .ScaleAspectFill
        }
    }
    func imgClicked(tap:UITapGestureRecognizer)->Void{
        let imageView = tap.view as?UIImageView
        if (deleagte != nil){
            deleagte?.clickImgIndex((imageView?.tag)!)
        }
    }
    func setAutoScroller() ->Void{
        if autoScroll == true{
            if (autoTime == nil) {
                autoTime = 3.0
            }
            if myTimer == nil{
               myTimer = NSTimer(timeInterval: autoTime!, target: self, selector: #selector(PageScroller.next), userInfo: nil, repeats: true)
                NSRunLoop.currentRunLoop().addTimer(myTimer!, forMode: NSDefaultRunLoopMode)
            }
        }
    }
    
    func next() ->Void{
        var pae = Int((Page?.currentPage)!)
        pae += 1
        turnPage(pae)
    }
    func turnPage(page:Int) -> Void {
        mainScrollView.setContentOffset(CGPointMake((mainRect?.size.width)!*CGFloat(page + 1), 0), animated: true)
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let x = Int(scrollView.contentOffset.x/(mainRect?.size.width)!)
        if x == imgCount! + 1 {
            scrollView.setContentOffset(CGPointMake(mainRect!.size.width, 0), animated: false)
            Page?.currentPage = 0
        }else if(scrollView.contentOffset.x <= 0){
            scrollView.setContentOffset(CGPointMake(mainRect!.size.width * CGFloat(imgCount!), 0), animated: false)
            Page?.currentPage = imgCount!
        }else{
        Page?.currentPage = x-1
        }
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let x = Int(scrollView.contentOffset.x/(mainRect?.size.width)!)
        if x == imgCount! + 1 {
            scrollView.setContentOffset(CGPointMake(mainRect!.size.width, 0), animated: false)
            Page?.currentPage = 0
        }else if(scrollView.contentOffset.x <= 0){
            Page?.currentPage = imgCount!
            scrollView.setContentOffset(CGPointMake(mainRect!.size.width * CGFloat(imgCount!), 0), animated: false)
        }else{
            Page?.currentPage = x-1
        }
        
        /**
         *  为了视图在手托动的时候有一个延迟的效果，跟ReactiveCocoa连用
         *
         *  @param loadingDispose.dispose 终止
         *
         *  @return
         */
        myTimer?.fireDate = NSDate.distantFuture()
        loadingDispose.dispose()
        loadingDispose = RACSignal.createSignal({ (signal) -> RACDisposable! in
            signal.sendCompleted()
            return nil
        }).delay(5).subscribeCompleted({
            self.myTimer!.fireDate = NSDate.distantPast();
        })
    }
}
