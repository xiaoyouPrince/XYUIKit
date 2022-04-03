//
//  CapatureViewController.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/8/4.
//

import UIKit

class CapatureViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .red
        
        let cap = CapatureView()
        self.view.addSubview(cap)
        
        if #available(iOS 14.0, *) {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "返回", style: .plain, target: self, action: #selector(goback))
        } else {
            // Fallback on earlier versions
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.subviews.first?.frame = view.bounds
        
        print(Date.init())
    }
    
    @objc func goback(){
        self.navigationController?.popViewController(animated: true)
    }
}


class CapatureView: UIView {

    override func draw(_ rect: CGRect) {
        
//        let ctx = UIGraphicsGetCurrentContext()
//        ctx?.setLineWidth(2)
//        ctx?.setStrokeColor(UIColor.yellow.withAlphaComponent(0.5).cgColor)
//        ctx?.addRect(CGRect(x: 100, y: 200, width: 200, height: 200))
//        ctx?.strokePath()
        
        
        
        
        
        
        let frame = CGRect(x: 100, y: 200, width: 200, height: 200)
        
        let path = CGMutablePath()
        path.addRect(CGRect(x: 100, y: 200, width: 200, height: 200))
        path.addRect(self.superview!.bounds)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path
        shapeLayer.fillRule = .evenOdd
//        shapeLayer.lineWidth = 200
        shapeLayer.strokeColor = UIColor.yellow.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(shapeLayer)
        
        
        
//
//        UIColor.red.withAlphaComponent(0.2).setFill()
//        ctx?.fill(frame)
        
        
        
        
        
//        backgroundColor = UIColor.green.withAlphaComponent(0.2)
    }
}
