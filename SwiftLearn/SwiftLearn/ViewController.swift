//
//  ViewController.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2020/12/10.
//

import UIKit

class ViewController: UIViewController {
    
    
    var greetView: ZLNewGreetingView?
    var myTipView: ZLPushNotificationTipView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func gotoTableVC(_ sender: Any) {
        
        self.present(TableViewController(), animated: true, completion: nil)
        
    }
    
    @IBAction func switchEventHandle(_ sender: UISwitch) {
        
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

