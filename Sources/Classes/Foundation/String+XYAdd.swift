//
//  File.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/7/5.
//
//  计算高度，生成属性字符串

import Foundation
import UIKit

public extension String {
    
    func length() -> Int {
        return self.count
    }
    
    static func getAttributeString(with orginStr: String, font: UIFont = UIFont.systemFont(ofSize: 14), textColor: UIColor = .black, lineSpace: CGFloat = 4) -> NSAttributedString? {
        
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = lineSpace
        let tipAttriStr: NSMutableAttributedString = NSMutableAttributedString(string: orginStr, attributes: [
            .font : font,
            .foregroundColor : textColor,
            .paragraphStyle : paraph
            ])
        return tipAttriStr
    }
    
    func getAttributeString(with font: UIFont = UIFont.systemFont(ofSize: 14), textColor: UIColor = .black, lineSpace: CGFloat = 4) -> NSAttributedString? {
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

public extension String {
    
    /// 文本的宽高
    /// - Parameters:
    ///   - font: 字号
    ///   - size: 大小
    ///   - lineSpacing: 行间距
    /// - Returns: 宽高
    func getTextRect(font: UIFont, size: CGSize, lineSpacing: CGFloat = 0) -> CGSize {
        var attributes: [NSAttributedString.Key: Any] = [.font: font]
        
        if lineSpacing > 0 {
            let paraStyle = NSMutableParagraphStyle()
            paraStyle.lineSpacing = lineSpacing
            attributes[.paragraphStyle] = paraStyle
        }
        
        return self.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size
    }
    
    /// 富文本
    /// - Parameters:
    ///   - lineSpacing：行间距
    func lineHeight(_ lineSpacing: CGFloat) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        let attributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        return NSAttributedString(string: self, attributes: attributes)
    }
    
    /// 文本的高度
    /// - Parameters:
    ///   - font: 字号
    ///   - size: 大小
    ///   - lineSpacing: 行间距
    /// - Returns: 高度
    func heightOf(font: UIFont, size: CGSize, lineSpacing: CGFloat = 0) -> CGFloat {
        var attributes: [NSAttributedString.Key: Any] = [.font: font]
        if lineSpacing > 0 {
            let paraStyle = NSMutableParagraphStyle()
            paraStyle.lineSpacing = lineSpacing
            attributes[.paragraphStyle] = paraStyle
        }
        return NSAttributedString(string: self, attributes: attributes).boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil).size.height
        
    }
    
    /// 文本的宽度
    /// - Parameters:
    ///   - font: 字号
    ///   - height: 高度
    ///   - lineSpacing: 行间距
    /// - Returns: 高度
    func widthOf(height: CGFloat, font: UIFont, lineSpacing: CGFloat = 0) -> CGFloat {
        
        var attributes: [NSAttributedString.Key: Any] = [.font: font]
        if lineSpacing > 0 {
            let paraStyle = NSMutableParagraphStyle()
            paraStyle.lineSpacing = lineSpacing
            attributes[.paragraphStyle] = paraStyle
        }
        
        return NSAttributedString(string: self, attributes: attributes).boundingRect(with: CGSize(width: .greatestFiniteMagnitude, height: height), options: .usesLineFragmentOrigin, context: nil).size.width
    }
    
    /// 文本的宽高
    /// - Parameters:
    ///   - font: 字号
    ///   - size: 大小
    /// - Returns: 宽高
    func boundingSize(font: UIFont, size: CGSize) -> CGSize {
        return NSAttributedString(string: self, attributes: [.font: font]).boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil).size
    }

}


// MARK: - url 相关
extension String {
    /// 返回完全decode之后的url string
    public var urlDecoded: String {
        var url = self
        while let decodeUrl = url.removingPercentEncoding {
            if decodeUrl == url {
                return decodeUrl
            }
            url = decodeUrl
        }
        return url
    }
    
    /// 返回encode 后的 url String
    public var urlEncoded: String {
        let custom = CharacterSet(charactersIn: "!*'\"();:@&=+$,/?%#[]%").inverted
        if let result = self.addingPercentEncoding(withAllowedCharacters: custom) {
            return result
        }
        return self
    }
    
    /// 通过URL 得到参数
    public var urlParams: [String: String] {
        let components = URLComponents(string: self)?.queryItems ?? []
        return Dictionary(components.compactMap { ($0.name, $0.value ?? "") }) { $1 }
    }
    
    public var toUrl: URL? { URL(string: self) }
}

// MARK: - 类型转换相关
extension String {
    /// String -> Int?
    public var int: Int? { Int(self) }
    
    /// String -> Int
    public var intValue: Int { Int(self) ?? 0 }
    
    /// String -> Int32
    public var int32Value: Int32 { Int32(self) ?? 0 }
    
    /// String -> Int64
    public var int64Value: Int64 { Int64(self) ?? 0 }
    
    /// String -> Float?
    public var float: Float? { Float(self) }
    
    /// String -> Float
    public var floatValue: Float { Float(self) ?? 0 }
    
    /// String -> Double?
    public var double: Double? { Double(self) }
    
    /// String -> Double
    public var doubleValue: Double { Double(self) ?? 0 }
    
    /// String -> CGFloat?
    public var cgFloat: CGFloat? {
        if let float = float {
            return CGFloat(float)
        }
        return nil
    }
    
    /// String -> CGFloat
    public var cgValue: CGFloat { CGFloat(floatValue) }
    
    /// String -> Data?
    public var toData: Data? {
        self.data(using: .utf8)
    }
    
    /// String -> [Any]?
    public var toArray: [Any]? {
        guard let data = toData else {
            return nil
        }
        return (try? JSONSerialization.jsonObject(with: data, options: [])) as? [Any]
    }
    
    /// String -> [String: Any]?
    public var toDictionary: [String: Any]? {
        guard let data = toData else {
            return nil
        }
        return (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any]
    }
    
    /// String -> Any?
    public var toJson: Any? {
        guard let data = toData else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: [])
    }
    
    /// String -> 金额样式  egg: "2" -> "2.00"
    public var toMoneyString: String {
        String(format: "%.2f", floatValue)
    }
    
    /// String -> 返回 bool 值 egg: "1" -> true  /  "true" -> true
    public var boolValue: Bool {
        if self == "1" || self == "true" {
            return true
        }
        return false
    }
}

/// 其它
extension String {
    
    public func trim() -> String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    public static func insertData(text: String,index: Int, newElement: Character) -> String {
        var result : String = text
        if result.count > index {
            result.insert(newElement, at: result.index(result.startIndex, offsetBy: index))
        }
        return result
    }
    
    public static func removeData(text: String,index: Int ) -> String {
        var result = text
        if result.count > index {
            result.remove(at: result.index(result.startIndex, offsetBy: index))
        }
        return result
    }
}

/// 密码学相关
extension String {
    
    public var base64ToUTF8String: String {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8) ?? ""
        }
        return ""
    }
}

