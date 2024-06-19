//
//  KeyboardMonitor&InPutBar.swift
//  YYUIKitDemo
//
//  Created by 渠晓友 on 2024/6/13.
//

import SwiftUI
import YYUIKit

struct KeyboardMonitor_InPutBar: View {
    
//    @State var text: String = ""
//    var keyboardMonitor: KeyboardMonitor! = .init()
//    var toolBar: EmptyView = .init()
    
    @ObservedObject private var keyboardResponder = KeyboardResponder()
    @State private var text: String = ""
    
    var kbInputView: KBTopInputView = KBTopInputView()
    
    var body: some View {
        VStack {
            VStack {
                Text("input text")
                Text(text)
            }.background(Color.green)
                .frame(width: .width)
            
            Text("click me")
                .padding()
                .onTapGesture {
                    
                    kbInputView.show()
                    _ = kbInputView.becomeFirstResponder()
                    kbInputView.updateText(text)
                    kbInputView.textChangeCallback = { text in
                        self.text = text
                    }
                    
                }
        }.onAppear {
            
            Runlooper.startLoop(forKey: "asb", interval: 0.99, loopCount: 10) { currentCount in
                text = "\(currentCount)"
            }
        }
    }
    
    var body3: some View {
        VStack {
            VStack {
                Spacer()
                
                TextField("Enter text here", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Text("You entered: \(text)")
                    .padding()
            }
            .padding(.bottom, keyboardResponder.currentHeight)
            .animation(.easeOut(duration: 0.16))
        }
        .onAppear {
            KeyboardToolbarConfig.shared.showToolBar = true
            return;
        }
    }
    
//    var body2: some View {
//        
//        
//        ScrollView(.vertical) {
//            Text("本页面会创建一个键盘监听和输入框")
//            Text("本页面会创建一个键盘监听和输入框")
//            Text("本页面会创建一个键盘监听和输入框")
//            Text("本页面会创建一个键盘监听和输入框")
//            Text("本页面会创建一个键盘监听和输入框")
//            Text("本页面会创建一个键盘监听和输入框")
//            Text("本页面会创建一个键盘监听和输入框")
//            Text("本页面会创建一个键盘监听和输入框")
//            Text("本页面会创建一个键盘监听和输入框")
//            Text("本页面会创建一个键盘监听和输入框")
//            Text("本页面会创建一个键盘监听和输入框")
//            Text("本页面会创建一个键盘监听和输入框")
//            Text("本页面会创建一个键盘监听和输入框")
//            Text("本页面会创建一个键盘监听和输入框")
//            Text("本页面会创建一个键盘监听和输入框")
//            Text("本页面会创建一个键盘监听和输入框")
//            Text("本页面会创建一个键盘监听和输入框")
//            Text("本页面会创建一个键盘监听和输入框")
//            Text("本页面会创建一个键盘监听和输入框")
//            Text("本页面会创建一个键盘监听和输入框")
//            
//            TextField("请输入内容", text: $text)
//                .textFieldStyle(.roundedBorder)
//                .padding()
//                .foregroundColor(.green)
//            
//            
//        }
//        .onAppear {
//            KeyboardToolbarConfig.shared.showToolBar = true
//            return;
//        }
//        
//    }
}

#Preview {
    KeyboardMonitor_InPutBar()
}

import UIKit

class KBToolBar: UIView {
    private let button = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContent() {
        addSubview(button)

        button.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        button.addTap { sender in
            sender.window?.rootViewController?.view.endEditing(true)
        }
    }
}

import SwiftUI
import Combine

class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0
    private var cancellable: AnyCancellable?
    
    init() {
        cancellable = NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
            .merge(with: NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification))
            .compactMap { notification in
                guard let userInfo = notification.userInfo else { return nil }
                return (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height
            }
            .map { height in
                height == UIScreen.main.bounds.height ? 0 : height
            }
            .assign(to: \.currentHeight, on: self)
    }
}


import SwiftUI

struct KeyboardAvoidanceWrapper<Content: View>: UIViewControllerRepresentable {
    var content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = KeyboardAvoidanceViewController()
        let hostingController = UIHostingController(rootView: content)
        
        viewController.addChild(hostingController)
        viewController.view.addSubview(hostingController.view)
        hostingController.didMove(toParent: viewController)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: viewController.view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor)
        ])
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No update needed
    }
}

class KeyboardAvoidanceViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            self.additionalSafeAreaInsets.bottom = keyboardFrame.height
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        self.additionalSafeAreaInsets.bottom = 0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
