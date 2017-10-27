//
//  Kolibri.swift
//  Kolibri
//
//  Created by Slav Sarafski on 30/8/17.
//  Copyright © 2017 Yanova. All rights reserved.
//

import UIKit

public class Kolibri: NSObject {
    
    // MARK: Share manager
    public static let shared : Kolibri = {
        let instance = Kolibri()
        
        return instance
    }()
    
    var delegate:KolibriDelegate?
    
    var tasks:[KolibriTask] = []
    static var selectedMenuItem:MenuElement?
    
    
    // Initial setup for Kolibri
    public func setup() {
        // USER AGENT
        if let standartAgent = UIWebView().stringByEvaluatingJavaScript(from: "navigator.userAgent") {
            UserDefaults.standard.register(defaults: ["UserAgent" : "Kolibri /1.0 \(standartAgent)"])
        }
        
        // Start: Register events
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.resolveActionHandler(notification:)),
                                               name: Notification.Name(NotificationName.KolibriTargetSend.rawValue),
                                               object: nil)
    }
    
    // MARK: Handle Kolibri Target Action
    @objc func resolveActionHandler(notification: NSNotification) {
        guard let menu = DataController.shared.getMenu() else {
            return
        }
        
        var url = ""
        var title = ""
        var target:MenuItem.MenuItemTargets?
        var menuItem:MenuElement? = nil
        
        // Check if MenuElement call the action
        if let item = notification.userInfo?["menuItem"] as? MenuElement {
            url = item.url ?? ""
            title = item.title ?? ""
            target = item.target
            menuItem = item
        }
        
        // Check is PushNotification call the action
        // Set the URL, Target and Title for the page
        if let item = notification.userInfo?["url"] as? String,
            let nsurl = URL(string: item) {
            
            // Check for "kolibri://navigation/path" model of url
            if (nsurl.scheme == "kolibri" || nsurl.scheme == KolibriSettings.system.scheme),
                nsurl.host == "navigation",
                nsurl.pathComponents.count > 1
            {
                let path = nsurl.pathComponents[1]
                if let localMenuItem = menu.first(where: {$0.id == path}) {
                    url = localMenuItem.url ?? ""
                    title = localMenuItem.title ?? ""
                    target = localMenuItem.target
                    menuItem = localMenuItem
                }
                if let queryItems = URLComponents(string: item)?.queryItems {
                    if let destination = queryItems.first(where: {$0.name == "url"})?.value {
                        url = destination
                        target = .TargetInternal
                    }
                }
            }
            else
                // Check for is DOMAIN the same like KolibriSettings.domain
                if nsurl.host == KolibriSettings.system.domain {
                    url = item
                    title = ""
                    target = .TargetInternal
                }
                else
                    // Check for is url is external
                    if nsurl.scheme == "http" || nsurl.scheme == "https" {
                        url = item
                        title = ""
                        target = .TargetExternal
            }
        }
        
        // Resolve the action for the Action
        if url != "" && target != nil {
            
            if target != .TargetExternal, menuItem != nil {
                Kolibri.selectedMenuItem = menuItem
            }
            
            delegate?.kolibriActionResolved(url: url, title: title, target: target, menuItem: menuItem)
        }
    }
    
    // Loading Kolibri system configurations when app EnterForeground
    func kolibriWillEnterForeground(completion: @escaping (_ error:String) -> Void = {_ in}) {
        self.loadSystemConfiguration { (error) in
            completion(error)
        }
    }
    
    // Loading Kolibri system configurations
    func loadSystemConfiguration(completion: @escaping (_ error:String) -> Void) {
        KolibriSettings.system.isSystemConfigurationLoaded = false
        KolibriAPI.shared.getSystemConfigurations { (error) in
            
            KolibriSettings.system.isSystemConfigurationLoaded = true
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
//            KolibriSettings.resolveNotificationAction = ["url": url]
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

// MARK: Kolibri Delegate
protocol KolibriDelegate {
    func kolibriActionResolved(url:String, title:String, target:MenuItem.MenuItemTargets?, menuItem:MenuElement?) ->Void
}
