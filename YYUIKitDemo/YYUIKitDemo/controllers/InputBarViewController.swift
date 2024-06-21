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
    
    private var networkReachability = NetworkReachability.shared

//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.backgroundColor = .white
//        
//        networkReachability.startMonitoring()
//        
//        
//        
//        let textfield = UIView()
//        view.addSubview(textfield)
//        textfield.backgroundColor = .red
////        textfield.borderStyle = .roundedRect
//        
//        textfield.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            textfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            textfield.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
//            textfield.heightAnchor.constraint(equalToConstant: 34),
//            textfield.topAnchor.constraint(equalTo: view.topAnchor, constant: .height * 0.7)
//        ])
//        
////        KeyboardToolbarConfig.shared.showToolBar = true
//        
//        view.addTap {[weak self] sender in
//            self?.kbInputView.show()
//            _ = self?.kbInputView.becomeFirstResponder()
//        }
//    }
    
    
    
    deinit {
        Console.log("deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkReachability.startMonitoring()
        setupUI()
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
            self?.kbInputView.setShowAnchorView(textfield, callabck: {[weak self] transY in
                print(transY)
                self?.view.transform = CGAffineTransform(translationX: 0, y: -transY)
            })
            self?.kbInputView.textEndEditingCallback = {
                self?.view.transform = .identity
            }
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        networkReachability.stopMonitoring()
    }
    
    private func setupUI() {
        let statusLabel = UILabel()
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        updateStatusLabel(statusLabel)
        
        NotificationCenter.default.addObserver(forName: .reachabilityChanged, object: nil, queue: .main) { [weak self] _ in
            self?.updateStatusLabel(statusLabel)
        }
    }
    
    private func updateStatusLabel(_ label: UILabel) {
        label.text = networkReachability.isConnected ? "Connected (\(networkReachability.connectionType))" : "Not Connected"
    }
}
