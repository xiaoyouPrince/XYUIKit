//
//  TipView.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/4/22.
//

import UIKit

class TipView: UIView {
    
    var tipString = ""
    @objc public var closeCallBack: (()->Void)?
    
    var tipLabel = UILabel()
    var closeBtn = UIImageView()
    
    init(tip: String) {
        super.init(frame: .zero)
        tipString = tip
        
        setupContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getColor(hex: Int) -> UIColor {
        let r = ((CGFloat)(hex >> 16 & 0xFF))
        let g = ((CGFloat)(hex >> 8 & 0xFF))
        let b = ((CGFloat)(hex & 0xFF))
        let color = UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
        return color
    }
    
    func setupContent() {
        
        let bgColor = getColor(hex: 0xFFF8F9)
        let ctColor = getColor(hex: 0xFF5160)
        
        backgroundColor = bgColor
        addSubview(tipLabel)
        addSubview(closeBtn)
        
        tipLabel.text = tipString
        tipLabel.textAlignment = .left
        tipLabel.font = UIFont.systemFont(ofSize: 13)
        tipLabel.textColor = ctColor
        tipLabel.numberOfLines = 0
        
        tipLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
            make.right.equalToSuperview().offset(-40)
        }
        
        let image = UIImage(named: "ic_risk_tip_close")
        closeBtn.image = image
        closeBtn.contentMode = .center
        closeBtn.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeBlock))
        closeBtn.addGestureRecognizer(tap)
        
        closeBtn.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(40)
        }
    }
    
    @objc func closeBlock(){
        if let blk = closeCallBack {
            blk()
        }
        self.removeFromSuperview()
    }
}
