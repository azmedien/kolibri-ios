//
//  KolibriSettings.swift
//  Kolibri
//
//  Created by Slav Sarafski on 24/3/17.
//  Copyright © 2017 Yanova. All rights reserved.
//


public class KolibriSettings: NSObject {
    
    //System configurations
    struct system {
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
        
        // Assets url
        static var assetsURL:String? {
            get {
                if let url = UserDefaults.standard.string(forKey: "assetsURL") {
                    return url
                }
                return nil
            }
            set {
                UserDefaults.standard.set(newValue, forKey: "assetsURL")
            }
        }
        
        // Domain is provided by runtime configurations and manage the operations with the URL
        static var scheme:String {
            get {
                if let scheme = UserDefaults.standard.string(forKey: "kolibri-scheme"){
                    return scheme
                }
                return "kolibri"
            }
            set {
                UserDefaults.standard.set(newValue, forKey: "kolibri-scheme")
            }
        }
        
        // Domain is provided by runtime configurations and manage the operations with the URL
        static var domain:String?
        
        // Bool that follow current action is it a share or not. Prevent double postiong of Events to Netmetrix after share action
        static var isSharing:Bool = false
        
        // Status of the System Configurations
        static var isSystemConfigurationLoaded:Bool = false
    }
    
    // Push notifications settings
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
    struct netMetrix {
        static var url:String? {
            get {
                if let url = UserDefaults.standard.string(forKey: "netmetrixURL") {
                    return url
                }
                else
                    if let url = Bundle.netMetrixURL() {
                        return url
                }
                return nil
            }
            set {
                UserDefaults.standard.set(newValue, forKey: "netmetrixURL")
            }
        }
        static var type:String? {
            get {
                if let type = UserDefaults.standard.string(forKey: "netmetrixType") {
                    return type
                }
                else
                    if let type = Bundle.netMetrixURL() {
                        return type
                }
                return nil
            }
            set {
                UserDefaults.standard.set(newValue, forKey: "netmetrixType")
            }
        }
    }
    
    // Log Settings
    static let logLevel:KolibriLogLevel = [.All]
    
    struct KolibriLogLevel: OptionSet {
        let rawValue: Int
        
        init(rawValue: Int) { self.rawValue = rawValue }
        
        static let All      = KolibriLogLevel(rawValue: 0)
        static let Log      = KolibriLogLevel(rawValue: 1)
        static let Warning  = KolibriLogLevel(rawValue: 2)
        static let Error    = KolibriLogLevel(rawValue: 3)
    }
    
    // NotificationsCenter
    //static var resolveNotificationAction:[String:String] = [:]
    
    //Colors
    struct style {
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
                return colors["secondaryText"] ?? .black
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
                if KolibriSettings.style.navigationBarBackground.isLight {
                    return .default
                }
                return  .lightContent
            }
        }
        
        // Overrides
        static var navigationBarBackground:UIColor {
            get {
                return colors["toolbar.background"] ?? KolibriSettings.style.primaryColor
            }
        }
        static var navigationBarItemTint:UIColor {
            get {
                return colors["toolbar.tint"] ?? KolibriSettings.style.primaryTextColor
            }
        }
        // Menu Header Colors
        static var menuHeaderBackground:UIColor {
            get {
                return colors["menu.header.background"] ?? KolibriSettings.style.primaryColor
            }
        }
        static var menuHeaderText:UIColor? {
            get {
                return colors["menu.header.text"] ?? KolibriSettings.style.primaryTextColor
            }
        }
        static var menuHeaderBorder:UIColor? {
            get {
                return colors["menu.header.border"]
            }
        }
        //Menu Body Colors
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
                return colors["menu.footer.item"] ?? KolibriSettings.style.secondaryTextColor
            }
        }
        static var menuFooterBorder:UIColor {
            get {
                return colors["menu.footer.border"] ?? KolibriSettings.style.secondaryTextColor
            }
        }
    }
    
    
    
    
    // START: Favorite stuff
    
    // END: Favorite stuff
    
    // START: Search stuff
    
    // END: Search stuff
    
    // START: EndApp stuff
    
    // END: EndApp stuff
}

