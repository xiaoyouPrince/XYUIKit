//
//  InputBarViewController.swift
//  YYUIKitDemo
//
//  Created by 渠晓友 on 2024/6/17.
//

import UIKit
import YYUIKit

class InputBarViewController: UIViewController {
    
    var kbInputView: KBTopInputView = KBTopInputView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        
        
        let textfield = UIView()
        view.addSubview(textfield)
        textfield.backgroundColor = .red
//        textfield.borderStyle = .roundedRect
        
        textfield.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textfield.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            textfield.heightAnchor.constraint(equalToConstant: 34),
            textfield.topAnchor.constraint(equalTo: view.topAnchor, constant: .height * 0.7)
        ])
        
//        KeyboardToolbarConfig.shared.showToolBar = true
        
        view.addTap {[weak self] sender in
            self?.kbInputView.show()
            _ = self?.kbInputView.becomeFirstResponder()
        }
    }
    
    
    
    deinit {
        Console.log("deinit")
    }
}
