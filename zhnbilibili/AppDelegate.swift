//
//  AppDelegate.swift
//  zhnbilibili
//
//  Created by zhn on 16/11/16.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit
import Kingfisher
import ReachabilitySwift

enum networkType {
    case WWAN // 2g3g
    case WIFI // wift
    case NONETWORK // 没有网络
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var netWorktype: networkType?
    let reachability = Reachability()!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // 显示FPS
        JPFPSStatus.sharedInstance().open()
        //添加观察者观察网络状态的改变
        initNetWorkObserver()
        
        return true
    }

    fileprivate func initNetWorkObserver() {
        reachability.whenReachable = { [weak self] reachability in
            DispatchQueue.main.async {
                if reachability.isReachableViaWiFi {
                    self?.netWorktype = .WIFI
                } else if reachability.isReachableViaWWAN {
                    self?.netWorktype = .WWAN
                }
            }
        }
        
        reachability.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                self.netWorktype = .NONETWORK
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

