//
//  FileActionCell.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/2/22.
//

import UIKit
import SnapKit

class FileActionCell: UITableViewCell {
    
    private let label: UILabel = UILabel(title: nil, font: .systemFont(ofSize: 16), textColor: .black, textAlignment: .left)
    
    var fileNode: FileNode? {
        didSet {
            label.text = fileNode?.name
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.centerY.equalTo(contentView)
            make.right.lessThanOrEqualTo(-12)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
