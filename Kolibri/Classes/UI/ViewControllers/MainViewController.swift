//
//  MainViewController.swift
//  Kolibri
//
//  Created by Slav Sarafski on 13/2/17.
//  Copyright © 2017 Yanova. All rights reserved.
//

import UIKit
import SDWebImage
import SideMenu

class MainViewController: UIViewController {
    
    static var share:MainViewController!
    
    var webView: KolibriWebView!
    
    var loadingAlert:UIAlertController?
    
//    static var selectedMenuItem:MenuElement?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MainViewController.share = self
        
        
//        // Start: Register events
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(self.resolveActionHandler(notification:)),
//                                               name: Notification.Name(NotificationName.KolibriTargetSend.rawValue),
//                                               object: nil)
        // Set Kolibri delegate
        Kolibri.shared.delegate = self
        
        // START: Favorite stuff
        
        // END: Favorite stuff
        
        // START: Search stuff
        
        // END: Search stuff
        // End: Register events
        
        self.automaticallyAdjustsScrollViewInsets = true
        self.webView = KolibriWebView()
        self.view.addSubview(self.webView)
        
        self.webView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(0)
        }
        
        SideMenuManager.menuPushStyle = .defaultBehavior
        SideMenuManager.menuPresentMode = .menuSlideIn
        SideMenuManager.menuFadeStatusBar = false
        SideMenuManager.menuWidth = UIScreen.main.bounds.width*0.85
        
        let fontDictionary = [ NSAttributedStringKey.foregroundColor: KolibriSettings.style.navigationBarItemTint,
                               NSAttributedStringKey.font: UIFont.boldFont(size: 20) ]
        self.navigationController?.navigationBar.titleTextAttributes = fontDictionary
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = KolibriSettings.style.navigationBarItemTint
        self.navigationController?.navigationBar.barTintColor = KolibriSettings.style.navigationBarBackground
        
        self.setHomeButton()
        
        // Handle push notification, when app has not been started
        if !Kolibri.shared.resolvePushTasks() {
            self.setDefautItem()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.webView.handleTheme()
        NotificationCenter.default.post(name: Notification.Name(NotificationName.MainViewControllerWillAppear.rawValue),
                                        object: nil,
                                        userInfo: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // START: Search stuff
        
        // END: Search stuff
        NotificationCenter.default.post(name: Notification.Name(NotificationName.MainViewControllerDidAppear.rawValue),
                                        object: nil,
                                        userInfo: nil)
        
        self.webView.reload()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: Notification.Name(NotificationName.MainViewControllerWillDisappear.rawValue),
                                        object: nil,
                                        userInfo: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: Notification.Name(NotificationName.MainViewControllerDidDisappear.rawValue),
                                        object: nil,
                                        userInfo: nil)
    }
    
    func setDefautItem() {
        if let menu = DataController.shared.getMenu() {
            for item in menu {
                if item.isDefault && Kolibri.selectedMenuItem?.id != item.id {
                    MainViewController.selectMenuItem(item: item)
                    break
                }
            }
        }
    }
    
    // MARK: MenuItem select
    static func selectMenuItem(item:MenuElement) {
        let infoDict:[String: MenuElement] = ["menuItem": item]
        NotificationCenter.default.post(name: Notification.Name(NotificationName.KolibriTargetSend.rawValue),
                                        object: nil,
                                        userInfo: infoDict)
    }
    
    // MARK: Menu
    @objc func showMenu() {
        self.performSegue(withIdentifier: "menuSeque", sender: nil)
    }
    
//    // MARK: Handle Kolibri Target Action
//    @objc func resolveActionHandler(notification: NSNotification) {
//        NotificationCenter.default.post(name: Notification.Name(NotificationName.PageWillChanged.rawValue),
//                                        object: nil,
//                                        userInfo: notification.userInfo)
//        
//        guard let menu = DataController.shared.getMenu() else {
//            return
//        }
//        
//        var url = ""
//        var title = ""
//        var target:MenuItem.MenuItemTargets?
//        var menuItem:MenuElement? = nil
//        
//        // Check if MenuElement call the action
//        if let item = notification.userInfo?["menuItem"] as? MenuElement {
//            url = item.url ?? ""
//            title = item.title ?? ""
//            target = item.target
//            menuItem = item
//        }
//        
//        // Check is PushNotification call the action
//        // Set the URL, Target and Title for the page
//        if let item = notification.userInfo?["url"] as? String,
//            let nsurl = URL(string: item) {
//            
//            // Check for "kolibri://navigation/path" model of url
//            if (nsurl.scheme == "kolibri" || nsurl.scheme == KolibriSettings.system.scheme),
//                nsurl.host == "navigation",
//                nsurl.pathComponents.count > 1
//            {
//                let path = nsurl.pathComponents[1]
//                if let localMenuItem = menu.first(where: {$0.id == path}) {
//                    url = localMenuItem.url ?? ""
//                    title = localMenuItem.title ?? ""
//                    target = localMenuItem.target
//                    menuItem = localMenuItem
//                }
//                if let queryItems = URLComponents(string: item)?.queryItems {
//                    if let destination = queryItems.first(where: {$0.name == "url"})?.value {
//                        url = destination
//                        target = .TargetInternal
//                    }
//                }
//            }
//            else
//                // Check for is DOMAIN the same like KolibriSettings.domain
//                if nsurl.host == KolibriSettings.system.domain {
//                    url = item
//                    title = ""
//                    target = .TargetInternal
//                }
//                else
//                    // Check for is url is external
//                    if nsurl.scheme == "http" || nsurl.scheme == "https" {
//                        url = item
//                        title = ""
//                        target = .TargetExternal
//            }
//        }
//        
//        // Resolve the action for the Action
//        if url != "" && target != nil {
//            
//            if target != .TargetExternal, menuItem != nil {
//                MainViewController.selectedMenuItem = menuItem
//            }
//            
//            switch target! {
//            // Open the URL in current page
//            case .TargetSelf:
//                self.navigationController?.popToRootViewController(animated: false)
//                self.title = title
//                self.webView.loggedTitle = title
//                self.webView.load(url: url)
//                break
//            // Open the URL in internal page
//            case .TargetInternal:
//                self.navigationController?.popToRootViewController(animated: false)
//                if menuItem != nil {
//                    self.title = title
//                    self.webView.loggedTitle = title
//                    self.webView.load(url: menuItem?.url ?? "")
//                }
//                self.webView.openKolibriWebViewController(url: url)
//                break
//            // Open the URL in Safarai Browser
//            case .TargetExternal:
//                self.openExternalURL(url: url)
//                break
//            // Open VRController
//            case .VRController:
//                KolibriAnalytics.logEvent(url: url, title: title)
//                self.openVRViewController(url: url)
//                break
//            // Open Custom Controller (eg. Favorites)
//            case .TargetController:
//                KolibriAnalytics.logEvent(url: url, title: title)
//                self.openController(menuItem: menuItem!)
//                break
//            }
//        }
//        
//        NotificationCenter.default.post(name: Notification.Name(NotificationName.PageDidChanged.rawValue),
//                                        object: nil,
//                                        userInfo: notification.userInfo)
//    }
    
    
    // Hande custom Controllers
    func openController(menuItem:MenuElement) {
        NotificationCenter.default.post(name: Notification.Name(NotificationName.ControllerDidOpened.rawValue),
                                        object: nil,
                                        userInfo: ["controller":menuItem])
        
        var isFindController:Bool = false
        
        if menuItem.id == "push_config" {
            self.performSegue(withIdentifier: "pushSeque", sender: nil)
            isFindController = true
        }
        
        // START: Favorite stuff
        
        // END: Favorite stuff
        
        // START: Search stuff
        
        // END: Search stuff
        
        // START: End App stuff
        if menuItem.url == "kolibri://navigation/pregnancycalendar" ||
            menuItem.url == "\(KolibriSettings.system.scheme)://navigation/pregnancycalendar" {
            let storyboard = UIStoryboard(name: "CalendarStoryboard", bundle: nil)
            let calendarController = storyboard.instantiateViewController(withIdentifier: "calendarViewController")
            calendarController.title = menuItem.title
            self.navigationController?.pushViewController(calendarController, animated: false)
            isFindController = true
        }
        // END: End App stuff
        
        // Rise an alert with missing components and need of update
        if !isFindController {
            let alert = UIAlertController(title: "alert.menu.controller.miss".localized(), message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "navigation.ok".localized(), style: .cancel, handler: nil))
            self.present(alert, animated: false, completion: nil)
        }
    }
    
    func openVRViewController (url:String) {
        let vr = VRViewController()
        vr.urlString = url
        self.navigationController?.pushViewController(vr, animated: true)
    }
    
    // Statusbar visibility
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
}

extension MainViewController:KolibriDelegate {
    func kolibriActionResolved(url: String, title: String, target: MenuItem.MenuItemTargets?, menuItem: MenuElement?) {
        switch target! {
        // Open the URL in current page
        case .TargetSelf:
            self.navigationController?.popToRootViewController(animated: false)
            self.title = title
            self.webView.loggedTitle = title
            self.webView.load(url: url)
            break
        // Open the URL in internal page
        case .TargetInternal:
            self.navigationController?.popToRootViewController(animated: false)
            if menuItem != nil {
                self.title = title
                self.webView.loggedTitle = title
                self.webView.load(url: menuItem?.url ?? "")
            }
            self.webView.openKolibriWebViewController(url: url)
            break
        // Open the URL in Safarai Browser
        case .TargetExternal:
            self.openExternalURL(url: url)
            break
        // Open VRController
        case .VRController:
            KolibriAnalytics.logEvent(url: url, title: title)
            self.openVRViewController(url: url)
            break
        // Open Custom Controller (eg. Favorites)
        case .TargetController:
            KolibriAnalytics.logEvent(url: url, title: title)
            self.openController(menuItem: menuItem!)
            break
        }
    }
}

