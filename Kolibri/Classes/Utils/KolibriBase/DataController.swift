//
//  DataController.swift
//  Kolibri
//
//  Created by Slav Sarafski on 11/2/17.
//  Copyright © 2017 Yanova. All rights reserved.
//

import UIKit
import SwiftyJSON

class DataController: NSObject {
    
    static var shared = DataController()
    
    
    func saveSystemConfigurations(json:JSON) {
        var menu:[MenuElement] = []
        var footer:[MenuElement] = []
        
        // DOMAIN & SCHEME Save and Cahce
        if let domain = json["domain"].string {
            KolibriSettings.system.domain = domain
        }
        if let scheme = json["scheme"].string {
            KolibriSettings.system.scheme = scheme
        }
        
        // NETMETRIX URL Save and Cahce
        if let netmetrixURL = json["netmetrix"].string {
            KolibriSettings.netMetrix.url = netmetrixURL
        }
        // NETMETRIX TYPE Save and Cahce
        if let netmetrixType = json["netmetrix-type"].string {
            KolibriSettings.netMetrix.type = netmetrixType
        }
        
        // ASSETS URL Save and Cahce
        if let assetURL = json["amazon"].string {
            KolibriSettings.system.assetsURL = assetURL
        }
        
        // MENU HEADER
        let header = MenuHeader(json: json["navigation"]["header"])
        
        // MENU ITEMS
        if let array = json["navigation"]["items"].array {
            for (index, item) in array.enumerated() {
                let element = MenuElement(main: item)
                element.isDefault = json["navigation"]["settings"]["default-item"].intValue == index
                menu.append(element)
            }
        }
        // MENU FOOTER
        if let array = json["navigation"]["footer"]["items"].array {
            for item in array {
                let element = MenuElement(footer: item)
                footer.append(element)
            }
        }
        let menuHeaderArchive = NSKeyedArchiver.archivedData(withRootObject: header)
        let menuArchive = NSKeyedArchiver.archivedData(withRootObject: menu)
        let menuFooterArchive = NSKeyedArchiver.archivedData(withRootObject: footer)
        
        UserDefaults.standard.set(menuHeaderArchive, forKey: "menuHeader")
        UserDefaults.standard.set(menuArchive, forKey: "menu")
        UserDefaults.standard.set(menuFooterArchive, forKey: "menuFooter")
        
        // COLORS
        if let colorDict = json["styling"]["color-palette"].dictionary {
            KolibriSettings.style.colors = [:]
            for color in colorDict {
                let colorString = color.value.string ?? ""
                KolibriSettings.style.colors[color.key] = UIColor.hexStringToUIColor(hex: colorString)
            }
        }
        
        // START: Favorite stuff
        
        // END: Favorite stuff
        
        // START: Search stuff
        
        // END: Search stuff
        
        // START: AdTech stuff
        
        // END: AdTech stuff
        
        // START: EndApp stuff
        
        // END: EndApp stuff
    }
    
    func getMenu() -> [MenuElement]? {
        if let itemArchive = UserDefaults.standard.object(forKey: "menu") as? Data {
            let menu = NSKeyedUnarchiver.unarchiveObject(with: itemArchive) as? [MenuElement]
            return menu
        }
        return nil
    }
    func getMenuHeader() -> MenuHeader? {
        if let itemArchive = UserDefaults.standard.object(forKey: "menuHeader") as? Data {
            let header = NSKeyedUnarchiver.unarchiveObject(with: itemArchive) as? MenuHeader
            return header
        }
        return nil
    }
    func getMenuFooter() -> [MenuElement]? {
        if let itemArchive = UserDefaults.standard.object(forKey: "menuFooter") as? Data {
            let footer = NSKeyedUnarchiver.unarchiveObject(with: itemArchive) as? [MenuElement]
            return footer
        }
        return nil
    }
    
    
    func getAppLogo() -> NavigationELement? {
        return self.getNavItem(key: "appLogo")
    }
    func getMenuButton() -> NavigationELement? {
        return self.getNavItem(key: "appMenuButton")
    }
    func getNavItem(key:String) -> NavigationELement? {
        if let itemArchive = UserDefaults.standard.object(forKey: key) as? Data {
            let item = NSKeyedUnarchiver.unarchiveObject(with: itemArchive) as? NavigationELement
            return item
        }
        return nil
    }
}
