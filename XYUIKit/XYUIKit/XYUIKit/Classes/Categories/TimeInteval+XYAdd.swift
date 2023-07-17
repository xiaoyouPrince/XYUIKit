//
//  TimeInteval.swift
//  XYUIKit
//
//  Created by 渠晓友 on 2023/7/14.
//

import Foundation

public extension TimeInterval {
    
    static var since1970: Self {
        Date().timeIntervalSince1970
    }
}
