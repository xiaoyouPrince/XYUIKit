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
    
    /// 设置 lineSpace
    /// - Parameters:
    ///   - lineSpacing: lineSpacing
    ///   - textAlignment: lineSpacing
    /// - Returns: NSAttributedString
    func setLineSpacing(lineSpacing: CGFloat, textAlignment: NSTextAlignment = .left) -> NSAttributedString {
        let result = mutableSelf
        let para = paragraphStyle
        para.lineSpacing = lineSpacing
        para.alignment = textAlignment
        result.addAttributes([.paragraphStyle: para], range: NSRange(location: 0, length: self.length))
        return result
    }
    
    /// 更新段落样式
    /// - Parameter handler: 将段落样式对象提供给调用者， 调用方可以直接设置该对象属性
    /// - Returns: NSAttributedString
    func updateParagraphStyle(_ handler: (NSMutableParagraphStyle) -> ()) -> NSAttributedString {
        let result = mutableSelf
        let para = paragraphStyle
        handler(para)
        result.addAttributes([.paragraphStyle: para], range: NSRange(location: 0, length: self.length))
        return result
    }
    
    /// 使用正则表达式给匹配到 subString 设置属性
    /// - Parameters:
    ///   - attrs: 新属性
    ///   - pattern: 正则表达式
    /// - Returns: NSAttributedString
    func setAttributes(attrs: [NSAttributedString.Key : Any], withRegx pattern: String) -> NSAttributedString {
        let result = mutableSelf
        let regx = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        if let matches = regx?.matches(in: string, range: NSRange(location: 0, length: string.count)) {
            for m in matches {
                result.addAttributes(attrs, range: m.range)
            }
        }
        return result
    }
    
}
