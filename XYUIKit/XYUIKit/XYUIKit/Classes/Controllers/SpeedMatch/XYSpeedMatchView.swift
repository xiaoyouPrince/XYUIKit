//
//  XYSpeedMatchView.swift
//  SpeedMatch
//
//  Created by 渠晓友 on 2022/4/22.
//

import UIKit

//判断当前view消失的一个距离设置
var kActionMargin: CGFloat = 120;
// how quickly the card shrinks. Higher = slower shrinking
var kScaleStrength: CGFloat = 4;
// upper bar for how much the card shrinks. Higher = shrinks less
var kScaleMax: CGFloat = 0.93;
// the maximum rotation allowed in radians.  Higher = card can keep rotating longer
var kRotationMax: CGFloat = 1.0;
// strength of rotation. Higher = weaker rotation
var kRotationStrength: CGFloat = 320;
//旋转角度
var kRotationAngle: CGFloat = Double.pi / 8;

public protocol XYSpeedMatchViewDataSource: NSObjectProtocol {
    func numberOfItems(in view: XYSpeedMatchView) -> Int
    func viewForItem(at index: Int, in view: XYSpeedMatchView, reusingView: UIView?) -> UIView
}

public protocol XYSpeedMatchViewDelegate: NSObjectProtocol {
    func speedMatch(view: XYSpeedMatchView, beforeSwipingItemAt index: Int)
    func speedMatch(view: XYSpeedMatchView, didRemovedItemAt index: Int)
    func speedMatch(view: XYSpeedMatchView, didLeftRemovedItemAt index: Int)
    func speedMatch(view: XYSpeedMatchView, didRightRemovedItemAt index: Int)
}
public extension XYSpeedMatchViewDelegate {
    func speedMatch(view: XYSpeedMatchView, beforeSwipingItemAt index: Int) { }
    func speedMatch(view: XYSpeedMatchView, didRemovedItemAt index: Int) { }
    func speedMatch(view: XYSpeedMatchView, didLeftRemovedItemAt index: Int) { }
    func speedMatch(view: XYSpeedMatchView, didRightRemovedItemAt index: Int) { }
}

open class XYSpeedMatchView: UIView {
    
    public var offSet: CGSize = .zero {didSet{reloadData()}}
    public var showItemsNumber: Int = 2 {didSet{reloadData()}}
    public var isCyclically = true
    public private(set) var currentIndex: Int = 0
    public weak var delegate: XYSpeedMatchViewDelegate?
    
    private weak var dataSource: XYSpeedMatchViewDataSource!
    private var itemsArray: [UIView] = []
    private var originalPoint: CGPoint = .zero
    private var xFromCenter: CGFloat = .zero
    private var yFromCenter: CGFloat = .zero
    private var swipeEnded: Bool = true
    private var reusingView: UIView?
    
    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.dragAction(_:)))
        return pan
    }()
    
    init(dataSource: XYSpeedMatchViewDataSource) {
        super.init(frame: .zero)
        self.dataSource = dataSource
        setup()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func viewDismissFromRight(){
        if itemsArray.isEmpty == false {
            viewDismissFromRight(view: topView)
        }
    }
    
    public func viewDismissFromLeft(){
        if itemsArray.isEmpty == false {
            viewDismissFromLeft(view: topView)
        }   
    }
   
}

extension XYSpeedMatchView {
    open override var frame: CGRect{
        didSet{
            reloadData()
        }
    }
}

public extension XYSpeedMatchView {
    
    var topView: UIView {
        assert(itemsArray.isEmpty == false, "获取topView失败")
        return itemsArray.first!
    }

    func reloadData() {
        
        guard let dataSource = dataSource else { return }
        
        currentIndex = 0;
        reusingView = nil;
        itemsArray.removeAll()
        
        let totoalNum = dataSource.numberOfItems(in: self)
        if totoalNum > 0 {
            if showItemsNumber > totoalNum {
                showItemsNumber = totoalNum
            }
            
            for i in 0..<showItemsNumber {
                let view = dataSource.viewForItem(at: i, in: self, reusingView: reusingView)
                view.frame = bounds
                addSubview(view)
                itemsArray.append(view)
            }
        }
        
        layoutViews()
    }
}

private extension XYSpeedMatchView {
    
    func setup() {
        isCyclically = true;
        showItemsNumber = 2;
        offSet = CGSize(width: 0, height: 5);
        swipeEnded = true;
        reloadData()
        addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func dragAction(_ pan: UIPanGestureRecognizer){
        if itemsArray.isEmpty { return }
        guard let dataSource = dataSource else { return }
        
        let totalNum = dataSource.numberOfItems(in: self)
        if currentIndex > totalNum-1 {
            currentIndex = 0
        }
        
        if swipeEnded {
            swipeEnded = false
            // delegate
            delegate?.speedMatch(view: self, beforeSwipingItemAt: currentIndex)
        }
        
        xFromCenter = pan.translation(in: topView).x
        yFromCenter = pan.translation(in: topView).y
        
        switch pan.state {
        case .began:
            originalPoint = topView.center
        case .changed:
            //取相对较小的值
            let rotationStrength: CGFloat = min(self.xFromCenter/kRotationStrength, kRotationMax);
            //旋转角度
            let  rotationAngel: CGFloat = rotationStrength * kRotationAngle;
            //比例
            let scale: CGFloat = max(1 - abs(rotationStrength)/kScaleStrength, kScaleMax);
            //重置中点
            topView.center = CGPoint(x: self.originalPoint.x + self.xFromCenter, y: self.originalPoint.y + self.yFromCenter)
            //旋转
            let transform: CGAffineTransform  = CGAffineTransform(rotationAngle: rotationAngel);
            //缩放
            let scaleTransform: CGAffineTransform = transform.scaledBy(x: scale, y: scale);
            
            topView.transform = scaleTransform;
            
        case .ended:
            endSwiped(view: topView)
        default:
            break
        }
    }

    func endSwiped(view: UIView) {
        //当这个差值大于kActionMargin 让它从右边消失
        if (self.xFromCenter > kActionMargin) {
            viewDismissFromRight(view: view)
        }
        //当这个差值小雨-kActionMargin 让它从左边消失
        else if (self.xFromCenter < -kActionMargin ){
            viewDismissFromLeft(view: view)
        }
        //其他情况恢复原来的位置
        else{
            self.swipeEnded = true;
            UIView.animate(withDuration: 0.3) { [weak self] in
                view.center = self?.originalPoint ?? .zero
                view.transform = CGAffineTransform(rotationAngle: 0)
            }
        }
    }

    func viewDismissFromRight(view : UIView) {
        
        let finishPoint: CGPoint = CGPoint(x: 500, y: 2 * self.yFromCenter + self.originalPoint.y);
        
        //动画
        UIView.animate(withDuration: 0.3) {
            view.center = finishPoint
        } completion: {[weak self] completed in
            guard let self = self else { return }
            self.delegate?.speedMatch(view: self, didLeftRemovedItemAt: self.currentIndex)
            self.viewSwipAction(view: view)
        }
    }

    func viewDismissFromLeft(view: UIView) {
        
        let finishPoint: CGPoint = CGPoint(x: -500, y: 2 * self.yFromCenter + self.originalPoint.y);
        //动画
        UIView.animate(withDuration: 0.3) {
            view.center = finishPoint
        } completion: {[weak self] completed in
            guard let self = self else { return }
            
            self.delegate?.speedMatch(view: self, didLeftRemovedItemAt: self.currentIndex)
            self.viewSwipAction(view: view)
        }
    }
    
    func viewSwipAction(view: UIView) {
        
        guard let dataSource = dataSource else { return }
        
        self.swipeEnded = true;
        //移除view 重置属性
        view.transform = CGAffineTransform(rotationAngle: 0);
        view.center = self.originalPoint;
        reusingView  = view;
        itemsArray = itemsArray.filter({ item in
            item != view
        })
        
        view.removeFromSuperview()
        let totalNumber = dataSource.numberOfItems(in: self)
        
        var newView: UIView? = nil
        var newIndex: Int = currentIndex + showItemsNumber;
        if (newIndex < totalNumber) {
            newView = dataSource.viewForItem(at: newIndex, in: self, reusingView: reusingView);
        }else{
            if (isCyclically) {
                if (totalNumber == 1) {
                    newIndex = 0;
                }else{
                    newIndex %= totalNumber;
                }
                newView = dataSource.viewForItem(at: newIndex, in: self, reusingView: reusingView);
            }
        }
        if let newView = newView {
            if (self.frame.size.equalTo(topView.frame.size)) {
                    newView.frame = topView.frame
                }else{
                    newView.frame = CGRect(x: topView.frame.origin.x,
                                           y: topView.frame.origin.y,
                                           width: self.frame.size.width,
                                           height: self.frame.size.height);
                }
            self.itemsArray.append(newView)
        }
        
        delegate?.speedMatch(view: self, didRemovedItemAt: currentIndex)
        
        currentIndex += 1;
        layoutViews()
    }
    
    func layoutViews() {
        
        if itemsArray.isEmpty { return }
        
        for item in subviews {
            item.removeFromSuperview()
        }
        layoutIfNeeded()
        
        let width: CGFloat = self.frame.size.width;
        let height: CGFloat  = self.frame.size.height;
        //水平偏移量
        let horizonOffset: CGFloat = offSet.width;
        //垂直偏移量
        let verticalOffset: CGFloat = offSet.height;
        let lastView: UIView = itemsArray.last!
        let viewW: CGFloat = lastView.frame.size.width;
        let viewH: CGFloat = lastView.frame.size.height;
        var firstViewX: CGFloat = (width - viewW - CGFloat((showItemsNumber - 1))*abs(horizonOffset))/2;
        if (horizonOffset < 0) {
            firstViewX += (CGFloat(showItemsNumber-1) * abs(horizonOffset));
        }
        var firstViewY: CGFloat = (height - viewH - CGFloat((showItemsNumber - 1)) * abs(verticalOffset))/2;
        if (verticalOffset < 0) {
            firstViewY += (CGFloat(showItemsNumber - 1) * abs(verticalOffset));
        }
        
        let num = itemsArray.count
        UIView.animate(withDuration: 0.01) {
            for i in 0..<num {
                let index = num - 1 - i
                let view = self.itemsArray[index]
                let size = self.frame.size
                view.frame = CGRect(x: firstViewX + CGFloat(index) * horizonOffset, y: firstViewY + CGFloat(index) * verticalOffset, width: size.width, height: size.height)
                self.addSubview(view)
            }
         }
    }
}
