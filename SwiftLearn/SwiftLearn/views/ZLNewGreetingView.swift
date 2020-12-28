//
//  ZLNewGreetingView.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2020/12/11.
//

import UIKit

class ZLNewGreetingModel {
    var avater: String = "https://pics3.baidu.com/feed/9358d109b3de9c82058d19712a54380d1bd84345.jpeg?token=e9f84f81d823578d3650209027e479b5&s=BA19A14CFC0B015595E02EBB0300D08E"
    var gender: String = "男"
}

class ZLNewGreetingView: UIView {

    typealias function = ()->()
    
    let contentColor = UIColor(red: CGFloat(0x09) / 255.0, green: CGFloat(0x6E) / 255.0, blue: CGFloat(0xFD) / 255.0, alpha: 1)
    var closeHandler: function?
    var openHandler: function?
    
    var bgView = UIView()
    var closeBtn = UIButton()
    var titleLabel = UILabel()
    var openBtn = UILabel()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupContent()
    }
    
    init(closeHandler: (()->())? = nil, openHandler: (()->())? = nil) {
        super.init(frame: .zero)
        setupContent(closeHandler: closeHandler, openHandler: openHandler)
    }
    
    
    func setupContent(closeHandler: (()->())? = nil, openHandler: (()->())? = nil) {
        
        self.closeHandler = closeHandler
        self.openHandler = openHandler
        self.backgroundColor = UIColor.clear
        
        addSubview(bgView)
        bgView.addSubview(closeBtn)
        bgView.addSubview(titleLabel)
        bgView.addSubview(openBtn)
        
        bgView.layer.cornerRadius = 12
        bgView.backgroundColor = contentColor.withAlphaComponent(0.05)
        bgView.layer.shadowColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        bgView.layer.shadowRadius = 6
        bgView.layer.shadowOpacity = 0.99
        bgView.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        closeBtn.setTitle("头像", for: .normal)
        closeBtn.setTitleColor(contentColor, for: .normal)
        closeBtn.addTarget(self, action: #selector(closeBtnHandler), for: .touchUpInside)
        closeBtn.backgroundColor = UIColor.red
        
        titleLabel.text = "13人发来新招呼"
        titleLabel.textColor = .black
        titleLabel.font = UIFont(name: "PingFangSC-Medium", size: 14)
        
        openBtn.text = "快速处理"
        openBtn.textColor = .white
        openBtn.backgroundColor = contentColor
        openBtn.font = UIFont(name: "PingFangSC-Medium", size: 12)
        openBtn.textAlignment = .center
        openBtn.layer.cornerRadius = 15
        openBtn.clipsToBounds = true
        openBtn.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(openBtnHandler))
        openBtn.addGestureRecognizer(tap)
        
        bgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview()
        }
        
        closeBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.size.equalTo(CGSize(width: 50, height: 30))
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(closeBtn.snp.right).offset(12)
            make.centerY.equalToSuperview()
        }
        
        openBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 74, height: 30))
            make.right.equalToSuperview().offset(-8)
        }
    }
    
    // 外界调用
    func update(with models: [ZLNewGreetingModel]) {
        let count = models.count
        
        if count == 0 {
            fatalError("更新且没有数据，需调用放处理")
        }
        
        self.titleLabel.text = "\(count)人发来新招呼"
        func makeImageIV(_ models:[ZLNewGreetingModel], index: Int, radius: CGFloat = 20) -> UIImageView{
            let url = URL(string: models[index].avater)
            let data = NSData(contentsOf: url!)! as Data
            let imageView = UIImageView(image: UIImage(data: data))
            imageView.layer.cornerRadius = radius
            imageView.clipsToBounds = true
            return imageView
        }
        
        // 三个头像 - 没动效
        if models.count == 1 {
            let imageView1 = makeImageIV(models, index: 0)
            addSubview(imageView1)
            imageView1.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize(width: 40, height: 40))
                make.center.equalTo(closeBtn)
            }
        }
        
        if models.count == 2 {
            
            // 1
            let imageView1 = makeImageIV(models, index: 0, radius: 12.5)
            addSubview(imageView1)
            imageView1.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize(width: 25, height: 25))
                make.centerY.equalTo(closeBtn)
                make.left.equalTo(closeBtn)
            }
            
            // 2
            let imageView2 = makeImageIV(models, index: 1, radius: 12.5)
            addSubview(imageView2)
            imageView2.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize(width: 25, height: 25))
                make.centerY.equalTo(closeBtn)
                make.right.equalTo(closeBtn)
            }
            
        }
        
        if models.count >= 3 {
            // 1
            let imageView1 = makeImageIV(models, index: 0, radius: 10)
            addSubview(imageView1)
            imageView1.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize(width: 20, height: 20))
                make.centerY.equalTo(closeBtn)
                make.left.equalTo(closeBtn)
            }
            
            // 2
            let imageView2 = makeImageIV(models, index: 1, radius: 10)
            addSubview(imageView2)
            imageView2.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize(width: 20, height: 20))
                make.centerY.equalTo(closeBtn)
                make.right.equalTo(closeBtn)
            }
            
            // 3
            let imageView3 = makeImageIV(models, index: 2, radius: 19)
            addSubview(imageView3)
            imageView3.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize(width: 38, height: 38))
                make.center.equalTo(closeBtn)
            }
        }
        
    }
    
    // 关闭按钮
    @objc func closeBtnHandler(){
        if let closeH = self.closeHandler {
            closeH()
        }
    }
    
    // 去开启 -> 设置页面
    @objc func openBtnHandler(){
        if let openH = self.openHandler {
            openH()
        }
    }
    
    deinit {
        print("-----deinit-----")
    }

}
