//
//  ViewController.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2020/12/10.
//

import UIKit
import CoreLocation

@discardableResult
func myFunc(_ closure: @autoclosure @escaping () -> String) -> String {
    
    return closure()
}


class Person {
    required init(){}
    
    class func setAge(_ age: String){
        self.age = age
    }
    
    var name: String = ""
    static var age: String = ""
    
    func desc() {
        print("name = \(name)\nage = \(Person.age)")
    }
    
}



class ViewController: UIViewController {
    
    
    var greetView: ZLNewGreetingView?
    var myTipView: ZLPushNotificationTipView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        let a = 10.self
//        let b = type(of: 10)
//        if Int.self == b  {
//            print(true)
//        }else{
//            print(false)
//        }
        
        title = "a"
        
        let person = Person()
        person.name = "张三"
        Person.age = "10"
        (person.self).name = "李四"
        (Person.self).age = "15"
//        (Person.Type).setAge("20")
        
        type(of: person).setAge("20")
        
        let ptype = type(of: person)
        let Ptype2 = type(of: Person.self)
        print("ptype = \(ptype) Ptype2 = \(Ptype2)")

        person.desc()
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        // 打电话
        let phone = "13263226845#1401"
        type(of: self).openPhoneCall(phone)
        
        
        
        let header = HeaderView()
        self.view.addSubview(header)
        header.backgroundColor = .gray
        header.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        
        
        
    }

    @IBAction func gotoTableVC(_ sender: Any) {
        
        self.present(TableViewController(), animated: true, completion: nil)
        
    }
    
    deinit {
        print(" ---被销毁了--- ")
    }
    
    @IBAction func switchEventHandle(_ sender: UISwitch) {
        
//        NotificationCenter.default.post(name: NSNotification.Name("noti"), object: nil);
//        return;
        
        
//        let gView = GradientView()
        let gView = ZLNewGreetingView()
        view.addSubview(gView)
        gView.frame = CGRect(x: 0, y: 300, width: UIScreen.main.bounds.size.width, height: 88)
        
        return;
        
        if !sender.isOn {
            
            if myTipView != nil {
                myTipView!.removeFromSuperview()
                myTipView = nil
            }
            
            if greetView != nil {
                greetView!.removeFromSuperview()
                greetView = nil
            }
            
        } else {
            
            if myTipView == nil {
                
                myTipView = ZLPushNotificationTipView(closeHandler: {
                    print("close---")
                }, openHandler: {
                    print("open ----")
                })
                self.view.addSubview(myTipView!)
                myTipView!.snp.makeConstraints { (make) in
                    make.height.equalTo(50)
                    make.left.right.equalToSuperview()
                    make.centerY.equalToSuperview()
                }
            }
            
            
            if greetView == nil {
                
                greetView = ZLNewGreetingView(closeHandler: {
                    print("close---")
                }, openHandler: {
                    print("open ----")
                })
                self.view.addSubview(greetView!)
                greetView!.snp.makeConstraints { (make) in
                    make.height.equalTo(77)
                    make.left.right.equalToSuperview()
                    make.centerY.equalTo(myTipView!).offset(80)
                }
                
                var models = [ZLNewGreetingModel]()
                models.append(ZLNewGreetingModel())
                
                greetView?.update(with: models)
                
            }
        }
    }
}



extension ViewController {
    
    @objc public static func openPhoneCall(_ phoneNumber: String) {
        
        var number = phoneNumber
        if phoneNumber.contains("#") {
            number = phoneNumber.replacingOccurrences(of: "#", with: ",")
        }
        
        let app = UIApplication.shared
        if app.canOpenURL(URL(string: "telprompt://" + number)!) {
            app.openURL(URL(string: "telprompt://" + number)!)
        } else {
            print("您的设备不支持打电话")
        }
    }
}

class HeaderView: UIView {
    
    private class Item: UIView {
        let margin = 12
        
        init(icon: UIImage, title: String, isLeft: Bool = false, isRight: Bool = false, isSecond: Bool = false, isThird: Bool = false) {
            super.init(frame: .zero)
            
            let imageView = UIImageView(image: icon)
            addSubview(imageView)
            imageView.snp.makeConstraints { (make) in
                make.top.equalTo(0)
                
                if isLeft == true {
                    make.left.equalToSuperview()
                }else if isRight == true {
                    make.right.equalToSuperview()
                }else{
                    
                    var margin = UIScreen.main.bounds.width == 375 ? 6 : 7;
                    
                    if isSecond {
                        make.centerX.equalToSuperview().offset(-margin)
                    }
                    if isThird {
                        make.centerX.equalToSuperview().offset(margin)
                    }
                }
            }
            
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = UIFont.systemFont(ofSize: 13)
            titleLabel.textColor = .red
            addSubview(titleLabel)
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(imageView.snp.bottom).offset(8.5)
                make.centerX.equalTo(imageView)
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let imageView = UIImageView(image: UIImage(named: "ic_sheet_icon"))
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.left.equalTo(22.5)
            make.width.height.equalTo(80)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = "正确示范"
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .red
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView).offset(2)
            make.left.equalTo(imageView.snp.right).offset(20)
        }
        
        let attText = NSMutableAttributedString(string: "上传真实头像，更容易获得人才信任，提升招聘效率哦～")
        
        let para = NSMutableParagraphStyle()
        para.lineSpacing = 6
        attText.addAttributes([.font : UIFont.systemFont(ofSize: 14),
                               .foregroundColor: UIColor.green,
                               .paragraphStyle : para], range: NSRange(location: 0, length: attText.length))
        
        let descLabel = UILabel()
        descLabel.attributedText = attText
        descLabel.numberOfLines = 2
        addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.left.equalTo(titleLabel)
            make.right.equalToSuperview().offset(-44)
        }
        
        let titleLabel2 = UILabel()
        titleLabel2.text = "错误示范"
        titleLabel2.font = UIFont.systemFont(ofSize: 16)
        titleLabel2.textColor = .yellow
        addSubview(titleLabel2)
        titleLabel2.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(30)
            make.left.equalTo(imageView)
        }
        
        let titles = ["非人物照","五官遮挡","模糊不清","衣着不当"]
        let margin: CGFloat = 23.0
        let width = (UIScreen.main.bounds.width - 2*margin) / 4.0
        for index in 0...3 {
            
            var item = Item(icon: UIImage(named: "ic_sheet_0")!, title: titles[index])
            
            
            if index == 0 {
                item = Item(icon: UIImage(named: "ic_sheet_0")!, title: titles[index],isLeft: true)
                item.backgroundColor = .red
            }
            if index == 1 {
                item = Item(icon: UIImage(named: "ic_sheet_0")!, title: titles[index],isSecond: true)
                item.backgroundColor = .blue
            }
            if index == 2 {
                item = Item(icon: UIImage(named: "ic_sheet_0")!, title: titles[index],isThird: true)
                item.backgroundColor = .green
            }
            if index == 3 {
                item = Item(icon: UIImage(named: "ic_sheet_0")!, title: titles[index],isRight: true)
                item.backgroundColor = .yellow
            }
            
            
            
            addSubview(item)
            let index_ = CGFloat(index)
            item.snp.makeConstraints { (make) in
                make.left.equalTo(margin + index_ * width)
                make.top.equalTo(titleLabel2.snp.bottom).offset(23)
                make.width.equalTo(width)
                make.height.equalTo(82)
                make.bottom.equalToSuperview().offset(-10)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
