//
//  ResourceLoader.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/12/24.
//

import Foundation
import UIKit

public class ResourceLoader: NSObject {
    private override init() {}
    
    static var isSPM: Bool {
#if SWIFT_PACKAGE
        return true
#else
        return false
#endif
    }
    
    static var isCocoaPod: Bool {
#if COCOAPODS
        return true
#else
        return false
#endif
    }
    
    static func image(with name: String) -> UIImage? {
        if isSPM {
            SPMResourceLoader.image(named: name)
        } else if isCocoaPod {
            PODResourceLoader.image(named: name)
        } else {
            UIImage(named: name)
        }
    }
}

class PODResourceLoader {
    // 获取图片资源
    public static func image(named name: String) -> UIImage? {
        let anyClass = Self.self
        let boxBundle = Bundle.init(for: anyClass)
        let targetBundle = Bundle.init(path: boxBundle.path(forResource: "XYUIKit", ofType: "bundle") ?? "")
        let image: UIImage? = targetBundle == nil ? nil : UIImage.init(named: name, in: targetBundle!, compatibleWith: nil)
        return image
    }
}

class SPMResourceLoader {
    // 获取图片资源
    public static func image(named name: String) -> UIImage? {
#if SWIFT_PACKAGE
        let bundle = Bundle.module
        return UIImage(named: name, in: bundle, compatibleWith: nil)
#endif
        return nil
    }
}
