//
//  AppDelegate.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2020/12/10.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        UINavigationBar.appearance().tintColor = .red
//        UINavigationBar.appearance().barTintColor = .cyan
//        UINavigationBar.appearance().isTranslucent = false
//        UINavigationBar.appearance().shadowImage = UIImage(named: "im_list_newgreet_bg")
        
    
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(noti), name: NSNotification.Name(rawValue: "noti"), object: nil)
        
        print("和红烧豆ios腐(RPO)".unicodeScalars.count)
        
        let str = "和红烧豆ios腐(RPO)" as NSString
        print(str.substring(to: 4))
        
#if DEBUG
    Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")?.load()
    //for tvOS:
//    Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/tvOSInjection.bundle")?.load()
//    //Or for macOS:
//    Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/macOSInjection.bundle")?.load()
#endif
        
        return true
    }
    
    
    @objc func noti() {
        
        
        UIApplication.shared.keyWindow?.rootViewController = UIStoryboard.instantiateInitialViewController(UIStoryboard.init(name: "Main", bundle: .main))()
        
    }

//    // MARK: UISceneSession Lifecycle
//
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }


}

