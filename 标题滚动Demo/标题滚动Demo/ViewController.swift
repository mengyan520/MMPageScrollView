//
//  ViewController.swift
//  标题滚动Deom
//
//  Created by Youcai on 2017/4/20.
//  Copyright © 2017年 mm. All rights reserved.
//

import UIKit
private let SCREEN_WIDTH = UIScreen.main.bounds.size.width
private let SCREEN_HEIGHT =  UIScreen.main.bounds.size.height
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let titles = ["新浪","百度","网易新伟","腾讯新闻","知乎","微博"]
        for i in 0..<titles.count {
            let color = CGFloat(i).truncatingRemainder(dividingBy: CGFloat(2)) == 0 ? UIColor.red : UIColor.blue
      
            addChildViewController(makeVCWthColor(color: color))
        }
        let titleView = PageScrollView.init(childControllers: self.childViewControllers, titles: titles)
       titleView.frame = CGRect.init(x: 0, y: 10, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-10)
       
        titleView.indicatorStyle = .IndicatorStyleStretch
        titleView.titleStyle = .TitleStyleBlend
        titleView.selectedIndex = 2
        //titleView.isHiddenIndicatorView = true
        view.addSubview(titleView)
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func makeVCWthColor(color:UIColor) -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = color
        return vc
    }
    
}

