//
//  NewUserPriviligeAlertView.swift
//  YYUIKitDemo
//
//  Created by 渠晓友 on 2025/7/2.
//

import SwiftUI
import YYUIKit

extension NewUserPriviligeAlertView {
    /// 展示新用户特权弹框
    static func showNewUserPriviligeAlert(onConfirm: @escaping ()->(), onDismiss:@escaping () -> ()) {
        let hostVC = UIHostingController(rootView: NewUserPriviligeAlertView(onCancel: {
            XYAlert.dismiss()
            onDismiss()
        }, onConfirm: {
            XYAlert.dismiss()
            onConfirm()
        }))
        hostVC.loadViewIfNeeded()
        hostVC.view.backgroundColor = .clear
        hostVC.view.snp.makeConstraints { make in
            if UIDevice.current.userInterfaceIdiom == .pad {
                make.width.equalTo(562)
                make.height.equalTo(571 + 160)
            } else {
                make.width.equalTo(375)
                make.height.equalTo(381 + 100)
            }
        }
        
        XYAlert.showCustom(hostVC.view, with: .init(dismissOnTapBackground: false, startTransaction: { bgView in
            var bgImage = UIImageView(image: UIImage.newUserPriviligeBg)
            if UIDevice.current.userInterfaceIdiom == .pad {
                bgImage = UIImageView(image: UIImage.newUserPriviligeBgPad)
            }
            bgView.backgroundColor = .black.withAlphaComponent(0.7)
            bgView.insertSubview(bgImage, at: 0)
            bgImage.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            hostVC.view.transform = hostVC.view.transform.scaledBy(x: 0.85, y: 0.85)
        }
        
    }
}

struct NewUserPriviligeAlertView: View {
    
    /// 取消 / 关闭
    var onCancel: () -> ()
    /// 同意 / 立即领取
    var onConfirm: () -> ()
    
    var body: some View {
        GeometryReader { geo in
            if UIDevice.current.userInterfaceIdiom == .pad {
                body_pad
            } else {
                body_phone
            }
        }
    }
    
    var body_pad: some View {
        GeometryReader { geo in
            ZStack {
                VStack {
                    if Locale.current.identifier == "zh-Hant_CN" {
                        Image(uiImage: .newUserPriviligeAlertBgPadTraditional)
                    } else {
                        Image(uiImage: .newUserPriviligeAlertBgPad)
                    }
                    
                    Image(uiImage: .newUserPriviligeClose)
                        .resizable()
                        .frame(width: UIImage.newUserPriviligeClose.size.width * 1.2, height: UIImage.newUserPriviligeClose.size.height * 1.2, alignment: .center)
                        .onTapGesture {
                            onCancel()
                        }
                        .offset(y: 20)
                }.overlay {
                    ZStack {
                        VStack(spacing: 24) {
                            
                            Text("恭喜您获得")
                                .font(.system(size: 24.scale))
                                .kerning(3)
                                .foregroundStyle(Color(UIColor.xy_getColor(hex: 0xe0945a)))
                            
                            Text("免广告特权")
                                .font(.system(size: 36.scale, weight: .medium))
                                .kerning(3)
                                .foregroundStyle(Color(UIColor.xy_getColor(hex: 0x4A290A)))
                            
                            Image(uiImage: .newUserPriviligeAlertButtonPad)
                                .onTapGesture {
                                    onConfirm()
                                }
                                .overlay {
                                    HStack {
                                        Image(uiImage: .newUserPriviligeAlertVideoStartPad)
                                        
                                        Text("立即领取")
                                            .font(.system(size: 27.scale, weight: .medium))
                                            .foregroundStyle(Color.white)
                                    }
                                }
                                .breathingEffect(scale: 0.95, duration: 0.75)
                                .padding(.top, 20)
                        }.padding(.top, 220)
                    }
                }
                .padding(.bottom, 100)
            }
        }.ignoresSafeArea()
    }
    
    var body_phone: some View {
        GeometryReader { geo in
            ZStack {
                VStack {
                    //Image("monthlyVip_bg\(Locale.current.identifier == "zh-Hant_CN" ? "Traditional" : "")")
                    if Locale.current.identifier == "zh-Hant_CN" {
                        Image(uiImage: .newUserPriviligeAlertBgTraditional)
                    } else {
                        Image(uiImage: .newUserPriviligeAlertBg)
                    }
                    
                    Image(uiImage: .newUserPriviligeClose)
                        .onTapGesture {
                            onCancel()
                        }
                        .offset(y: 20)
                }.overlay {
                    ZStack {
                        VStack(spacing: 16) {
                            
                            Text("恭喜您获得")
                                .font(.system(size: 16.scale))
                                .kerning(2)
                                .foregroundStyle(Color(UIColor.xy_getColor(hex: 0xe0945a)))
                            
                            Text("免广告特权")
                                .font(.system(size: 24.scale, weight: .medium))
                                .kerning(2)
                                .foregroundStyle(Color(UIColor.xy_getColor(hex: 0x4A290A)))
                            
                            Image(uiImage: .newUserPriviligeAlertButton)
                                .onTapGesture {
                                    onConfirm()
                                }
                                .overlay {
                                    HStack(spacing: 5) {
                                        Image(uiImage: .newUserPriviligeAlertVideoStart)
                                        
                                        Text("立即领取")
                                            .font(.system(size: 16.scale, weight: .medium))
                                            .foregroundStyle(Color.white)
                                    }
                                }
                                .breathingEffect(scale: 0.95, duration: 0.75)
                                .padding(.top, 13)
                        }.padding(.top, 145)
                    }
                }
                .padding(.bottom, 100)
            }
        }.ignoresSafeArea()
    }
}

struct BreathingModifier: ViewModifier {
    let scaleFactor: CGFloat
    let duration: Double
    
    @State private var isBreathing = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isBreathing ? scaleFactor : 1.0)
            .animation(
                Animation.easeInOut(duration: duration)
                    .repeatForever(autoreverses: true),
                value: isBreathing
            )
            .onAppear {
                isBreathing = true
            }
    }
}

extension View {
    func breathingEffect(scale: CGFloat = 1.1, duration: Double = 2.0) -> some View {
        self.modifier(BreathingModifier(scaleFactor: scale, duration: duration))
    }
}

#Preview {
    NewUserPriviligeAlertView(onCancel: {
        XYAlert.dismiss()
    }, onConfirm: {
        Toast.make("用户同意")
        XYAlert.dismiss()
    })
}

/*
 NewUserPriviligeAlertView.showNewUserPriviligeAlert {
     Toast.make("用户同意")
 } onDismiss: {
     Toast.make("用户取消")
 }
 */
