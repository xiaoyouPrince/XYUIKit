//
//  File.swift
//  YYUIKit
//
//  Created by will on 2024/6/25.
//

import Foundation

extension String {
    var yy_locale: String? {
        if language == .zh {
            return localize_dict[self]?.0
        }
        
        return localize_dict[self]?.1
    }
}

fileprivate extension String {
    
    enum Language {
        case en, zh
    }
    
    /// 先只支持中英
    var language: Language {
        if languagesKey == "en" {
            return .en
        } else {
            return .zh
        }
    }
    
    /// 先只支持中英
    var languagesKey: String {
        var key = Locale.preferredLanguages.first ?? "en"
        if key.hasPrefix("zh") {
            key = "zh"
        } else {
            key = "en"
        }
        return key
    }
    
    /// key : ( zh, en)
    var localize_dict: [String: (String, String)] {
        [
            "done": ("完成", "Done")
        ]
    }
}

