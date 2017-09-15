//
//  Kolibri.swift
//  Kolibri
//
//  Created by Slav Sarafski on 30/8/17.
//  Copyright © 2017 Yanova. All rights reserved.
//

import UIKit

class Kolibri: NSObject {
    
    // MARK: Share manager
    static let shared : Kolibri = {
        let instance = Kolibri()
        
        return instance
    }()
    
    var tasks:[KolibriTask] = []
    
    // Initial setup for Kolibri
    func setup() {
        // USER AGENT
        if let standartAgent = UIWebView().stringByEvaluatingJavaScript(from: "navigator.userAgent") {
            UserDefaults.standard.register(defaults: ["UserAgent" : "Kolibri /1.0 \(standartAgent)"])
        }
        
        
    }
    
    func kolibriWillEnterForeground(completion: @escaping (_ error:String) -> Void = {_ in}) {
        self.loadSystemConfiguration { (error) in
            completion(error)
        }
    }
    
    func loadSystemConfiguration(completion: @escaping (_ error:String) -> Void) {
        AppSettings.system.isSystemConfigurationLoaded = false
        API.shared.getSystemConfigurations { (error) in
            
            AppSettings.system.isSystemConfigurationLoaded = true
            NotificationCenter.default.post(name: Notification.Name(NotificationName.SystemConfigurationLoaded.rawValue),
                                            object: nil)
            
            completion(error)
        }
    }
}

// Kolibri Push Notification
extension Kolibri {
    func riseTask(task:KolibriTask) {
        self.tasks.append(task)
    }
    
    func removeTask(task:KolibriTask) {
        self.tasks.remove(object: task)
    }
    
    func resolvePushTasks() -> Bool {
        var hasPushTask = false
        for task in self.tasks {
            if task is PushKolibriTask {
                task.resolveTask()
                hasPushTask = true
            }
        }
        return hasPushTask
    }
}

// Kolibri Push Notification
extension Kolibri {
    
    // Handle Push Notification from close application
    func handlePushOnLaunch(with launchOptions:[UIApplicationLaunchOptionsKey: Any]?) {
        if  let dict = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? NSDictionary,
            let url = dict["url"] as? String {
//            AppSettings.resolveNotificationAction = ["url": url]
            Kolibri.shared.riseTask(task: PushKolibriTask(url: url))
        }
    }
    
    func handlePushOnReceiveRemoteNotification(with userInfo:[AnyHashable : Any]) {
        let url = userInfo["url"] as? String ?? nil
    // iOS 10 support
        if #available(iOS 10, *) {
            if url != nil {
                self.openURLDeepLinking(url: url!)
            }
        }
    // iOS 9 support
        else {
            self.showAlertView(userInfo: userInfo, url: url)
        }
    }
    
    func showAlertView(userInfo:[AnyHashable : Any], url:String?) {
        guard let aps = userInfo[AnyHashable("aps")] as? NSDictionary else {
            return
        }
        var body = ""
        var title = ""
        
        if let alert = aps["alert"] as? NSDictionary {
            body = alert["body"] as? String ?? ""
            title = alert["title"] as? String ?? ""
        }
        if let alert = aps["alert"] as? String {
            title = alert
        }
        if title == "" {
            return
        }
        
        let alertView = UIAlertController(title: title, message: body, preferredStyle: .alert)
        if url != nil {
            alertView.addAction(UIAlertAction(title: "alert.button.cancel".localized(), style: .cancel, handler: nil))
            alertView.addAction(UIAlertAction(title: "alert.button.open".localized(), style: .default, handler:{ action in
                self.openURLDeepLinking(url: url!)
            }))
        }
        else {
            alertView.addAction(UIAlertAction(title: "navigation.ok".localized(), style: .cancel, handler: nil))
        }
        UIApplication.shared.keyWindow?.rootViewController?.present(alertView, animated: true, completion: nil)
    }
    
    func openURLDeepLinking(url:String) {
        Kolibri.shared.riseTask(task: PushKolibriTask(url: url))
    }
}

// Kolibri Support Differnt ViewConrollers Orientations
extension Kolibri {
    func supportDeviceOrientation() -> UIInterfaceOrientationMask {
        guard let window = UIApplication.shared.keyWindow else {
            return UIInterfaceOrientationMask.portrait
        }
        
        if let presentedViewController = window.rootViewController?.presentedViewController {
            let className = String(describing: type(of: presentedViewController))
            if ["MPInlineVideoFullscreenViewController", "MPMoviePlayerViewController", "AVFullScreenViewController"].contains(className)
            {
                return UIInterfaceOrientationMask.allButUpsideDown
            }
        }
        if let topViewController = (window.rootViewController as? UINavigationController)?.topViewController {
            let className = String(describing: type(of: topViewController))
            if className == "VRViewController"
            {
                return UIInterfaceOrientationMask.all
            }
        }
        return UIInterfaceOrientationMask.portrait
    }
}
