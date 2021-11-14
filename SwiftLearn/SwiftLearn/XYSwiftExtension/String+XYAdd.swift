//
//  File.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/7/5.
//
//  计算高度，生成属性字符串

import Foundation

extension String {
    
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
        
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = 4
        let tipAttriStr: NSMutableAttributedString = NSMutableAttributedString(string: self, attributes: [
            .font : font,
            .foregroundColor : textColor,
            .paragraphStyle : paraph
            ])
        return tipAttriStr
    }
    
}
