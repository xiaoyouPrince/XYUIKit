//
//  GradientView.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2020/12/28.
//

import UIKit

class GradientView: UIView {
    
    override func draw(_ rect: CGRect) {
        
        let color1 = UIColor(red: CGFloat(21.0/0xFF), green: CGFloat(167.0/0xFF), blue: CGFloat(0xFF/0xFF), alpha: 1)
        let color2 = UIColor(red: CGFloat(09.0/0xFF), green: CGFloat(110.0/0xFF), blue: CGFloat(253.0/0xFF), alpha: 1)
        
        let layer = CAGradientLayer()
        layer.frame = rect
        layer.colors = [color1.cgColor, color2.cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 0)
        layer.type = .axial
        
        self.layer.addSublayer(layer)
    }

}
