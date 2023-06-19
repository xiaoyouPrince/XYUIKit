//
//  Demo_Combine.swift
//  XYUIKitDemo
//
//  Created by 渠晓友 on 2023/2/26.
//  Copyright © 2023 XYUIKit. All rights reserved.
//
//
//  __  __          ____           _          _
//  \ \/ / /\_/\   /___ \  _   _  (_)   ___  | | __
//   \  /  \_ _/  //  / / | | | | | |  / __| | |/ /
//   /  \   / \  / \_/ /  | |_| | | | | (__  |   <
//  /_/\_\  \_/  \___,_\   \__,_| |_|  \___| |_|\_\
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

import UIKit
import Combine

@available(iOS 13.0, *)
class CombineViewController: UIViewController {
    
    let textField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(textField)
        textField.backgroundColor = .random
        textField.snp.makeConstraints { make in
            make.left.equalTo(50)
            make.right.equalTo(-50)
            make.top.equalTo(250)
            make.height.equalTo(44)
        }
        
    
        let pub = NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: textField)
        
        let sub = NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: textField)
            .sink(receiveCompletion: { print ($0) },
                  receiveValue: { print ($0) })
        
        
        let _ = Just(5)
            .map { value -> String in
                switch value {
                case _ where value < 1:
                    return "none"
                case _ where value == 1:
                    return "one"
                case _ where value == 2:
                    return "couple"
                case _ where value == 3:
                    return "few"
                case _ where value > 8:
                    return "many"
                default:
                    return "some"
                }
            }
            .sink { receivedValue in
                print("The end result was \(receivedValue)")
            }
        
    }
    
}



