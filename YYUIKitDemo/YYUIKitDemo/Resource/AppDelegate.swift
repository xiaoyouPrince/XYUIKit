//
//  AppDelegate.swift
//  YYUIKitDemo
//
//  Created by 渠晓友 on 2024/2/4.
//

import UIKit
import XYNav
import YYUIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        makeKeyWindow()
        return true
    }
    
    func makeKeyWindow() {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.frame = UIScreen.main.bounds;
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        
        let homeVC = ViewController()
        let homeVC2 = ViewController()
        if #available(iOS 13.0, *) {
            XYNavigationController.nav_setGlobal(backBtnImage: UIImage.navBack.withRenderingMode(.alwaysTemplate), showClassNameInNavbar: true, navBarTintColor: nil)
            window?.rootViewController = XYTabBarController(tabbarContentCallbak: {
                [
                    XYTabbarContent(vc: homeVC , title: "Home", imageName: "", selectedImageName: ""),
                    XYTabbarContent(vc: homeVC2 , title: "Home2", imageName: "", selectedImageName: "")
                ]
            })
        } else {
            // Fallback on earlier versions
            window?.rootViewController = homeVC
        }
    }
    
}


