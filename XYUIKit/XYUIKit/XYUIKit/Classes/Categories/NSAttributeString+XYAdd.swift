//
//  NSAttributeString+XYAdd.swift
//  XYUIKit
//
//  Created by 渠晓友 on 2023/9/2.
//

import Foundation

public extension NSAttributedString {
    private var paragraphStyle: NSMutableParagraphStyle {NSMutableParagraphStyle()}
    private var mutableSelf: NSMutableAttributedString {NSMutableAttributedString(attributedString: self)}
    
    func setLineSpacing(lineSpacing: CGFloat, textAlignment: NSTextAlignment = .left) -> NSAttributedString {
        let result = mutableSelf
        let para = paragraphStyle
        para.lineSpacing = lineSpacing
        para.alignment = textAlignment
        result.addAttributes([.paragraphStyle: para], range: NSRange(location: 0, length: self.length))
        return result
    }
}
