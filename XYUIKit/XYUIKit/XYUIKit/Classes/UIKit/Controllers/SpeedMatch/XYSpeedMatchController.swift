//
//  XYSpeedMatchController.swift
//  SpeedMatch
//
//  Created by 渠晓友 on 2022/4/22.
//

import UIKit

open class XYSpeedMatchController: UIViewController {
    
    private var bgImage: UIImage?
    private var bgImageView: UIImageView?
    
    public var matchView: XYSpeedMatchView!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bgImageView?.frame = view.bounds
    }
}

extension XYSpeedMatchController {
    
    private func buildUI() {
        view.backgroundColor = .white
        
        // bgView
        if bgImageView == nil {
            bgImageView = UIImageView(frame: .zero)
            view.addSubview(bgImageView!)
        }
        bgImageView?.image = bgImage
        
        // matchView
        matchView = XYSpeedMatchView(dataSource: self)
        matchView.delegate = self
        guard let contentView = matchView else {return}
        contentView.backgroundColor = .clear
        view.addSubview(contentView)
        contentView.frame = CGRect(x: 50, y: 200, width: UIScreen.main.bounds.width - 100, height: 400)
    }
    
    @objc public func setBgImage(_ image: UIImage) {
        bgImage = image
        
        if let iv = bgImageView {
            iv.image = image
        }
    }
    
}

@objc
extension XYSpeedMatchController: XYSpeedMatchViewDataSource, XYSpeedMatchViewDelegate {
    
    open func numberOfItems(in view: XYSpeedMatchView) -> Int {
        5
    }
    
    open func viewForItem(at index: Int, in view: XYSpeedMatchView, reusingView: UIView?) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(red: CGFloat((arc4random()%256))/255, green: CGFloat((arc4random()%256))/255, blue: CGFloat((arc4random()%256))/255, alpha: 1)
        return view
    }
    
    open func speedMatch(view: XYSpeedMatchView, beforeSwipingItemAt index: Int) {}
    open func speedMatch(view: XYSpeedMatchView, inSwipingItemAt index: Int) {}
    open func speedMatch(view: XYSpeedMatchView, afterSwipingItemAt index: Int) {}
    open func speedMatch(view: XYSpeedMatchView, didRemovedItemAt index: Int) {}
    open func speedMatch(view: XYSpeedMatchView, didLeftRemovedItemAt index: Int) {}
    open func speedMatch(view: XYSpeedMatchView, didRightRemovedItemAt index: Int) {}
}
