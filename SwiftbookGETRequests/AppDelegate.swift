//
//  AppDelegate.swift
//  SwiftbookGETRequests
//
//  Created by Владимир on 06/10/2019.
//  Copyright © 2019 VladCorp. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase


let primaryColor = UIColor(red: 210/255, green: 109/255, blue: 128/255, alpha: 1)
let secondaryColor = UIColor(red: 170/255, green: 148/255, blue: 230/255, alpha: 1)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var bgSessionCompletionHandler: (() -> ())?
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        bgSessionCompletionHandler = completionHandler
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FBSDKApplicationDelegate.sharedInstance()?.application(application, didFinishLaunchingWithOptions: launchOptions)
        //ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        FirebaseApp.configure()
        return true

    }
    

        
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let appId = FBSDKSettings.appID
        //let appId = Settings.appID
        
        if url.scheme != nil && url.scheme!.hasPrefix("fb\(appId)") && url.host ==  "authorize" {
            return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        }
        return false
    }

}

