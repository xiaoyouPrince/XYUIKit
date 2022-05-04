//
//  Collection+XYAdd.swift
//  XYUIKit
//
//  Created by 渠晓友 on 2022/5/4.
//

import Foundation

public extension Collection {
    
    var toString: String? {
        guard let data = toData else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    var toData: Data? {
        if JSONSerialization.isValidJSONObject(self) {
            return try? JSONSerialization.data(withJSONObject: self, options: [])
        }
        return nil
    }
}
