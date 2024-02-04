//
//  UIImageView+XYAdd.swift
//  XYUIKit
//
//  Created by 渠晓友 on 2023/8/29.
//

import UIKit

extension UIImageView {
    
    public convenience init(named: String) {
        self.init(image: UIImage(named: named))
    }
}
