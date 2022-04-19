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
    
}
