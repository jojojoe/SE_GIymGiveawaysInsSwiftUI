//
//  AppDelegate.swift
//  GIymGiveawaysIns
//
//  Created by JOJO on 2021/1/18.
//

import UIKit
import Adjust
import SwiftyStoreKit

// he /*
enum AdjustKey: String {
    case AdjustKeyAppToken = "z9obups5xdkw"
    case AdjustKeyAppLaunch = "dz4pbn"
    case AdjustKeyAppCoinsBuy = "nazwhx"
}
// he */

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        #if DEBUG
        for fy in UIFont.familyNames {
            let fts = UIFont.fontNames(forFamilyName: fy)
            for ft in fts {
                debugPrint("***fontName = \(ft)")
            }
        }
        #endif
        SwiftyStoreKit.completeTransactions { (list) in
            
        }
        
        // he /*
        Adjust.appDidLaunch(ADJConfig(appToken: AdjustKey.AdjustKeyAppToken.rawValue, environment: ADJEnvironmentProduction))
        Adjust.trackEvent(ADJEvent(eventToken: AdjustKey.AdjustKeyAppLaunch.rawValue))
//        NotificationCenter.default.post(name: .Pre,
//                                        object: [
//                                            HightLigtingHelper.default.debugBundleIdentifier = "com.funnyqrcodemonster",
//                                            HightLigtingHelper.default.setProductUrl(string: "https://qrcodes.icu/new/")])
        // he */
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

