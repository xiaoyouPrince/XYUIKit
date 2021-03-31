//
//  RefreshHeader.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/3/30.
//

import UIKit
import MJRefresh

class RefreshHeader: MJRefreshGifHeader {
    
    var pullingView = UIImageView()

    override func prepare() {
        super.prepare()
        self.stateLabel?.isHidden = true
        self.lastUpdatedTimeLabel?.isHidden = true
        self.addSubview(pullingView)
        pullingView.image = UIImage(named: "000")
        
        var images = [UIImage]()
        for i in 0...23 {
            var name = "00\(i)"
            if i > 9 {
                name = "0\(i)"
            }
            let image = UIImage(named: name)!
            images.append(image)
        }
        
        // self.setImages(images, for: .idle)
        self.setImages(images, for: .pulling)
        self.setImages(images, for: .refreshing)
    }
    
    override var pullingPercent: CGFloat {
        didSet(newValue){
            
            if newValue >= 1.0 {
                self.pullingView.isHidden = true
                return
            }else{
                self.pullingView.isHidden = false
            }
            
            let maxWH: CGFloat! = self.pullingView.image?.size.width
            let WH = maxWH * newValue
            let Y = (self.bounds.size.height - WH) / 2
            
            self.pullingView.frame = CGRect(x: 0, y: Y, width: WH, height: WH)
            self.pullingView.center.x = self.center.x
        }
    }
    
}
