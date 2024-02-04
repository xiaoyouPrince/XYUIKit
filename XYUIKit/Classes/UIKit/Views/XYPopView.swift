//
//  XYPopView.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/5/19.
//
/*
    一个弹出视图
 */

import UIKit
import SnapKit

enum XYPopAnchorType {
    case top
    case left
    case bottom
    case right
}

//let
class XYPopView: UIView {
    
    static var shared = XYPopView()
    
    private var anchorType: XYPopAnchorType = .top
    private var tipLabel : UILabel?
    
    override func draw(_ rect: CGRect) {
        
        // 1. 顶部三角
        let context = UIGraphicsGetCurrentContext();
        var sPoints: [CGPoint] = [CGPoint.zero,CGPoint.zero,CGPoint.zero]
        sPoints[0] = CGPoint(x: 32, y: 0);//坐标1
        sPoints[1] = CGPoint(x: 28, y: 7);//坐标2
        sPoints[2] = CGPoint(x: 36, y: 7);//坐标3

        context?.setStrokeColor(UIColor.clear.cgColor)
        context?.setFillColor(UIColor.xy_getColor(hex: 0x49536F).cgColor)
        context?.addLines(between: sPoints)
        context?.closePath()
        context?.drawPath(using: .fillStroke)
        context?.strokePath()
        
        // 2. 底部矩形
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 7, width: rect.size.width, height: rect.size.height - 7 ), cornerRadius: 10)
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = UIColor.xy_getColor(hex: 0x49536F).withAlphaComponent(0.8).cgColor
        layer.strokeColor = UIColor.clear.cgColor
        self.layer.insertSublayer(layer, at: 0)
    }
    
    private func setupContent() {
        
        backgroundColor = .clear
        
        tipLabel = UILabel()
        tipLabel?.text = "i am  the  test string tip sdof joa wojoaer geaorg oesg oasorngo ner ang iern gon rs iegn resnn gnu seo"
        tipLabel?.textColor = .white
        tipLabel?.font = UIFont.systemFont(ofSize: 14)
        tipLabel?.textAlignment = .left
        tipLabel?.numberOfLines = 0
        tipLabel?.backgroundColor = .clear
        addSubview(tipLabel!)
        
        tipLabel?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(17)
            make.right.equalToSuperview().offset(-17)
            make.top.equalToSuperview().offset(22)
            make.bottom.equalToSuperview().offset(-15)
        })
    }
    
    private func show() {
        UIApplication.shared.keyWindow?.addSubview(XYPopView.shared)
        XYPopView.shared.snp.makeConstraints { (make) in
            make.top.equalTo(100)
            make.left.equalTo(30)
            make.right.lessThanOrEqualToSuperview().offset(-30)
        }
    }
    
    class func showPopTip(_ anchorType: XYPopAnchorType = .top,
                    _ anchorOrign: CGPoint = .zero,
                    _ tip: String) {
        let pop = XYPopView.shared
        pop.anchorType = anchorType
        pop.setupContent()
        pop.show()
    }
    
    class func dismiss() {
        let pop = XYPopView.shared
        pop.removeFromSuperview()
    }
}
