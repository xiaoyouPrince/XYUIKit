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

public extension String {
    
    /// 快速创建一个子字符串，裁剪到指定长度。
    /// - Parameter to: 最大长度
    /// - Returns: 裁剪后字符串
    ///  完整展示指定长度，最后加 ...
    func substringToIndex(to: Int) -> String {
        if self.length() > to {
            return String(format: "%@...", self.prefix(to) as CVarArg)
        }
        return self
    }
    
    /// 快速创建一个子字符串，裁剪到指定长度。
    /// - Parameter before: 最大长度
    /// - Returns: 裁剪后字符串
    ///  完整展示指定长度，超长后最后一个字 ...
    func substringBeforeIndex(before: Int) -> String {
        if self.length() > before {
            return String(format: "%@...", self.prefix(before-1) as CVarArg)
        }
        return self
    }
}

public extension String {
    
    /// 字符串的首字符转拼音
    /// - Returns: 大写汉语拼音字母. egg:“你好”-> N
    func firstCharacterToPinyin() -> String {
        let mutableString = NSMutableString(string: self) as CFMutableString
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        CFStringTransform(mutableString, nil, kCFStringTransformStripCombiningMarks, false)
        let pinyin = (mutableString as String).capitalized
        return String(pinyin.prefix(1))
    }
}

