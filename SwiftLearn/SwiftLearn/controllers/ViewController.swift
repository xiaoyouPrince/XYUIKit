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
        
        return
        
        if !sender.isOn {
            
            if myTipView != nil {
                myTipView!.removeFromSuperview()
                myTipView = nil
            }
            
            if greetView != nil {
                greetView!.removeFromSuperview()
                greetView = nil
            }
            
        }else
        {
            
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
