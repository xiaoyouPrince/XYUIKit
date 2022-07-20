//
//  XYTagsView.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2022/4/2.
//
//  快速创建 tagsView 的一个工具

import UIKit

open
class XYTagsView: UIView {
    
    open class Config {
        public var tagBackgroundColor = UIColor.orange.withAlphaComponent(0.3)
        public var tagTextColor = UIColor.orange
        public var tagFont = UIFont.systemFont(ofSize: 17)
        public var tagEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        public var tagMargin: CGFloat = 6
        public var tagCornerRadius: CGFloat = 5
    }
    
    static public let config: Config = Config()
    
    public private(set) var height: CGFloat = 0
    public private(set) var tagTtiles: [String] = []
    public var tagClickCallback: ((String) -> ())?
    
    class Tag: UIView {
        var name: String
        init(name: String) {
            self.name = name
            super.init(frame: .zero)
            let tip = UILabel()
            tip.text = name
            tip.textColor = XYTagsView.config.tagTextColor
            tip.font = XYTagsView.config.tagFont
            tip.sizeToFit()
            addSubview(tip)
            backgroundColor = XYTagsView.config.tagBackgroundColor
            layer.cornerRadius = XYTagsView.config.tagCornerRadius
            clipsToBounds = true
            
            tip.frame = CGRect(x: XYTagsView.config.tagEdgeInsets.left, y: XYTagsView.config.tagEdgeInsets.top, width: tip.bounds.width, height: tip.bounds.height)
            self.bounds = CGRect(x: 0, y: 0, width: tip.bounds.width + XYTagsView.config.tagEdgeInsets.left + XYTagsView.config.tagEdgeInsets.right, height: tip.bounds.height + XYTagsView.config.tagEdgeInsets.top + XYTagsView.config.tagEdgeInsets.bottom)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    public init(titles: [String], maxWitdh: CGFloat) {
        super.init(frame: .zero)
        tagTtiles = titles
        
        var lastTag: Tag?
        var row: CGFloat = 0 // 行
        let margin: CGFloat = XYTagsView.config.tagMargin
        for title in titles {
            let tag = Tag(name: title)
            addSubview(tag)
            
            if let last = lastTag {
                var tagX = last.frame.maxX + margin
                if maxWitdh <= last.frame.maxX + margin + tag.bounds.width {
                    row += 1
                    tagX = 0
                }
                
                tag.frame = CGRect(x: tagX, y: row * (tag.bounds.height + margin), width: tag.bounds.width, height: tag.bounds.height)
            }else{
                tag.frame = tag.bounds
            }
            
            lastTag = tag
            
            tag.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tagClick)))
        }
        self.height = lastTag!.frame.maxY
    }
    
    @objc func tagClick(_ tap: UITapGestureRecognizer){
        if let tag = tap.view as? Tag {
            tagClickCallback?(tag.name)
        }
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

