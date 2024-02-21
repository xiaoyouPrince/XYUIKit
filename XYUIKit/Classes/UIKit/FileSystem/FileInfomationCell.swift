//
//  FileInfomationCell.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/2/20.
//

import UIKit
import SnapKit

class FileInfomationCell: UITableViewCell {
    private lazy var icon = getIconView()
    private lazy var fileAbleLabel = getLabel(textColor: .lightGray, fontSize: 11)
    private lazy var label = getLabel(textColor: .black, fontSize: 16)
    private lazy var subLabel = getLabel(textColor: .lightGray, fontSize: 14)
    private lazy var createLabel = getLabel(textColor: .lightGray, fontSize: 14)
    private lazy var rightArrow = getArrawView()

    var fileNode: FileNode? { didSet { modelDidset() } }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FileInfomationCell {
    
    private func getIconView() -> UIImageView {
        let img = UIImageView()
        img.backgroundColor = .clear
        img.contentMode = .scaleAspectFit
        return img
    }
    
    private func getLabel(textColor: UIColor, fontSize: CGFloat) -> UILabel {
        let label = UILabel(title: "", font: .systemFont(ofSize: fontSize), textColor: textColor, textAlignment: .left)
        label.numberOfLines = 3
        return label
    }
    
    private func getArrawView() -> UIImageView {
        let img = UIImageView()
        img.image = UIImage.create(named: "icon_right_arrow")
        img.backgroundColor = .clear
        img.contentMode = .scaleAspectFit
        return img
    }
    
    private func modelDidset() {
        guard let fileNode = fileNode else { return }
        label.text = fileNode.name
        icon.image = fileNode.getShowIcon()
        subLabel.text = fileNode.subItemsAndTotalSize()
        rightArrow.isHidden = !fileNode.isDir
        fileAbleLabel.isHidden = fileNode.isDir
        var ableText = ""
        ableText.append(fileNode.isReadable() ? "r" : "*")
        ableText.append("/")
        ableText.append(fileNode.isWritable() ? "w" : "*")
        ableText.append("/")
        ableText.append(fileNode.isExecutable() ? "x" : "*")
        ableText.append("/")
        ableText.append(fileNode.isDeletable() ? "d" : "*")
        fileAbleLabel.text = ableText
        createLabel.isHidden = fileNode.isDir
        if let date = fileNode.createDate() {
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy.MM.dd HH:mm:ss"
            createLabel.text = dateFormat.string(from: date)
        } else {
            createLabel.text = ""
        }
    }
    
    private func setupContent() {
        contentView.addSubview(icon)
        contentView.addSubview(label)
        contentView.addSubview(subLabel)
        contentView.addSubview(rightArrow)
        contentView.addSubview(fileAbleLabel)
        contentView.addSubview(createLabel)
        
        label.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(15)
            make.top.equalTo(icon)
            make.right.lessThanOrEqualTo(-50)
        }
        icon.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.top.equalTo(4)
            make.size.equalTo(CGSize(width: 32, height: 32))
        }
        fileAbleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(icon)
            make.top.equalTo(icon.snp.bottom).offset(3)
        }
        subLabel.snp.makeConstraints { make in
            make.left.equalTo(label)
            make.right.lessThanOrEqualTo(contentView).offset(-50)
            make.top.equalTo(label.snp.bottom).offset(5)
            make.bottom.equalTo(-12)
        }
        rightArrow.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize(width: 16, height: 16))
            make.right.equalTo(-12)
        }
        createLabel.snp.makeConstraints { make in
            make.right.equalTo(-50)
            make.centerY.equalTo(subLabel)
        }
    }
}
