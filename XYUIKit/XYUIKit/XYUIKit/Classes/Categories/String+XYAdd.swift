//
//  File.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/7/5.
//
//  计算高度，生成属性字符串

import Foundation

public extension String {
    
    func length() -> Int {
        return self.count
    }
    
    static func getAttributeString(with orginStr: String, font: UIFont = UIFont.systemFont(ofSize: 14), textColor: UIColor = .black, lineSpace: Int = 4) -> NSAttributedString? {
        
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = 4
        let tipAttriStr: NSMutableAttributedString = NSMutableAttributedString(string: orginStr, attributes: [
            .font : font,
            .foregroundColor : textColor,
            .paragraphStyle : paraph
            ])
        return tipAttriStr
    }
    
    func getAttributeString(with font: UIFont = UIFont.systemFont(ofSize: 14), textColor: UIColor = .black, lineSpace: Int = 4) -> NSAttributedString? {
        String.getAttributeString(with: self, font: font, textColor: textColor, lineSpace: lineSpace)
    }
    
    /// 给当前字符串设置属性
    /// - Parameter attrs: 要设置的属性集合
    /// - Returns: 属性字符串
    func addAttributes(attrs: [NSAttributedString.Key : Any]) -> NSAttributedString {
        let tipAttriStr: NSMutableAttributedString = NSMutableAttributedString(string: self, attributes: attrs)
        return tipAttriStr
    }
    
    /// 通过正则给字符串匹配到的内容设置属性
    /// - Parameters:
    ///   - attrs: 要设置的属性集合
    ///   - pattern: 正则，调用者保证其正确性 egg: 匹配所有竖线，为 "[|]"
    /// - Returns: 返回一个属性字符串
    func addAttributes(attrs: [NSAttributedString.Key : Any], withRegx pattern: String) -> NSAttributedString {
        let result = NSMutableAttributedString(string: self)
        let regx = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        if let matches = regx?.matches(in: self, range: NSRange(location: 0, length: self.count)) {
            for m in matches {
                result.addAttributes(attrs, range: m.range)
            }
        }
        return result
    }
    
}
