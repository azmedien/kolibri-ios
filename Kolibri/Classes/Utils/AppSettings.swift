//
//  AppSettings.swift
//  Kolibri
//
//  Created by Slav Sarafski on 24/3/17.
//  Copyright © 2017 Yanova. All rights reserved.
//

import UIKit

class AppSettings: NSObject {

    static var configURL:String {
        get {
            if let url = Bundle.configURL() {
                return url
            }
            else {
                KolibriLog.printIt(error: "Config URL was not founded. Please check info.plist.")
            }
            return ""
        }
    }

    static var domain:String?
    static var isSharing:Bool = false
    
    // NetMetrix
    static var isPushOn:Bool {
        get {
            if UserDefaults.standard.object(forKey: "pushOn") != nil{
                return UserDefaults.standard.bool(forKey: "pushOn")
            }
            return true
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "pushOn")
        }
    }
    
    // NetMetrix
    static var netМetrixURL:String? {
        get {
//            if let url = UserDefaults.standard.string(forKey: "netmetrixURL") {
//                return url
//            }
//            else
            if let url = Bundle.netMetrixURL() {
                return url
            }
            return nil
        }
    }
    
    // Assets url
    static var assetsURL:String? {
        get {
            if let url = UserDefaults.standard.string(forKey: "assetsURL") {
                return url
            }
            return nil
        }
    }
    
    // Log Settings
    static let logLevel:LogLevel = [.All]
    
    struct LogLevel: OptionSet {
        let rawValue: Int
        
        init(rawValue: Int) { self.rawValue = rawValue }
        
        static let All      = LogLevel(rawValue: 0)
        static let Log      = LogLevel(rawValue: 1)
        static let Warning  = LogLevel(rawValue: 2)
        static let Error    = LogLevel(rawValue: 3)
    }
    
    // NotificationsCenter
    static var resolveNotificationAction:[String:String] = [:]
    
    //Colors
    static var colors:[String:UIColor] {
        get {
            if let clrs = UserDefaults.standard.object(forKey: "colors") as? Data {
                return NSKeyedUnarchiver.unarchiveObject(with: clrs) as! [String:UIColor]
            }
            return [:]
        }
        set(newValue){
            let clrs = NSKeyedArchiver.archivedData(withRootObject: newValue)
            UserDefaults.standard.set(clrs, forKey: "colors")
        }
    }
    static var primaryColor:UIColor {
        get {
            return colors["primary"] ?? .white
        }
    }
    static var primaryDarkColor:UIColor {
        get {
            return colors["primaryDark"] ?? .white
        }
    }
    static var primaryLightColor:UIColor {
        get {
            return colors["primaryLight"] ?? .white
        }
    }
    static var iconsColor:UIColor {
        get {
            return colors["icons"] ?? .white
        }
    }
    static var accentColor:UIColor {
        get {
            return colors["accent"] ?? .white
        }
    }
    static var primaryTextColor:UIColor {
        get {
            return colors["primaryText"] ?? .white
        }
    }
    static var secondaryTextColor:UIColor {
        get {
            return colors["secondaryText"] ?? .white
        }
    }
    static var alternativeTextColor:UIColor {
        get {
            return colors["alternativeText"] ?? .white
        }
    }
    static var statusBarStyle:UIStatusBarStyle {
        get {
            if  let style = colors["ios.statusbar.tint"]{
                if style == .white {
                    return .lightContent
                }
                else {
                    return .default
                }
            }
            if AppSettings.navigationBarBackground.isLight {
                return .default
            }
            return  .lightContent
        }
    }
    
// Overrides
    static var navigationBarBackground:UIColor {
        get {
            return colors["toolbar.background"] ?? AppSettings.primaryColor
        }
    }
    static var navigationBarItemTint:UIColor {
        get {
            return colors["toolbar.tint"] ?? AppSettings.primaryTextColor
        }
    }
    // Menu Header Colors
    static var menuHeaderBackground:UIColor {
        get {
            return colors["menu.header.background"] ?? AppSettings.primaryColor
        }
    }
    static var menuHeaderText:UIColor? {
        get {
            return colors["menu.header.text"] ?? AppSettings.primaryTextColor
        }
    }
    static var menuHeaderBorder:UIColor? {
        get {
            return colors["menu.header.border"]
        }
    }
    //Menu Footer Colors
    static var menuBodyBackground:UIColor? {
        get {
            return colors["menu.body.background"] ?? .white
        }
    }
    //Menu Footer Colors
    static var menuFooterBackground:UIColor {
        get {
            return colors["menu.footer.bacgkround"] ?? .white
        }
    }
    static var menuFooterItem:UIColor {
        get {
            return colors["menu.footer.item"] ?? AppSettings.alternativeTextColor
        }
    }
    static var menuFooterBorder:UIColor {
        get {
            return colors["menu.footer.border"] ?? AppSettings.alternativeTextColor
        }
    }
    
    
    
    
    
    // START: Favorite stuff
    
    // END: Favorite stuff
    
    // START: Search stuff
    
    // END: Search stuff
    
    // START: EndApp stuff
    
    // END: EndApp stuff
}
