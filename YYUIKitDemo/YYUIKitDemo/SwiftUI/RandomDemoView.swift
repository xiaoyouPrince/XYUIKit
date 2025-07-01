//
//  RandomDemoView.swift
//  YYUIKitDemo
//
//  Created by 渠晓友 on 2025/6/25.
//

/*
 这是一个随机辅助写 Demo 页面, 比如开发过程中快速写个小原型
 这个随时写,随时删
 */

import SwiftUI
import YYUIKit

struct RandomDemoView: View {
    var body: some View {
        ZStack {
//            Color.black.opacity(0.4)
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .onTapGesture {
                    NewUserPriviligeAlertView.showNewUserPriviligeAlert {
                        Toast.make("用户同意")
                    }
                }
        }
    }
    

}

#Preview {
    RandomDemoView()
}


extension NewUserPriviligeAlertView {
    /// 展示新用户特权弹框
    static func showNewUserPriviligeAlert(onConfirm: @escaping ()->()) {
        let hostVC = UIHostingController(rootView: NewUserPriviligeAlertView(onCancel: {
            XYAlert.dismiss()
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
            bgView.backgroundColor = .black.withAlphaComponent(0.3)
            bgView.insertSubview(bgImage, at: 0)
            bgImage.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }))
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
                        .onTapGesture {
                            onCancel()
                        }
                        .offset(y: 20)
                }.overlay {
                    ZStack {
                        VStack(spacing: 24) {
                            
                            Text("恭喜您获得")
                                .font(.system(size: 24))
                                .kerning(3)
                                .foregroundStyle(Color(UIColor.xy_getColor(hex: 0xe0945a)))
                            
                            Text("免广告特权")
                                .font(.system(size: 36, weight: .black))
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
                                            .font(.system(size: 27, weight: .black))
                                            .foregroundStyle(Color.white)
                                    }
                                }
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
                                .font(.system(size: 16))
                                .kerning(2)
                                .foregroundStyle(Color(UIColor.xy_getColor(hex: 0xe0945a)))
                            
                            Text("免广告特权")
                                .font(.system(size: 24, weight: .black))
                                .kerning(2)
                                .foregroundStyle(Color(UIColor.xy_getColor(hex: 0x4A290A)))
                            
                            Image(uiImage: .newUserPriviligeAlertButton)
                                .onTapGesture {
                                    onConfirm()
                                }
                                .overlay {
                                    HStack {
                                        Image(uiImage: .newUserPriviligeAlertVideoStart)
                                        
                                        Text("立即领取")
                                            .font(.system(size: 18, weight: .black))
                                            .foregroundStyle(Color.white)
                                    }
                                }
                                .padding(.top, 16)
                        }.padding(.top, 150)
                    }
                }
                .padding(.bottom, 100)
            }
        }.ignoresSafeArea()
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
