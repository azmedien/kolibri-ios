//
//  BundleExtentions.swift
//  Kolibri
//
//  Created by Slav Sarafski on 8/5/17.
//  Copyright © 2017 Yanova. All rights reserved.
//

import Foundation

// App variables
extension Bundle {
    class func mainInfoDictionary(key: String) -> String? {
        if let value = self.main.infoDictionary?[key] as? String {
            return value
        }
        return nil
    }
    class func appDisplayName() -> String? {
        return self.mainInfoDictionary(key: "CFBundleName")
    }
    class func appVersion() -> String? {
        return self.mainInfoDictionary(key: "CFBundleShortVersionString")
    }
    class func appBuild() -> String? {
        return self.mainInfoDictionary(key: "CFBundleVersion")
    }
    class func splashScreen() -> String? {
        return self.mainInfoDictionary(key: "UILaunchStoryboardName")
    }
}

// Kolibri variables
extension Bundle {
    class func configURL() -> String? {
        if  let kolibriDict = self.main.infoDictionary?["KolibriParameters"] as? [String:Any],
            let configURL = kolibriDict["kolibri_navigation_url"] as? String {
            return configURL
        }
        return nil
    }
    
    class func font(name:String) -> String? {
        if  let kolibriDict = self.main.infoDictionary?["KolibriParameters"] as? [String:Any],
            let fontsDict = kolibriDict["Fonts"] as? [String:Any],
            let fontName = fontsDict[name] as? String {
            return fontName
        }
        return nil
    }
}

// NetMetrix variables
extension Bundle {
    class func netMetrixURL() -> String? {
        if  let kolibriDict = self.main.infoDictionary?["KolibriParameters"] as? [String:Any],
            let url = kolibriDict["kolibri_netmetrix_url"] as? String {
            return url
        }
        return nil
    }
}
