//
//  FloatBallView.swift
//  YYUIKitDemo
//
//  Created by 渠晓友 on 2024/2/23.
//

import SwiftUI
import YYUIKit
import YYImage

extension View {
    var viewController: UIViewController {
        UIViewController.currentVisibleVC
    }
}

struct FloatBallView: View {
    var body: some View {
        List {
            Section {
                Button("展示全局悬浮球") {
                    XYDebugView.show(viewController)
                }
                
                Button("首页悬浮球") {
                    XYDebugView.show(forScene: "首页小⚽️", with: viewController)
                }
                
                Button("自定义Vip小球") {
                    XYDebugView.show(forScene: "VIP 小球", with: viewController)
                }
            }
            
            Section {
                Button("关闭全局悬浮球") {
                    XYDebugView.dismiss()
                }
                
                Button("关闭首页悬浮球") {
                    XYDebugView.dismiss(forScene: "首页小⚽️")
                }
                
                Button("关闭自定义Vip小球") {
                    XYDebugView.dismiss(forScene: "VIP 小球")
                }
                
                Button("关闭所有小球") {
                    XYDebugView.dismissAll()
                }
            }
        }
    }
}

extension UIViewController: XYDebugViewProtocol{
    public func didClickDebugview() {
        // Toast.make("Xbug按钮点击, 这里来实现自己自定义的处理吧")
        // 此方法,没有返回足够信息,可供全局小球使用
    }
    
    public func didClickDebugview(debugView: XYDebugView, inBounds: CGRect) {
        Toast.make("\(debugView.currenKey) 被点击了")
    }
    
    public func willShowDebugView(debugView: XYDebugView, inBounds: CGRect) {
        if debugView.currenKey == "首页小⚽️"{
            
            view.addSubview(debugView)
            
            let origialWH: CGFloat = 100
            debugView.frame = .init(x: .width - origialWH, y: .height - 500, width: origialWH, height: origialWH)
            debugView.corner(radius: origialWH / 2)
            
            let imageV = YYAnimatedImageView()
            imageV.frame = debugView.bounds
            imageV.image = YYImage(named: "2")
            debugView.addSubview(imageV)
            
        }else if debugView.currenKey == "VIP 小球"{
            
            view.addSubview(debugView)
            
            let origialWH: CGFloat = 80
            debugView.frame = .init(x: .width - origialWH, y: .height - 400, width: origialWH, height: origialWH)
            debugView.corner(radius: origialWH / 2)
            
            let imageV = YYAnimatedImageView()
            imageV.frame = debugView.bounds
            imageV.image = YYImage(named: "1")
            debugView.addSubview(imageV)
            
        }else{
            let origialWH: CGFloat = 100
            
            debugView.frame = .init(x: .width - origialWH, y: .height - 300, width: origialWH, height: origialWH)
            debugView.corner(radius: origialWH / 2)
            
            let imageV = YYAnimatedImageView()
            imageV.frame = debugView.bounds
            imageV.image = YYImage(named: "3")
            debugView.addSubview(imageV)
        }
    }
}

#Preview {
    FloatBallView()
}


