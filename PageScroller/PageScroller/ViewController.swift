//
//  ViewController.swift
//  PageScroller
//
//  Created by john on 16/7/15.
//  Copyright © 2016年 john. All rights reserved.
//
import UIKit
public let kScreenWidth = UIScreen.mainScreen().bounds.size.width
class ViewController: UIViewController {
    private  let  adView:PageScroller = {
        let  views = PageScroller()
        views.frame = CGRectMake(0, 0,kScreenWidth ,377);
        views.autoTime = 2.0 //必须设置，时间参数
        views.autoScroll = true //是否允许自动滚动
        views.pageHiddern = false
        views.imageArr = ["http://image.5156dujia.com/2016/06/0fc65f71f51744dba23d63298f78e026.jpg", "http://image.5156dujia.com/2016/07/44b53eedadb24914b69781ef492f183d.jpg", "http://image.5156dujia.com/2016/06/7dd2e321231f4037a52635ae16b2589b.jpg", "http://image.5156dujia.com/2016/07/95780ce1f02546ef8fea5c2836043ce0.jpg", "http://image.5156dujia.com/2016/07/54eaf3cfadd243d89db15ea1f9968a3e.jpg"]
        return views
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(adView)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

