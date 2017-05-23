//
//  TitleScrollView.swift
//  标题滚动Deom
//
//  Created by Youcai on 2017/4/20.
//  Copyright © 2017年 mm. All rights reserved.
//

import UIKit
private let SCREEN_WIDTH = UIScreen.main.bounds.size.width
private let SCREEN_HEIGHT =  UIScreen.main.bounds.size.height
class PageScrollView: UIView {
    
    // MARK: - init
    init(childControllers:[UIViewController],titles:[String]) {
        super.init(frame:.zero)
        self.childControllers = childControllers
        self.titles = titles
        itemCount = CGFloat(titles.count)
        addSubviews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - addsubviews
    func addSubviews() {
       
        addSubview(TitleScrollView)
        addSubview(VcScrollView)
        addChildView(index: 0)
        for i in 0..<titles.count {
            let lbl = ChannelLabel()
            lbl.font = UIFont.systemFont(ofSize: itemFont)
            lbl.text = titles[i]
            lbl.textColor = i == 0 ? selectedColor : unSelectedColor
            lbl.textAlignment = .center
            lbl.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.changeChildControllerOnClick(tap:)))
            lbl.addGestureRecognizer(tap)
            lblArrays.append(lbl)
            lbl.tag = i
            
            TitleScrollView.addSubview(lbl)
        }
        currentItem = lblArrays[selectedIndex]
        TitleScrollView.addSubview(indicatorView)
        isHiddenIndicatorView = false
    }
    
    // MARK: - layout
    override func layoutSubviews() {
        
        super.layoutSubviews()
        if selectedIndex > Int(itemCount - 1) {
            selectedIndex = 0
        }
        
        itemWidth = SCREEN_WIDTH / (itemCount < maxNumberOfItems ? itemCount : maxNumberOfItems)
        
        TitleScrollView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: titleScrollViewHeight)
        TitleScrollView.contentSize = CGSize.init(width: itemWidth * itemCount, height: 0)
        
        VcScrollView.frame = CGRect.init(x: 0, y: titleScrollViewHeight, width: SCREEN_WIDTH, height:  self.bounds.size.height  - titleScrollViewHeight)
        VcScrollView.contentSize = CGSize.init(width: SCREEN_WIDTH * itemCount, height: 0)
        VcScrollView.contentOffset = CGPoint.init(x: SCREEN_WIDTH * CGFloat(selectedIndex), y: 0)
        for i in 0..<lblArrays.count {
            let lbl = lblArrays[i]
            lbl.frame = CGRect.init(x:CGFloat(i) * itemWidth, y: 0, width: itemWidth, height: titleScrollViewHeight)
            if titleStyle == .TitleStyleGradient {
                if i != selectedIndex {
                    lbl.transform = CGAffineTransform.init(scaleX: minScale, y: minScale)
                }
            }
            if unSelectedColor != UIColor.black {
                if i != selectedIndex {
                    lbl.textColor = unSelectedColor
                }
                
            }
        }
        titleScrollViewWithAnimation(isAnimate: false)
        setIndicatorViewFrame(item: lblArrays[selectedIndex])
        if (selectedIndex > 0 ) {
            addChildView(index: CGFloat(selectedIndex))
            changeSelectedItem(item: lblArrays[selectedIndex])
        }
        if (selectedColor != UIColor.red)  {
            let colors = getRGBWithColor(color: selectedColor)
            
            selectedColorR = colors[0]
            selectedColorG = colors[1]
            selectedColorB = colors[2]
        }
        if (unSelectedColor != UIColor.black)  {
            let colors = getRGBWithColor(color: unSelectedColor)
            
            unSelectedColorR = colors[0]
            unSelectedColorG = colors[1]
            unSelectedColorB =  colors[2]
            
        }
    }
    //获取color的rgb值
    func getRGBWithColor(color:UIColor)-> [CGFloat] {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        let numComponents = color.cgColor.numberOfComponents
        if numComponents == 4 {
            let components = color.cgColor.components
            r = (components?[0])!
            g = (components?[1])!
            b = (components?[2])!
        }
        return [r,g,b]
    }
    func setIndicatorViewFrame(item:ChannelLabel)  {
        indicatorView.backgroundColor = selectedColor
        switch indicatorStyle {
        case .IndicatorStyleOffset,.IndicatorStyleDefault,.IndicatorStyleStretch:
            
            indicatorView.frame = CGRect.init(x: item.center.x - indicatorWidth/2.0, y: titleScrollViewHeight - indicatorHeight, width: indicatorWidth, height: indicatorHeight)
            break
        case .IndicatorStyleFollowText:
            let w = widthWithFont(string: item.text!)
            indicatorView.frame = CGRect.init(x: item.center.x - w / 2.0, y: titleScrollViewHeight - indicatorHeight, width: w, height: indicatorHeight)
            break
        
            
            
        }
        
    }
    // MARK: - enum
    enum TitleStyle:Int {
        case TitleStyleDefault = 0 //正常
        case TitleStyleGradient = 1 //渐变
        case TitleStyleBlend = 2 //填充
    }
    enum IndicatorStyle:Int {
        case IndicatorStyleDefault = 0 //正常，自定义宽度
        case IndicatorStyleOffset = 1  //位移
        case IndicatorStyleFollowText = 2 //跟随文本长度变化
        case IndicatorStyleStretch = 3 //拉伸
    }
    // MARK: - public
    var itemFont:CGFloat = 14 //字体大小
    var selectedIndex = 0 //当前选择项
    var selectedColor = UIColor.red//选中颜色
    var unSelectedColor = UIColor.black /*未选择颜色*/
    var titleStyle:TitleStyle = .TitleStyleDefault
    var indicatorStyle:IndicatorStyle = .IndicatorStyleDefault
    var titleScrollViewHeight:CGFloat = 40
    var itemWidth:CGFloat = 0
    var itemCount:CGFloat = 0
    var maxNumberOfItems:CGFloat = 4 /*一页展示最多的item个数，如果比item总数少，按照item总数计算*/
    var indicatorHeight:CGFloat = 1
    var indicatorWidth:CGFloat = 20
    var time:TimeInterval = 0.2 //标题滚动默认动画时间
    var minScale:CGFloat = 0.8 //字体渐变，未选择的item的scale，默认是0.8（0~1)
    var isHiddenIndicatorView:Bool? {
        didSet {
           indicatorView.isHidden = isHiddenIndicatorView!
        }
    }
    // MARK: - private
    fileprivate lazy var childControllers = [UIViewController]()
    fileprivate lazy var titles = [String]()
    fileprivate lazy var lblArrays = [ChannelLabel]()
    fileprivate lazy var currentItem:ChannelLabel = ChannelLabel()
    fileprivate lazy var leftItemIndex = 0 //记录滑动时左边的itemIndex
    fileprivate lazy var rightItemIndex = 0 //记录滑动时右边的itemIndex
    fileprivate lazy var currentIndex:CGFloat = 0
    fileprivate var selectedColorR:CGFloat = 1
    fileprivate var selectedColorG:CGFloat = 0
    fileprivate var selectedColorB:CGFloat = 0
    fileprivate var unSelectedColorR:CGFloat = 0
    fileprivate var unSelectedColorG:CGFloat = 0
    fileprivate var unSelectedColorB:CGFloat = 0
    
    // MARK: - Lazy
    fileprivate lazy var TitleScrollView:UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = UIColor.white
        view.delegate = self
        return view
    }()
    fileprivate lazy var VcScrollView:UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = UIColor.white
        view.delegate = self
        view.isPagingEnabled = true
        return view
    }()
    fileprivate lazy var indicatorView:UIView = {
        let view = UIView()
        
        return view
    }()
    
}
// MARK: - action
extension PageScrollView {
    //标题点击
    func changeChildControllerOnClick(tap:UITapGestureRecognizer)  {
        let lbl = tap.view as! ChannelLabel
        
        let offsetX = CGFloat(lbl.tag) * SCREEN_WIDTH
        VcScrollView.setContentOffset(CGPoint.init(x: offsetX, y: 0), animated: true)
        
    }
    //标题变色
    func changeSelectedItem(item:ChannelLabel)  {
        
        currentItem.textColor = unSelectedColor
        item.textColor = selectedColor
        currentItem = item
        selectedIndex = item.tag
        
    }
    //获取字符串宽度
    func widthWithFont(string:String) -> CGFloat {
        
        let rect = string.boundingRect(with: CGSize.init(width: itemWidth, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesFontLeading, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: itemFont)], context: nil)
        if indicatorStyle == .IndicatorStyleDefault {
            return indicatorWidth
        }else {
            if rect.width < 2 {
                return indicatorWidth
            }else {
                
                return rect.width
            }
            
        }
    }
}
// MARK: - UIScrollViewDelegate
extension PageScrollView:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == VcScrollView {
            if VcScrollView.contentOffset.x <= 0 {
                leftItemIndex =  0
                rightItemIndex = 0
            }else if VcScrollView.contentOffset.x >= (VcScrollView.contentSize.width - SCREEN_WIDTH) {
                leftItemIndex = Int(itemCount) - 1
                rightItemIndex = Int(itemCount) - 1
            }else {
                leftItemIndex = Int(VcScrollView.contentOffset.x/SCREEN_WIDTH)
                rightItemIndex = leftItemIndex + 1
            }
            switch titleStyle {
                
            case .TitleStyleGradient:
                changeTitleWithGradient()
                break
            case .TitleStyleBlend:
                changeTitleWithBlend()
                break
            default: break
                
            }
            switch indicatorStyle {
            case .IndicatorStyleOffset,.IndicatorStyleFollowText:
                
                changeIndicatorFrameOffsetAndFollowText()
                break
                
            case .IndicatorStyleStretch:
                changeIndicatorFrameByStretch()
                break
            default:
                break
                
            }
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == VcScrollView {
            scrollViewDidEndScrollingAnimation(scrollView)
            
        }
        
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView){
        if scrollView == TitleScrollView {
            return
        }
        let index = scrollView.contentOffset.x / VcScrollView.bounds.size.width
        if currentIndex == index {
            return
        }
        currentIndex = index
        
        addChildView(index: index)
        changeSelectedItem(item: lblArrays[Int(index)])
        titleScrollViewWithAnimation(isAnimate: true)
        if indicatorStyle == .IndicatorStyleDefault {
            changeIndicatorFrameDefault()
        }
    }
    func addChildView(index:CGFloat)  {
        
        let vc = childControllers[Int(index)]
        
        if vc.view.superview != nil {
            
            return
        }
        
        let W = VcScrollView.frame.size.width
        let H = VcScrollView.frame.size.height
        let Y:CGFloat = 0
        let X = index * W
        vc.view.frame = CGRect.init(x: X, y: Y, width: W, height: H)
        VcScrollView.addSubview(vc.view)
        vc.view.backgroundColor = index.truncatingRemainder(dividingBy: CGFloat(2)) == 0 ? UIColor.red : UIColor.blue
        
    }
    
}
// MARK: - Title animation
extension PageScrollView {
    func changeTitleWithDefault()  {
        
    }
    func changeTitleWithGradient()  {
        if leftItemIndex != rightItemIndex {
            let rightScale = VcScrollView.contentOffset.x / SCREEN_WIDTH - CGFloat( leftItemIndex)
            let leftScale = 1 - rightScale
            //颜色渐变
            let r = selectedColorR - unSelectedColorR
            let g = selectedColorG - unSelectedColorG
            let b = selectedColorB - unSelectedColorB
            let leftItemColor = UIColor.init(red: unSelectedColorR + leftScale * r, green: unSelectedColorB + leftScale * g, blue: unSelectedColorB + leftScale * b, alpha: 1.0)
            let rightItemColor = UIColor.init(red: unSelectedColorR + rightScale * r, green: unSelectedColorB + rightScale * g, blue: unSelectedColorB + rightScale * b, alpha: 1.0)
            lblArrays[leftItemIndex].textColor = leftItemColor
            lblArrays[rightItemIndex].textColor = rightItemColor
            lblArrays[leftItemIndex].transform = CGAffineTransform.init(scaleX: minScale+(1-minScale)*leftScale, y: minScale+(1-minScale)*leftScale)
            lblArrays[rightItemIndex].transform = CGAffineTransform.init(scaleX: minScale+(1-minScale)*rightScale, y: minScale+(1-minScale)*rightScale)
        }
    }
    func changeTitleWithBlend()  {
        if leftItemIndex == rightItemIndex {
            return
        }
        let leftScale = VcScrollView.contentOffset.x / SCREEN_WIDTH - CGFloat( leftItemIndex)
        lblArrays[leftItemIndex].textColor = selectedColor
        lblArrays[rightItemIndex].textColor = unSelectedColor
        lblArrays[leftItemIndex].fillColor = unSelectedColor
        lblArrays[rightItemIndex].fillColor = selectedColor
        lblArrays[leftItemIndex].process = leftScale
        lblArrays[rightItemIndex].process = leftScale
    }
    
}
// MARK: - Indicator animation
extension PageScrollView {
    func changeIndicatorFrameDefault()  {
        UIView.animate(withDuration: time) {
            self.indicatorView.frame.origin.x = self.lblArrays[self.selectedIndex].center.x - self.indicatorWidth/2.0
        }
    }
    func changeIndicatorFrameOffsetAndFollowText()  {
        
        //默认中心
        let index = 0.5 + VcScrollView.contentOffset.x / SCREEN_WIDTH
        
        let nowIndicatorCenterX = itemWidth * index
        let leftW = widthWithFont(string: lblArrays[leftItemIndex].text!)
        let rightW = widthWithFont(string: lblArrays[rightItemIndex].text!)
        let w = leftW + (rightW - leftW) * (VcScrollView.contentOffset.x / SCREEN_WIDTH - CGFloat( leftItemIndex)
        )
        
        indicatorView.frame = CGRect.init(x:nowIndicatorCenterX  - w/2.0, y: titleScrollViewHeight - indicatorHeight, width: w, height: indicatorHeight)
    }
    func changeIndicatorFrameByStretch()  {
        if indicatorWidth <= 0  {
            return
        }
        let relativeLocation = VcScrollView.contentOffset.x / SCREEN_WIDTH - CGFloat( leftItemIndex)
        
        var newFrame = CGRect.init(x: 0, y: titleScrollViewHeight - indicatorHeight, width: indicatorWidth, height: indicatorHeight)
        
        if relativeLocation <= 0.5 {
            newFrame.size.width = indicatorWidth + itemWidth * (relativeLocation/0.5)
            newFrame.origin.x = lblArrays[leftItemIndex].center.x  - indicatorWidth/2.0
        }else {
            newFrame.size.width = indicatorWidth + itemWidth * ((1-relativeLocation)/0.5)
            newFrame.origin.x = lblArrays[rightItemIndex].center.x  + indicatorWidth/2.0 - newFrame.size.width
        }
       
        indicatorView.frame = newFrame
    }
}
// MARK: - TitleScrollView animation
extension PageScrollView {
    func titleScrollViewWithAnimation(isAnimate:Bool)  {
        let item = lblArrays[selectedIndex]
        let  selectedItemCenterX = item.center.x
        
        var offsetX:CGFloat = 0
        if selectedItemCenterX + SCREEN_WIDTH/2.0 >= TitleScrollView.contentSize.width {
            offsetX = TitleScrollView.contentSize.width - SCREEN_WIDTH; //不足以到中心，靠右
            
        } else if selectedItemCenterX - SCREEN_WIDTH/2.0 <= 0 {
            offsetX = 0; //不足以到中心，靠左
        } else {
            offsetX = selectedItemCenterX - SCREEN_WIDTH/2.0; //修正至中心
            
        }
        TitleScrollView.setContentOffset(CGPoint.init(x: offsetX, y: 0), animated: isAnimate)
    }
}
// MARK: - ChannelLabel
class ChannelLabel: UILabel {
    var fillColor:UIColor?
    var process:CGFloat?{
        didSet {
            setNeedsDisplay()
        }
    }
    //- draw
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if fillColor == nil {
            return
        }
        fillColor?.setFill()
        
        UIRectFillUsingBlendMode(CGRect.init(x: rect.origin.x, y: rect.origin.y, width: rect.size.width * process!, height: rect.size.height), .sourceIn)
    }
    
}
