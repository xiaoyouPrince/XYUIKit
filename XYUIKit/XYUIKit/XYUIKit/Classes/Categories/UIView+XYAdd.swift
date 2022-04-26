//
//  UIView+XYAdd.swift
//  XYUIKit
//
//  Created by 渠晓友 on 2022/4/25.
//

import UIKit

public func cornerRadius(_ cornerRadius: CGFloat, forView view: UIView){
    view.layer.cornerRadius = cornerRadius
    view.clipsToBounds = true
}

